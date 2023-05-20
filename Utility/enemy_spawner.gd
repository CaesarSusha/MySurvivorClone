extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0


# we run this timer every second
func _on_timer_timeout():
	# increase time by one
	time += 1
	# this is the array filled with spawn_infos (export array)
	var enemy_spawns = spawns 
	# for every Spawn_info object
	for i in enemy_spawns:
		# if time it is between them, we continue the script
		if time >= i.time_start and time <= i.time_end: 
			# check if our counter has reached the arays delay
			# if there is still delay left, we have to wait further
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				# increase our counter by 1
				i.spawn_delay_counter += 1
			else:
				# reset the coutner
				i.spawn_delay_counter = 0
				# load in the enemy
				var new_enemy = i.enemy
				var counter = 0
				# spawn in number of enemies
				# enemy_num: number of enemies that we want to spawn
				while counter < i.enemy_num:
					#creates an instance of packed scene
					var enemy_spawn = new_enemy.instantiate()
					# get a random position
					enemy_spawn.global_position = get_random_position()
					# actually spawn the enemy
					add_child(enemy_spawn)
					# increase counter util all enemies are spawned
					counter += 1

func get_random_position():
	# Vector2(640,360)*(1,25)
	# make it a bit larger than the edges of the screen
	# this way the enemies will spawn outside of the screen
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	# set all the corners
	# since the player is the middle, we divide by 2
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	# picks a random value that is in this array (picks a side)
	var pos_side = ["up", "down", "right", "left"].pick_random()
	# initiate spawnpoints
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
			
	# get a value between the points
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
			
			
		
