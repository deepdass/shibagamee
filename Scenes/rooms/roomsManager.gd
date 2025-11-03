extends Marker3D

@export var roomsCount : int 

const portal : PackedScene = preload("res://Scenes/rooms/portal.tscn")

var PortalSpawned : bool = false

func _ready() -> void:
	randomize()
	
func _process(_delta: float) -> void:
	if PortalSpawned:
		call_deferred("spawnPortal")
	
func spawnPortal() -> void:
	var rooms : Array = get_children()
	var room : Node3D = rooms.pick_random()
	var winpt : Marker3D = room.find_child("winPortal", true, false)
		
	if winpt != null:
		var portal_inst : Node3D = portal.instantiate()
		room.add_child(portal_inst)
		portal_inst.position = winpt.position
		portal_inst.global_rotation = winpt.rotation
		PortalSpawned = false
func ChangeroomCount() -> void:
	roomsCount -= 1
	if roomsCount == 0:
		PortalSpawned = true
