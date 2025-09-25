extends Node


func _ready() -> void:
	$".".connect("dungeon_done_generating", RemoveUnusedDoor)


func RemoveUnusedDoor():
	for door in $".".get_doors():
		if door.get_room_leads_to() != null:
			door.door_node.get_node("wall").queue_free()
