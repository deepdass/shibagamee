extends Node

var which_scene : String
var which_loading_screen : String

func loadscreen(target : String) -> void:
	var loading_screen = load(which_loading_screen).instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)
