extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.5
const RUNMULYIPLIER = 1.5

@export var character_mesh = preload("res://Scenes/characters/players/mage.tscn")

@onready var animation_tree: AnimationTree = null
@onready var visuals: Node3D = $visuals
@onready var game_manager: Node = %GameManager  ## game_manager.decrease_health()

@onready var wep_manager: Node = null
@onready var dash_timer: Timer = $"dash timer"
@onready var dash_sfx: AudioStreamPlayer = $dashSFX

var dashing = false

var walking = false
var running = false

var look_at_me : Vector3


func _ready() -> void:
	var character_mesh_inst = character_mesh.instantiate()
	visuals.add_child(character_mesh_inst)
	character_mesh_inst.global_transform = visuals.global_transform
	animation_tree = character_mesh_inst.CB_setup()
	animation_tree.advance_expression_base_node = self.get_path()
	wep_manager = character_mesh_inst.get_node("WEP_manager")
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		walking = false
		running = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#var dot_product := direction.dot(look_at_me.normalized())
		#print(dot_product)
		if Input.is_action_just_pressed("dash") and !dashing:
			dashing = true
			velocity = direction * SPEED * 17 + velocity
			dash_sfx.play()
			velocity.y = 0
			dash_timer.start()
			
		elif Input.is_action_pressed("sprint"):
			walking = false
			velocity.x = direction.x * SPEED * RUNMULYIPLIER
			velocity.z = direction.z * SPEED * RUNMULYIPLIER
			if !running:
				running = true
				
		else:
			running = false
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if !walking:
				walking = true
				#const WALK_ANIM: Array[String] = ["Walking_A","Walking_B","Walking_C"]
				#animation_player.play(WALK_ANIM[randi_range(0,2)])
		
		visuals.look_at(direction + position)
		
		
				
	else:
		visuals.look_at(look_at_me, Vector3.UP)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		walking = false
		running = false
	
	_push_away_rigid_bodies()
	
	move_and_slide()
	
	##pewpew
	if Input.is_action_pressed("attack"):
		visuals.look_at(look_at_me, Vector3.UP)
		wep_manager.shoot()
		#animation_player.play("Spellcasting")


func _push_away_rigid_bodies():
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			const MY_APPROX_MASS_KG = 80.0
			var mass_ratio = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force = mass_ratio * 5.0
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)



func _rotate(where):
	look_at_me = where


func _on_dash_timer_timeout() -> void:
	dashing = false
