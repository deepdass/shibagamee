extends Node3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var rigid: RigidBody3D = $rigid

#@onready var hiteffect : PackedScene = preload("res://Assets/_my/vfx/hiteffects/hiteffect_scene.tscn")
#@onready var effect : PackedScene = preload("res://Assets/_my/vfx/fire/vfire.tscn")

@onready var hitbox: RayCast3D = $hitbox

#var forward_direction : Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#global_translate(forward_direction * projectile_speed * delta)
	
#func attack_thisenemy(enemy_ref : CharacterBody3D) -> void:
	#if enemy_ref != null:
		#forward_direction = (enemy_ref.collision_shape_3d.global_position - global_position).normalized()
	#else:
		#forward_direction = global_transform.basis.z.normalized()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func attack_thisenemy(idk) -> void:
	if hitbox.is_colliding():
		var body = hitbox.get_collider()
		if body.has_method("take_damage"):
			body.take_damage()
			#spawn_hiteffect(body)
		elif !body.has_method("decrease_health") and body != rigid:
			
			if body is RigidBody3D:
				var dir : Vector3 = (body.global_position - global_position).normalized()
				body.apply_impulse(dir * 5000)  # tweak force value
			
			#audio_stream_player.stop()
			#spawn_hiteffect(null)



#func spawn_hiteffect(body) -> void:
	#var hiteffect_inst : Node3D = hiteffect.instantiate()
	#hiteffect_inst.position = position
	#get_tree().get_current_scene().add_child(hiteffect_inst)
	#if body != null:
		#var effect_inst : Node3D = effect.instantiate()
		#body.add_child(effect_inst)
		#var effect_player : AnimationPlayer = effect_inst.get_node("AnimationPlayer")
		#effect_player.play("firestart")
		#if body.Stat.health <= 0:
			#effect_inst.queue_free()
