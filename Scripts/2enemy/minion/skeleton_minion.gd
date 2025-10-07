extends CharacterBody3D

var subViewport : SubViewport = null
var player : CharacterBody3D = null
@onready var player_path : String = "/root/World/SubViewportContainer/SubViewport/myy/per/Player"
@onready var sub_viewport_path : String = "/root/World/SubViewportContainer/SubViewport"

@onready var skeleton_minion_eyes: MeshInstance3D = $Skeleton_Minion/Rig/Skeleton3D/Skeleton_Minion_Eyes
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var health : float = 200
@onready var damagepopup: Node3D = $idknode

@onready var destroyaftertime: Timer = $destroyaftertime


const  SPEED : float = 4.2
const ATTACK_RANGE : float = 1.5
const KnockbackMul : int = 35

const enem_KnockbackMul : int = 40
var state_machine : AnimationNodeStateMachinePlayback

@onready var animation_tree: AnimationTree = $Skeleton_Minion/AnimationTree
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer

signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	timer.wait_time = animation_tree.get_animation("Death_C_Skeletons").length + 0.3
	
	player = get_node(player_path)
	subViewport = get_node(sub_viewport_path)
	
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/conditions/Resurrect",true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	damagepopup.look_at(subViewport.get_camera_3d().global_position)
	
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

func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _hitfinish() -> void:
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 0.5 :
		var dir : Vector3 = global_position.direction_to(player.global_position)
		player.velocity += Vector3(dir.x , dir.y * 0.1, dir.z ) * KnockbackMul
		player.decrease_health()
		player.decrease_health()
		player.game_manager.shakeCamera(0.3,0.1)
		
	

func take_damage()  -> void:
	var damageRec : float = player.StatsManager.effective_damage()
	health -= damageRec
	
	var fallChance : int = randi_range(0,100)
	if fallChance < 5:
		collision_shape_3d.disabled = true
		timer.start()
		animation_tree.set("parameters/conditions/fall",true)
		audio_stream_player.play()
	else:
		var dir : Vector3 = -global_position.direction_to(player.global_position)
		velocity = Vector3.ZERO
		velocity += Vector3(dir.x , dir.y * 0.1, dir.z ) * enem_KnockbackMul
		move_and_slide()
	damagepopup.get_node("damagepopup").text = "%.1f" % damageRec
	showDmg()
	if health <= 0:
		emit_signal("died")
		collision_shape_3d.disabled = true
		skeleton_minion_eyes.visible = false
		audio_stream_player.play()
		animation_tree.set("parameters/conditions/fall",true)
		animation_tree.set("parameters/conditions/Resurrect",false)
		destroyaftertime.start()

func showDmg() -> void:
	if player.StatsManager.can_crit:
		damagepopup.get_node("damagepopup").set_modulate(Color(0.7, 0.14, 0.14, 1))
		damagepopup.get_node("damagepopup").set_outline_modulate(Color(0.11, 0, 0, 1))
	else:
		damagepopup.get_node("damagepopup").set_modulate(Color(1, 1, 1, 1))
		damagepopup.get_node("damagepopup").set_outline_modulate(Color(1, 1, 1, 1))
	damagepopup.visible = true
	await get_tree().create_timer(0.6).timeout
	damagepopup.visible = false

func _on_timer_timeout() -> void:
	if health >= 0:
		collision_shape_3d.disabled = false
		animation_tree.set("parameters/conditions/fall",false)


func _on_destroyaftertime_timeout() -> void:
	queue_free()
