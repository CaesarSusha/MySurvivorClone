# Hitbox: I'm hitting
# HurtBox: I'm hurting
extends Area2D

# defines the style of the hitbox
@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

# signal: build-in condition, taht casn trigger a function in another script
# aretype can detect collisions => sends signal
# exmp hitbox enters the hurtbox => then we send a signal
signal hurt(damage)

#####THEORY TIME######
# Signal Up: use signals to call a parent script
# Call Down: don't call a function of a parent



func _on_area_entered(area):
	# area: area that enters this one (hitBox)
	if area.is_in_group("attack"): 
		# does the area have the variable damage? 
		# we need it to have it, or erros will occur
		if not area.get("damage") == null:
			# pretty much a switch statement
			match HurtBoxType: 
				0: # Cooldown
					# disable collisionshape for specified time
					collision.call_deferred("set", "disabled", true)
					#start the timer
					# when timer is done it will be reanabled
					disableTimer.start() 
				1: # HitOnce
					pass
				2: # DisableHitBox
					# user defined method
					if area.has_method("tempdisable"): 
						#disable the method if it has it
						area.tempdisable()	
			var damage = area.damage
			# when we emit the signal it's going to send in the areas damage 
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)
			
						


func _on_disable_timer_timeout():
# enable collisionshape
	collision.call_deferred("set", "disabled", false)

