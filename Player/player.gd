extends CharacterBody2D

var movement_speed = 40.0
var hp = 80

# Attacks
var knife = preload("res://Player/Attack/knife.tscn")
var glitter = preload("res://Player/Attack/glitter.tscn")

# AttackNodes
@onready var knifeReloadTimer = get_node("%KnifeReloadTimer")
@onready var knifeTriggerTimer = get_node("%KnifeTriggerTimer")

@onready var glitterActiveTimer = get_node("%GlitterActiveTimer")
@onready var glitterDelayTimer = get_node("%GlitterDelayTimer")
#@onready var glitterPositioningTimer = get_node("%GlitterPositioningTimer")

signal remove_glitter()

# Knife
var knife_ammo = 0
var knife_base_ammo = 1
var knife_attackspeed = 1.5
var knife_level = 1

#Glitter
var glitter_level = 1
var glitter_attackspeed = 2
var glitter_attack


# Enemy Related
# track all the enemies that are close to us
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("walkTimer")

func _ready():
	attack()

func attack():
	if knife_level > 0:
		knifeReloadTimer.wait_time = knife_attackspeed
		if knifeReloadTimer.is_stopped():
			knifeReloadTimer.start()
	
	if glitter_level > 0:
		glitterDelayTimer.wait_time = glitter_attackspeed
		if glitterDelayTimer.is_stopped():
			glitterDelayTimer.start()




# delta: 1 second divided by the frame rate
func _physics_process(_delta): #runs every 1/60 seconds 
		if not glitterActiveTimer.is_stopped():
			glitter_attack.position = position
		movement()
		
func movement(): #assuming 'd' is being pressed
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left") #x_mov = 0-1 = 1
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")  #y_mov = 0-0 = 0
	var mov = Vector2(x_mov, y_mov)  #mov = Vector2(1x,0y)
		
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
		

		
#	if mov.x > 0:
#		$Sprite2D/PlayerAnimation.play("walk_right")
#	elif mov.x < 0:
#		$Sprite2D/PlayerAnimation.play("walk_left")
#	elif mov.y < 0:
#		$Sprite2D/PlayerAnimation.play("walk_up")
#	elif mov.y > 0:
#		$Sprite2D/PlayerAnimation.play("walk_down")
		
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed  #velocity = Vector2(1x,0y)*40.0 = Vector2(40x,0y)
	move_and_slide()
	
	


func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)

# loading your ammunition
func _on_knife_reload_timer_timeout():
	knife_ammo += knife_base_ammo
	knifeTriggerTimer.start()

# shooting a machine gun
func _on_knife_trigger_timer_timeout():
		if knife_ammo > 0:
			var knife_attack = knife.instantiate()
			knife_attack.position = position
			knife_attack.target = get_random_target()
			knife_attack.level = knife_level
			# spawn knife
			add_child(knife_attack)
			# we now used up a 'bullet'
			# so we remove one bullet from ammo
			knife_ammo -= 1
			# check if we have ammo left
			if knife_ammo > 0:
				knifeTriggerTimer.start()
			else:
				knifeTriggerTimer.stop()
		
func get_random_target():
	# if there are enemies nearby
	if enemy_close.size() > 0:
		# get the global position of a random enemy which is close
		return enemy_close.pick_random().global_position
	else:
		# if there are no close enemies, we return fo rthe sake of returning
		return Vector2.UP

# append body to enemy_close array when it enters the area
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

# remove body from enemy_close array when it exits the area (or despawns)
func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
		
func _on_glitter_delay_timer_timeout():
	glitter_attack = glitter.instantiate()
	glitter_attack.position = position
	glitter_attack.level = glitter_level
	# spawn the glitter
	add_child(glitter_attack)
	glitterActiveTimer.start()
	#glitter_attack.GlitterTTL.start()
	
func _on_glitter_active_timer_timeout():
	#tween.tween_property(self,"scale", Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#tween.play()
	#emit_signal("remove_glitter")
	glitterDelayTimer.start()

		
		
