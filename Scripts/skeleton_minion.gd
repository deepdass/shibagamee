extends CharacterBody3D

var player = null
var game_manager = null
@onready var game_manager_path := "/root/World/GameManager"
@onready var player_path := "/root/World/SubViewportContainer/SubViewport/all/NavigationRegion3D/per/Player"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


const  SPEED = 3.0
const ATTACK_RANGE = 1
const KnockbackMul = 25
var state_machine

@onready var animation_tree: AnimationTree = $Skeleton_Minion/AnimationTree
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)
	game_manager = get_node(game_manager_path)
	
	state_machine = animation_tree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	
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
	animation_tree.set("parameters/conditions/death",true)
	if !audio_stream_player.playing:
		audio_stream_player.play()
	timer.start()


func _on_timer_timeout() -> void:
	animation_tree.set("parameters/conditions/death",false)
