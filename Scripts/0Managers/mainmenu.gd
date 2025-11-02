extends Control

var overworld : String = "res://Scenes/map/overWorld.tscn"

var underworld : String = "res://Scenes/map/underWorld.tscn"
var PDG_underworld : String = "res://Scenes/map/PDG_underWorld.tscn"

@onready var play_panel: Panel = $"Play panel"

func _on_b_play_pressed() -> void:
	play_panel.visible = true
	
func _on_b_quit_pressed() -> void:
	get_tree().quit()


#######################
func _on_pdg_pressed() -> void:
	Global.which_scene = PDG_underworld
	get_tree().change_scene_to_file(overworld)

func _on_handcraft_pressed() -> void:
	Global.which_scene = underworld
	get_tree().change_scene_to_file(overworld)

func _on_back_pressed() -> void:
	play_panel.visible = false
