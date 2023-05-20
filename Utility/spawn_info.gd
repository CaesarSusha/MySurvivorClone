extends Resource

class_name Spawn_info

@export var time_start:int
@export var time_end:int
@export var enemy:Resource
@export var enemy_num:int

#seconds of delay between spawns
@export var enemy_spawn_delay:int

#tracks the delayed seconds
var spawn_delay_counter = 0
