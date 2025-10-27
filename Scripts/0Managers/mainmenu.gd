extends Control

@onready var overworld : String = "res://Scenes/map/overWorld.tscn"


func _on_b_play_pressed() -> void:
	get_tree().change_scene_to_file(overworld)
