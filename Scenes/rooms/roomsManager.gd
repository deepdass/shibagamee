extends Marker3D

@export var roomsCount : int 

@onready var portal : PackedScene = preload("res://Scenes/rooms/portal.tscn")

var PortalSpawned : bool = false

func _ready() -> void:
	randomize()
	
func _process(_delta: float) -> void:
	if PortalSpawned:
		call_deferred("spawnPortal")
	
func spawnPortal():
	var rooms = get_children()
	var room = rooms.pick_random()
	var winpt = room.find_child("winPortal", true, false)
		
	if winpt != null:
		var portal_inst = portal.instantiate()
		room.add_child(portal_inst)
		portal_inst.position = winpt.position
		portal_inst.global_rotation = winpt.rotation
		PortalSpawned = false
func ChangeroomCount():
	roomsCount -= 1
	if roomsCount == 0:
		PortalSpawned = true
