extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.5
const RUNMULYIPLIER = 1.5

@onready var animation_player: AnimationPlayer = $visuals/Mage2/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var camera_rig: Node3D = %camera_rig
@onready var game_manager: Node = %GameManager  ## game_manager.decrease_health()

@onready var stairsahead: RayCast3D = $stairsahead
@onready var stairsbelow: RayCast3D = $stairsbelow

@onready var wep_manager: Node = $visuals/Mage2/WEP_manager
@onready var dash_timer: Timer = $"dash timer"

var dashing = false

var walking = false
var running = false

var look_at_me : Vector3


func _ready() -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		walking = false
		running = false
		animation_player.play("Jump_Full_Short")

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
			velocity.y = 0
			dash_timer.start()
			
		elif Input.is_action_pressed("sprint"):
			walking = false
			velocity.x = direction.x * SPEED * RUNMULYIPLIER
			velocity.z = direction.z * SPEED * RUNMULYIPLIER
			if !running:
				running = true
				const RUN_ANIM: Array[String] = ["Running_A"]
				animation_player.play(RUN_ANIM[0])
		else:
			running = false
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if !walking:
				walking = true
				const WALK_ANIM: Array[String] = ["Walking_A","Walking_B","Walking_C"]
				animation_player.play(WALK_ANIM[randi_range(0,2)])
		
		visuals.look_at(direction + position)
		
		
				
	else:
		visuals.look_at(look_at_me, Vector3.UP)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		walking = false
		running = false
		animation_player.play("Idle")
			
	move_and_slide()
	
	##pewpew
	if Input.is_action_pressed("attack"):
		visuals.look_at(look_at_me, Vector3.UP)
		wep_manager.shoot()
		animation_player.play("Spellcasting")
	
	##
	camera_rig.position = lerp(camera_rig.position,position,0.13)
	##
	
#pew#pew

func _rotate(where):
	look_at_me = where
		
		


func _on_dash_timer_timeout() -> void:
	dashing = false
