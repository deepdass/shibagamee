extends Node

const  SPAWN_ROOMS : Array = []
const INTERMEDIATE_ROOMS : Array = []
const  END_ROOMS : Array = []

const TILE_SIZE : int= 16
const FLOOR_TILE_INDEX : int = 30
const WALL_TILE_INDEX = 60

@export var num_levels: int = 7

@onready var player : CharacterBody3D = get_parent().get_node("Player")


func _ready() -> void:
	_spawn_room()

func _spawn_room():
	pass
