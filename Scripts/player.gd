extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 3.5
const RUNMULYIPLIER = 2.5

@onready var animation_player: AnimationPlayer = $visuals/player/AnimationPlayer
@onready var visuals: Node3D = $visuals

var walking = false

func _ready() -> void:
	animation_player.set_blend_time("idle","walk",0.2)
	animation_player.set_blend_time("idle","run",0.2)
	animation_player.set_blend_time("walk","idle",0.2)
	animation_player.set_blend_time("walk","run",0.2)
	animation_player.set_blend_time("run","walk",0.2)
	animation_player.set_blend_time("run","idle",0.2)
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Input.is_action_pressed("sprint"):
			walking = false
			velocity.x = direction.x * SPEED * RUNMULYIPLIER
			velocity.z = direction.z * SPEED * RUNMULYIPLIER
			animation_player.play("run")
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if !walking:
				walking = true
				animation_player.play("walk")
		
		visuals.look_at(direction + position)
		
				
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
		walking = false
		animation_player.play("idle")
			
	move_and_slide()
