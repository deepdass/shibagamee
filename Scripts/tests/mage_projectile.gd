extends Node3D

var projectile_speed = 30
var timer:int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * projectile_speed * delta)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("taka_damage"):
		body.taka_damage()
