extends Camera3D


@onready var player: CharacterBody3D = %Player

@export var y_offset : int = 16

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position + Vector3(0,y_offset,0)
