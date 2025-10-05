extends Node3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var hiteffect : PackedScene = preload("res://Assets/_my/vfx/hiteffects/hiteffect_scene.tscn")

var projectile_speed : int = 30
var timer:int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var forward_direction : Vector3 = global_transform.basis.z.normalized()
	global_translate(forward_direction * projectile_speed * delta)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.has_method("take_damage"):
		body.take_damage()
	elif body is RigidBody3D:
		pass
	elif !body.has_method("decrease_health"):
		audio_stream_player.stop()
		var hiteffect_inst : Node3D = hiteffect.instantiate()
		hiteffect_inst.position = position
		get_tree().get_current_scene().add_child(hiteffect_inst)
		queue_free()
