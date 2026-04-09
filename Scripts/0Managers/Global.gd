extends Node

var which_scene : String
var which_loading_screen : String

func loadscreen(target : String) -> void:
	if !which_loading_screen:
		which_loading_screen = "res://Scenes/map/LoadingScreeneng.tscn"
	var loading_screen : CanvasLayer = load(which_loading_screen).instantiate()
	loading_screen.next_scene_path = target
	await get_tree().create_timer(0.1).timeout
	get_tree().current_scene.add_child(loading_screen)
