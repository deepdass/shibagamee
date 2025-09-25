extends Node

var power_up_Chest : PackedScene = load("res://Scenes/powerUPs/PowerUp_chest.tscn")

var player : CharacterBody3D = null
@onready var player_path := "/root/World/SubViewportContainer/SubViewport/myy/per/Player"

var enemySCENEs : Dictionary = {"minion" : preload("res://Scenes/characters/enemy/skeleton_minion.tscn"),
 								"rogue" : preload("res://Scenes/characters/enemy/skeleton_rogue.tscn")
								}

var num_enemyCount : int
@onready var enemy_spawns : Node3D = $"../NavigationRegion3D/spwans"

@onready var doors : Node = $"../NavigationRegion3D/env/door_Container"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)
	convert_gridmap_to_meshes(grid_map_walls)
	convert_gridmap_to_meshes(grid_map_floor)
	convert_gridmap_to_meshes(grid_map_props)





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
		
		

@onready var grid_map_walls: GridMap = $"../NavigationRegion3D/env/walls"
@onready var grid_map_floor: GridMap = $"../NavigationRegion3D/env/floor"
@onready var grid_map_props: GridMap = $"../NavigationRegion3D/env/props"

@onready var mesh_parent: Node3D = $"../allmesh"

func convert_gridmap_to_meshes(grid_map: GridMap) -> void:
	if not grid_map or not grid_map.mesh_library:
		push_warning("GridMap invalid or has no MeshLibrary: %s" % str(grid_map))
		return

	var mesh_library: MeshLibrary = grid_map.mesh_library

	for cell: Vector3i in grid_map.get_used_cells():
		var item_index: int = grid_map.get_cell_item(cell)
		if item_index == GridMap.INVALID_CELL_ITEM:
			continue

		var mesh: Mesh = mesh_library.get_item_mesh(item_index)
		if mesh == null:
			continue

		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = mesh

		# Position & orientation
		var basis: Basis = grid_map.get_cell_item_basis(cell)
		var local_pos: Vector3 = grid_map.map_to_local(cell)
		var local_transform := Transform3D(basis, local_pos)

		mesh_instance.global_transform = grid_map.global_transform * local_transform
		mesh_parent.add_child(mesh_instance)

		# --- COLLISION GENERATION ---
		var shape := mesh.create_trimesh_shape()
		if shape:
			var body := StaticBody3D.new()
			var collider := CollisionShape3D.new()
			collider.shape = shape
			body.add_child(collider)
			mesh_instance.add_child(body)

	grid_map.queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		print("yess")
		for door in doors.get_children():
			door.get_node("Area3D").queue_free()
		closeDoors()
		spawnEnemy()
