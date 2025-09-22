@tool
extends Node3D

const  SPAWN_ROOMS : Array = [preload("res://Scenes/rooms/allROOMS/Room_001.tscn")]
const INTERMEDIATE_ROOMS : Array = [ preload("res://Scenes/rooms/allROOMS/room_003.tscn")]
const  END_ROOMS : Array = [preload("res://Scenes/rooms/allROOMS/Room_002.tscn")]

const TILE_SIZE : int = 2
const FLOOR_TILE_INDEX : int = 29
const WALL_TILE_INDEX = 59

@export var num_levels: int = 6

@onready var player_parent : Node = get_parent().get_node("per")


@export var start : bool = false : set = set_start

@export var room_number : int = 4
@export var room_margin : int = 1
@export var room_recursion : int = 15
@export var min_room_size : int = 2
@export var max_room_size : int = 4

func set_start(val:bool)->void:
	if Engine.is_editor_hint():
		generate()

@export var border_size : int = 20 : set = set_border_size

func set_border_size(val : int):
	border_size = val
	visualize_border()
	
func visualize_border():
	print(border_size)
	

func generate():
	for i in range(num_levels):
		spawn_room(i)



func spawn_room(i):
	
	var width : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	
	var start_pos : Vector3i 
	start_pos.x = randi() % (border_size - width + 1)
	start_pos.z = randi() % (border_size - height + 1)
	
	var previous_room: Node3D
	
	var room: Node3D

	if i == 0:
		room = SPAWN_ROOMS.pick_random().instantiate()
		player_parent.get_node("Player").position = room.get_node("PlayerSpawnPos").position
		player_parent.get_node("camera_rig").position = room.get_node("PlayerSpawnPos").position
	else:
		if i == num_levels - 1:
			room = END_ROOMS.pick_random().instantiate()
		else:
			room = INTERMEDIATE_ROOMS.pick_random().instantiate()
			
			



#func _ready() -> void:
	#_spawn_room()
#
#func _spawn_room():
	#var previous_room: Node3D
	#
	#for i in range(num_levels):
		#var room: Node3D
#
		#if i == 0:
			#room = SPAWN_ROOMS.pick_random().instantiate()
			#player_parent.get_node("Player").position = room.get_node("PlayerSpawnPos").position
			#player_parent.get_node("camera_rig").position = room.get_node("PlayerSpawnPos").position
		#else:
			#if i == num_levels - 1:
				#room = END_ROOMS.pick_random().instantiate()
			#else:
				#room = INTERMEDIATE_ROOMS.pick_random().instantiate()
				#
				#
			## === Corridor generation ===
			#var prev_grid_floor: GridMap = previous_room.get_node("NavigationRegion3D/env/floor")
			#var prev_grid_walls: GridMap = previous_room.get_node("NavigationRegion3D/env/walls")
			#
			#var prev_doors: Array = previous_room.get_node("NavigationRegion3D/env/door_Container").get_children()
			#var prev_door: Node3D = prev_doors.pick_random()
			#
			#var new_doors: Array = room.get_node("NavigationRegion3D/env/door_Container").get_children()
			#var new_door: Node3D = new_doors.pick_random()
#
			#
			## Convert door position to grid cell
			#var exit_cell: Vector3i = prev_grid_floor.local_to_map(prev_door.position) + Vector3i(0, 0, -1)
#
			#var corridor_length: int = randi() % 5 + 2
			#for z in range(corridor_length):
				#prev_grid_walls.set_cell_item(exit_cell + Vector3i(-1, -1, -z), WALL_TILE_INDEX)
				#prev_grid_walls.set_cell_item(exit_cell + Vector3i(0, -1, -z), WALL_TILE_INDEX)
				#prev_grid_floor.set_cell_item(exit_cell + Vector3i(-1, -1, -z), FLOOR_TILE_INDEX)
				#prev_grid_floor.set_cell_item(exit_cell + Vector3i(0, -1, -z), FLOOR_TILE_INDEX)
#
			## === Position new room ===
			#var corridor_offset: Vector3 = Vector3(0, 0, -corridor_length * TILE_SIZE)
			#var target_transform: Transform3D = prev_door.global_transform.translated(corridor_offset)
#
			## Align new room entrance with previous door + corridor
			#room.global_transform = target_transform * new_door.transform.affine_inverse()
#
		#add_child(room)
		#previous_room = room
