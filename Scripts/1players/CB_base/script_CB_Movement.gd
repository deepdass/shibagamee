extends CharacterBody3D

##refs
@onready var game_manager: Node = %GameManager
@export var character_mesh : PackedScene = preload("res://Scenes/characters/players/mage.tscn")

#@onready var bloodeffanim: AnimationPlayer = $bloodeff/bloodeffanim

##visuals
@onready var animation_tree: AnimationTree = null
@onready var visuals: Node3D = $visuals

##attackrefs
@onready var StatsManager: Node = null

##audio
@onready var dash_sfx: AudioStreamPlayer = $dashSFX
@onready var hurt_sfx: AudioStreamPlayer = $hurtSFX


@onready var dash_timer: Timer = $"dash timer"
@onready var stamina_bar: TextureProgressBar = $"../../../../../UI/staminaBar"

var dashing : bool= false
var running : bool= false
#var look_at_me : Vector3


##

const JUMP_VELOCITY : float = 3.5
const DASH_STAMINAcost : int = 20


func _ready() -> void:
	# setup
	EnemyStats.set_player(self)
	var character_mesh_inst : Node3D = character_mesh.instantiate()
	visuals.add_child(character_mesh_inst)
	character_mesh_inst.global_transform = visuals.global_transform
	
	animation_tree = character_mesh_inst.get_node("CharacterMesh/AnimationTree")
	animation_tree.advance_expression_base_node = animation_tree.get_path()
	
	StatsManager = character_mesh_inst.get_node("StatsManager")
	
	ui()
	#
	
	#combat
	randomize()
	#
	
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
	var direction : Vector3= (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#var dot_product := direction.dot(look_at_me.normalized())
		#print(dot_product)
		if Input.is_action_just_pressed("dash") and !dashing and StatsManager.stats.stamina > DASH_STAMINAcost:
			StatsManager.stats.stamina -= DASH_STAMINAcost
			set_stamina()
			animation_tree.set("parameters/dash/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			dashing = true
			velocity = direction * StatsManager.stats.movement_speed * 15 + velocity
			velocity.y = 0
			
			dash_sfx.play()
			dash_timer.start()
		else:
			velocity.x = direction.x * StatsManager.stats.movement_speed
			velocity.z = direction.z * StatsManager.stats.movement_speed
			if !running:
				running = true
			if !dashing and StatsManager.stats.stamina < stamina_bar.max_value:
				StatsManager.stats.stamina += 30 * delta
				clamp(StatsManager.stats.stamina, 0 , stamina_bar.max_value)
				set_stamina()
			
		visuals.look_at(direction + position)
		
	else:
		#visuals.look_at(look_at_me, Vector3.UP)
		
		velocity.x = move_toward(velocity.x, 0, StatsManager.stats.movement_speed)
		velocity.z = move_toward(velocity.z, 0, StatsManager.stats.movement_speed)
		
		running = false
		if !dashing and StatsManager.stats.stamina < stamina_bar.max_value:
				StatsManager.stats.stamina += 40 * delta
				clamp(StatsManager.stats.stamina, 0 , stamina_bar.max_value)
				set_stamina()
	
	animation_tree.set("parameters/AnimationNodeStateMachine/conditions/running", running)
	animation_tree.set("parameters/AnimationNodeStateMachine/conditions/idle", !running)
	
	_push_away_rigid_bodies()
	move_and_slide()
	### movement end ###



func _on_dash_timer_timeout() -> void:
	dashing = false
	
func set_stamina() -> void:
	stamina_bar.value = StatsManager.stats.stamina

func set_maxVal(add : int) -> void:
	stamina_bar.max_value += add
## movement - end ##


func _push_away_rigid_bodies() -> void:
	for i : int in get_slide_collision_count():
		var c : KinematicCollision3D = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir : Vector3 = -c.get_normal()
			var velocity_diff_in_push_dir : float = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			const MY_APPROX_MASS_KG : int = 80
			var mass_ratio : float = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			if mass_ratio < 0.25:
				continue
			push_dir.y = 0
			var push_force : float = mass_ratio * 5.0 #magic number
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)


#func _rotate(where: Vector3) -> void:
	#look_at_me = where


func decrease_health(damage : int) -> void:
	StatsManager.stats.health -= damage
	
	#bloodeffanim.play("blood")
	
	ui()
	hurt_sfx.play()


func ui() -> void:
	game_manager.update_UI()
