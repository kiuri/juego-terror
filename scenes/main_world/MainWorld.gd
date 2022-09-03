extends Node2D

onready var currentLevel = $Level_00

func _on_Player_hit_pass(pass_door):
	call_deferred("pass_to_level", pass_door)

func pass_to_level(pass_door):
	#current position last level
	var offset = currentLevel.position
	currentLevel.queue_free()
	#get scene path from pass_door
	var NewLevel = load(pass_door.LEVEL_SCENE_PATH)
	var newLevelInstance = NewLevel.instance()
	add_child(newLevelInstance)	
	var newConnectionPass = get_pass_with_connection(pass_door, pass_door.CONNECTION_BETWEEN_PASS)
	var exitPosition = newConnectionPass.position - offset
	newLevelInstance.position = pass_door.position - exitPosition

func get_pass_with_connection(notPass, connection):
	#NEED PASS SCENE IN GROUP Pass
	var all_pass = get_tree().get_nodes_in_group("Pass")
	#search pass_door that allow return to last level scene
	for pass_door in all_pass:		
		#pass with same connection but different pass
		if(pass_door.CONNECTION_BETWEEN_PASS == connection and pass_door != notPass):
			return pass_door
	return null
