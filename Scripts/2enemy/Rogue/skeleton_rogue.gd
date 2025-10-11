extends CharacterBody3D

var subViewport : SubViewport = null
var player : CharacterBody3D = null
@onready var player_path : String = "/root/World/SubViewportContainer/SubViewport/myy/per/Player"
@onready var sub_viewport_path : String = "/root/World/SubViewportContainer/SubViewport"

@onready var skeleton_rogue_eyes: MeshInstance3D = $Skeleton_Rogue/Rig/Skeleton3D/Skeleton_Rogue_Eyes
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var health : float = 150
@export var projectile : PackedScene
@onready var fireposnode : Node3D = $fireposnode

@onready var idk: Marker3D = $idk
@onready var damagepopup: Label3D = $idk/damagepopup
@export var projectile_speed : int = 13


const  SPEED : float = 3.0
const ATTACK_RANGE : int = 10
var state_machine : AnimationNodeStateMachinePlayback

const enem_KnockbackMul : int = 45

@onready var animation_tree: AnimationTree = $Skeleton_Rogue/AnimationTree
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer


@onready var destroyaftertime: Timer = $destroyaftertime

var player_hitpos : CollisionShape3D

var disfrom_player : float

signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	timer.wait_time = animation_tree.get_animation("Death_C_Skeletons").length + 0.3
	
	player = get_node(player_path)
	player_hitpos = player.get_node("Player Capsule")
	subViewport = get_node(sub_viewport_path)
	
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/conditions/Resurrect",true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_menear()
	
	velocity = Vector3.ZERO
	idk.look_at(subViewport.get_camera_3d().global_position)
	
	match state_machine.get_current_node():
		"Walking_A":
			navigation_agent_3d.set_target_position(player.global_transform.origin)
			var next_pt : Vector3 = navigation_agent_3d.get_next_path_position()
			velocity = (next_pt - global_transform.origin).normalized() * SPEED
			
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
			global_rotation.y = lerp_angle(global_rotation.y, atan2(-global_rotation.x, -global_rotation.z), delta * 10)
		"1H_Melee_Attack_Stab":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	
	animation_tree.set("parameters/conditions/attack", _target_in_range())
	animation_tree.set("parameters/conditions/run", !_target_in_range())
	
	move_and_slide()

func set_menear() -> void:
	if health >= 0:
		disfrom_player = (player.global_position - global_position).length()
		if disfrom_player < player.StatsManager.nearestEnemy_distance:
			player.StatsManager.nearestEnemy = self


func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _hitfinish() -> void:
	if global_position.distance_to(player.global_position) < ATTACK_RANGE :
		var new_projectile : Node3D = projectile.instantiate()
		new_projectile.global_transform = fireposnode.global_transform
		new_projectile.projectile_speed = projectile_speed
		get_tree().get_current_scene().add_child(new_projectile)
		new_projectile.set_player_ref(player_hitpos)
		
		
func take_damage() -> void:
	var damageRec : float = player.StatsManager.effective_damage()
	health -= damageRec
	
	var fallChance : int = randi_range(0,100)
	if fallChance < 10:
		collision_shape_3d.disabled = true
		timer.start()
		animation_tree.set("parameters/conditions/fall",true)
		audio_stream_player.play()
	else:
		var dir : Vector3 = -global_position.direction_to(player.global_position)
		velocity = Vector3.ZERO
		velocity += Vector3(dir.x , dir.y * 0.1, dir.z ) * enem_KnockbackMul
		move_and_slide()
	
	damagepopup.text = "%.1f" % damageRec
	showDmg()
	if health <= 0:
		emit_signal("died")
		collision_shape_3d.disabled = true
		skeleton_rogue_eyes.visible = false
		audio_stream_player.play()
		animation_tree.set("parameters/conditions/fall",true)
		animation_tree.set("parameters/conditions/Resurrect",false)
		destroyaftertime.start()
		
		player.StatsManager.nearestEnemy = null
		player.StatsManager.nearestEnemy_distance = INF
	
func showDmg()  -> void:
	if player.StatsManager.can_crit:
		damagepopup.set_modulate(Color(0.7, 0.14, 0.14, 1))
		damagepopup.set_outline_modulate(Color(0.11, 0, 0, 1))
	else:
		damagepopup.set_modulate(Color(1, 1, 1, 1))
		damagepopup.set_outline_modulate(Color(1, 1, 1, 1))
	damagepopup.visible = true
	await get_tree().create_timer(0.6).timeout
	damagepopup.visible = false

func _on_timer_timeout() -> void:
	if health >= 0:
		collision_shape_3d.disabled = false
		animation_tree.set("parameters/conditions/fall",false)
	damagepopup.visible = false


func _on_destroyaftertime_timeout() -> void:
	queue_free()
