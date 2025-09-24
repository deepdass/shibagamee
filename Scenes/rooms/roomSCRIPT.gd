extends Node

@export var grid_map_node: GridMap
@export var parent_for_meshes: Node3D # Where the new MeshInstance3D nodes will be added


var power_up_Chest : PackedScene = load("res://Scenes/powerUPs/PowerUp_chest.tscn")

var player : CharacterBody3D = null
@onready var player_path := "/root/World/SubViewportContainer/SubViewport/myy/per/Player"

var enemySCENEs : Dictionary = {"minion" : preload("res://Scenes/characters/enemy/skeleton_minion.tscn"),
 								"rogue" : preload("res://Scenes/characters/enemy/skeleton_rogue.tscn")
								}

var num_enemyCount : int
@onready var enemy_spawns : Node3D = $NavigationRegion3D/spwans

@onready var doors : Node = $NavigationRegion3D/env/door_Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if grid_map_node and parent_for_meshes:
		convert_gridmap_to_meshes()


func convert_gridmap_to_meshes():
	if not grid_map_node.mesh_library:
		print("GridMap has no MeshLibrary assigned.")
		return

	var mesh_library = grid_map_node.mesh_library
	var cell_size = grid_map_node.cell_size

	for x in range(grid_map_node.get_used_rect().position.x, grid_map_node.get_used_rect().end.x):
		for y in range(grid_map_node.get_used_rect().position.y, grid_map_node.get_used_rect().end.y):
			for z in range(grid_map_node.get_used_rect().position.z, grid_map_node.get_used_rect().end.z):
				var item_index = grid_map_node.get_cell_item(x, y, z)
				if item_index != GridMap.INVALID_CELL_ITEM:
					var mesh = mesh_library.get_item_mesh(item_index)
					if mesh:
						var new_mesh_instance = MeshInstance3D.new()
						new_mesh_instance.mesh = mesh

						var cell_world_pos = grid_map_node.map_to_world(Vector3i(x, y, z))
						new_mesh_instance.global_transform.origin = cell_world_pos

						var orientation_index = grid_map_node.get_cell_item_orientation(x, y, z)
						var rotation_basis = grid_map_node.get_basis_from_orientation(orientation_index)
						new_mesh_instance.global_transform.basis = rotation_basis

						parent_for_meshes.add_child(new_mesh_instance)

	grid_map_node.queue_free() # Optional: Remove the GridMap after conversion
	player = get_node(player_path)


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	for door in doors.get_children():
		door.get_node("Area3D").queue_free()
	if body == player:
		closeDoors()
		spawnEnemy()


func spawnEnemy():
	for whichpt in enemy_spawns.get_children():
		num_enemyCount += 1
		var keys = enemySCENEs.keys()
		var enemy = enemySCENEs[keys.pick_random()].instantiate()
		enemy.position = whichpt.global_position
		get_node("NavigationRegion3D").add_child(enemy)
			
		enemy.died.connect(_on_enemy_killed)

func _on_enemy_killed():
	num_enemyCount -= 1
	if num_enemyCount == 0:
		openDoors()
		var power_up_Chest_inst = power_up_Chest.instantiate()
		power_up_Chest_inst.position = player.position + Vector3(0, 10, 0)
		get_tree().get_current_scene().add_child(power_up_Chest_inst)

func openDoors():
	for door in doors.get_children():
		door.get_node("doorBlock").disabled = true

func closeDoors():
	for door in doors.get_children():
		door.get_node("doorBlock").disabled = false
