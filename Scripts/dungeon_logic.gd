extends Node

@onready var spwans: Node3D = $"../SubViewportContainer/SubViewport/myy/NavigationRegion3D/spwans"
@onready var navigation_region_3d: NavigationRegion3D = $"../SubViewportContainer/SubViewport/myy/NavigationRegion3D"
@onready var player: CharacterBody3D = %Player

var skeleton_minion = load("res://Scenes/characters/enemy/skeleton_minion.tscn")
var skeleton_rogue = load("res://Scenes/characters/enemy/skeleton_rogue.tscn")
var inst_skeleton_minion
var inst_skeleton_rouge

var choices: Array = [[inst_skeleton_minion, skeleton_minion],[inst_skeleton_rouge, skeleton_rogue]]

func _ready() -> void:
	pass

func _get_random_child(parent_node):
	var randomID = randi() % parent_node.get_child_count()
	return parent_node.get_child(randomID)
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		for i in 5:
			var spawn_pt = _get_random_child(spwans).global_position + Vector3(randi_range(1,5),0,randi_range(1,5))
			var choice = randi_range(0,1)
			choices[choice][0] = choices[choice][1].instantiate()
			choices[choice][0].position = spawn_pt
			navigation_region_3d.add_child(choices[choice][0])
	
