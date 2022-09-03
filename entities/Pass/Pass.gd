extends Area2D

export(Resource) var CONNECTION_BETWEEN_PASS = null
export(String, FILE, "*.tscn") var LEVEL_SCENE_PATH = ""


export var active = true




func _on_Pass_body_entered(Player):
	if(active == true):
		Player.emit_signal("hit_pass", self)
		active = false		
