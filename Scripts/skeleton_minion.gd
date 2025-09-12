extends CharacterBody3D

var player = null
var game_manager = null
var subViewport = null
@onready var game_manager_path := "/root/World/GameManager"
@onready var player_path := "/root/World/SubViewportContainer/SubViewport/myy/NavigationRegion3D/per/Player"
@onready var sub_viewport_path := "/root/World/SubViewportContainer/SubViewport"

@onready var skeleton_minion_eyes: MeshInstance3D = $Skeleton_Minion/Rig/Skeleton3D/Skeleton_Minion_Eyes
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var health : int = 3
@onready var damagepopup: Node3D = $idknode



const  SPEED = 3.0
const ATTACK_RANGE = 1
const KnockbackMul = 25
var state_machine

@onready var animation_tree: AnimationTree = $Skeleton_Minion/AnimationTree
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	timer.wait_time = animation_tree.get_animation("Death_C_Skeletons").length + 0.3
	
	player = get_node(player_path)
	game_manager = get_node(game_manager_path)
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
			var next_pt = navigation_agent_3d.get_next_path_position()
			velocity = (next_pt - global_transform.origin).normalized() * SPEED
			
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10)
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		"1H_Melee_Attack_Stab":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	animation_tree.set("parameters/conditions/attack", _target_in_range())	
	animation_tree.set("parameters/conditions/run", !_target_in_range())
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _hitfinish():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 0.5 :
		var dir = global_position.direction_to(player.global_position)
		game_manager.decrease_health()
		player.velocity += Vector3(dir.x , dir.y * 0.1, dir.z ) * KnockbackMul
		
func taka_damage():
	health -= 1
	health = clamp(health,0 , 5)
	collision_shape_3d.disabled = true
	animation_tree.set("parameters/conditions/fall",true)
	audio_stream_player.play()
	damagepopup.visible = true
	if health == 0:
		collision_shape_3d.disabled = true
		skeleton_minion_eyes.visible = false
		animation_tree.set("parameters/conditions/Resurrect",false)
	timer.start()


func _on_timer_timeout() -> void:
	if health != 0:
		collision_shape_3d.disabled = false
		animation_tree.set("parameters/conditions/fall",false)
	damagepopup.visible = false
