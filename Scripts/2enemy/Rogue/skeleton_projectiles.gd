extends Node3D

var projectile_speed : int = 15
var timer:int = 0

var KnockbackMul : int = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var forward_direction : Vector3 = global_transform.basis.z.normalized()
	global_translate(forward_direction * projectile_speed * delta)
	

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("decrease_health"):
		body.decrease_health()
		var dir : Vector3 = global_position.direction_to(body.global_position)
		body.velocity += Vector3(dir.x , dir.y * 0.1, dir.z ) * KnockbackMul
		body.game_manager.shakeCamera(0.1,0.05)
	elif !body.has_method("take_damage"):
		queue_free()
	
