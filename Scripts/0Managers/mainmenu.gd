extends Control

const overworld : String = "res://Scenes/map/overWorld.tscn"

const underworld : String = "res://Scenes/map/underWorld.tscn"
const PDG_underworld : String = "res://Scenes/map/PDG_underWorld.tscn"

@onready var play_panel: Panel = $"Play panel"
@onready var options_panel: Panel = $"options panel"

	
func _on_b_quit_pressed() -> void:
	get_tree().quit()


#######################
func _on_b_play_pressed() -> void:
	options_panel.visible = false
	if !play_panel.visible:
		play_panel.visible = true
	else:
		play_panel.visible = false

func _on_pdg_pressed() -> void:
	Global.which_scene = PDG_underworld
	get_tree().change_scene_to_file(overworld)

func _on_handcraft_pressed() -> void:
	Global.which_scene = underworld
	get_tree().change_scene_to_file(overworld)

func _on_back_pressed() -> void:
	play_panel.visible = false
	options_panel.visible = false

#########################

func _on_b_option_pressed() -> void:
	play_panel.visible = false
	if !options_panel.visible:
		options_panel.visible = true
	else:
		options_panel.visible = false


func _on_changelang_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/map/SelectLang.tscn")
