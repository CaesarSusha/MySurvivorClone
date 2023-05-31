extends CharacterBody2D

#move towards the player

@export var movement_speed = 20.0
@export var hp = 10

#get tree is a level beyond world, tree would be the parent of the world
#game starts -> enemy goes to the root of the scene 
#            -> get the first node you can find in the group player
#			 -> enemy now konow, what th eplayer is
@onready var player = get_tree().get_first_node_in_group("player") 
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

 #runs once at the very beginning"res://Textures/Enemy/KittyBetterFeet.png"
func _ready():
	anim.play("walk")


func _physics_process(_delta):
	# global position: pos of enemy relevant to the tree
	# calculation to compare global pos of the enemy to the players global pos
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	move_and_slide()

	if direction.x > 0.1:
			sprite.flip_h = true
	elif direction.x < -0.1:
			sprite.flip_h = false
	


func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
		#deletes the enemy from the game
		queue_free() 
