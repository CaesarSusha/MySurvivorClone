extends Area2D

var level = 1
# how many enemies does it survive
var hp = 1
var speed = 100
var damage = 5
var knockback = 100
var attack_size

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	# set angle to a vector2 value 
	# by comparing the glob pos of the icespear to the target
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 2
			speed = 100
			damage = 5
			knockback = 100
			attack_size = 1.0
			
	var tween = create_tween()
	#          (node that you want to change, property, value, time)
	tween.tween_property(self,"scale", Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle*speed*delta
	
# is called every tim the spear hits and enemy
# is called from hurt box
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free() # delete ice spear

# time to live if it misses and enemy
func _on_ttl_timeout():
	queue_free()
