#Hitbox: I'm hitting
#HurtBox: I'm hurting
extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitBoxTimer

func tempdisable():
	#disable hitbox collision ofr a specified time
	collision.call_deferred("set","disabled",true)
	disableTimer.start()


func _on_disable_hit_box_timer_timeout():
	#enable hitbox collision
	collision.call_deferred("set","disabled",false)	
