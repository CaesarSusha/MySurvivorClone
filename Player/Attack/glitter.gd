extends Area2D

var level = 1
var damage = 5
var attack_size

@onready var player = get_tree().get_first_node_in_group("player")


#func _on_body_entered(body):
#	pass # Replace with function body.
#
#
#func _on_body_exited(body):
#	pass # Replace with function body.


func _ready():
	global_position = player.global_position
	match level:
		1:
			damage = 5
			attack_size = 1.0
	#var tween = create_tween()
	#          (node that you want to change, property, value, time)
	#tween.tween_property(self,"scale", Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#tween.play()
	

func _physics_process(delta):
	position = player.position*delta

func _on_glitter_ttl_timeout():
	queue_free()



