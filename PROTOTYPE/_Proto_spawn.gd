extends Node3D


@export var whichscene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.7).timeout
	var thisscene : Node3D = whichscene.instantiate()
	self.add_child(thisscene)
	thisscene.global_position = self.global_position
