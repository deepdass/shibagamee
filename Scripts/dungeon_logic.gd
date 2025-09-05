extends Node

@onready var spwans: Node3D = $"../SubViewportContainer/SubViewport/all/spwans"
@onready var navigation_region_3d: NavigationRegion3D = $"../SubViewportContainer/SubViewport/all/NavigationRegion3D"
@onready var collision_shape_3d_2: CollisionShape3D = $"../SubViewportContainer/SubViewport/all/door/CollisionShape3D2"
@onready var player: CharacterBody3D = %Player

var skeleton_minion = load("res://Scenes/skeleton_minion.tscn")
var inst_skeleton_minion

func _ready() -> void:
	pass

func _get_random_child(parent_node):
	var randomID = randi() % parent_node.get_child_count()
	return parent_node.get_child(randomID)
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		var spawn_pt = _get_random_child(spwans).global_position
		inst_skeleton_minion = skeleton_minion.instantiate()
		inst_skeleton_minion.position = spawn_pt
		navigation_region_3d.add_child(inst_skeleton_minion)
		
		collision_shape_3d_2.disabled = false
	
	
