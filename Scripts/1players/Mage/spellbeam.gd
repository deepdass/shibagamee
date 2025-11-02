extends Node3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

#@onready var hiteffect : PackedScene = preload("res://Assets/_my/vfx/hiteffects/hiteffect_scene.tscn")
#@onready var effect : PackedScene = preload("res://Assets/_my/vfx/fire/vfire.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hitbox: RayCast3D = $hitbox
var is_colliding : bool = false
var fired : bool = false

@onready var cast_speed : int = 40
@onready var maxlenght : int = 200


#var forward_direction : Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	hitbox.target_position.z = move_toward(hitbox.target_position.z , maxlenght, cast_speed * delta)
	
	
	if hitbox.is_colliding() and fired:
		attack_thisenemy(hitbox.get_collider())
	else:
		is_colliding = false
		
	if !animation_player.is_playing():
		queue_free()
	
	#global_translate(forward_direction * projectile_speed * delta)
	
#func attack_thisenemy(enemy_ref : CharacterBody3D) -> void:
	#if enemy_ref != null:
		#forward_direction = (enemy_ref.collision_shape_3d.global_position - global_position).normalized()
	#else:
		#forward_direction = global_transform.basis.z.normalized()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func attack_thisenemy(hit) -> void:
	if hit.has_method("take_damage"):
		hit.take_damage()
		#spawn_hiteffect(body)
		
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
