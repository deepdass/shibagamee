extends CharacterBody3D

##refs
@onready var game_manager: Node = %GameManager  ## game_manager.decrease_health()
@export var character_mesh = preload("res://Scenes/characters/players/mage.tscn")

##visuals
@onready var animation_tree: AnimationTree = null
@onready var visuals: Node3D = $visuals

##attackrefs
@onready var wep_manager: Node = null
@onready var dash_timer: Timer = $"dash timer"

##audio
@onready var dash_sfx: AudioStreamPlayer = $dashSFX
@onready var hurt_sfx: AudioStreamPlayer = $hurtSFX


var dashing = false
var running = false
var look_at_me : Vector3

## stats
var health : int = 5
var defence : float
var sp_Meter : int

#combat
var attack : float
var attack_range : float
var crit_rate : float
var crit_damage : float

var can_crit : bool = false


var movement_speed : float = 7.5
var stamina : int

##

const JUMP_VELOCITY = 3.5


func _ready() -> void:
	# setup
	var character_mesh_inst = character_mesh.instantiate()
	visuals.add_child(character_mesh_inst)
	character_mesh_inst.global_transform = visuals.global_transform
	animation_tree = character_mesh_inst.CB_setup()
	animation_tree.advance_expression_base_node = self.get_path()
	wep_manager = character_mesh_inst.get_node("WEP_manager")
	#
	
	#combat
	randomize()
func _physics_process(delta: float) -> void:
	
	## movement - start ##
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		running = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#var dot_product := direction.dot(look_at_me.normalized())
		#print(dot_product)
		if Input.is_action_just_pressed("dash") and !dashing:
			animation_tree.set("parameters/dash/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			dashing = true
			velocity = direction * movement_speed * 15 + velocity
			velocity.y = 0
			
			dash_sfx.play()
			dash_timer.start()
		else:
			velocity.x = direction.x * movement_speed
			velocity.z = direction.z * movement_speed
			if !running:
				running = true
			
		visuals.look_at(direction + position)
		
	else:
		visuals.look_at(look_at_me, Vector3.UP)
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
		
		running = false
	
	_push_away_rigid_bodies()
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	dashing = false

## movement - end ##


func _push_away_rigid_bodies():
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			const MY_APPROX_MASS_KG = 80.0
			var mass_ratio = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			if mass_ratio < 0.25:
				continue
			push_dir.y = 0
			var push_force = mass_ratio * 5.0 #magic number
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)


##pewpew
	if Input.is_action_pressed("attack"):
		visuals.look_at(look_at_me, Vector3.UP)
		wep_manager.attack_basic()

func _rotate(where):
	look_at_me = where


func decrease_health():
	health -= 1
	game_manager.update_UI()
	hurt_sfx.play()


func CAL_defence():
	if attack == 0 and defence == 0:
		return 0.0
	return (attack/(attack + defence))


func crit(rate):
	var num = randf_range(0,1)
	
	if num < rate:
		can_crit = true
		return crit_damage / 100.0
	else:
		can_crit = false
		return 1.0 

func randomnessFactor():
	return randf_range(0.9,1.1)
	
func effective_damage():
	var damage: float = attack * CAL_defence() * crit(crit_rate) * randomnessFactor()
