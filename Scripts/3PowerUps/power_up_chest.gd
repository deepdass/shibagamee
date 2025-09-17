extends RigidBody3D

@export var PowerUp : PowerUps 

@onready var animation_player: AnimationPlayer = $chest_mesh/AnimationPlayer
@onready var pts_anim: AnimationPlayer = $pts/ptsAnim

@onready var player_entered : bool = false
@onready var pts: Node3D = $pts


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_entered:
		if Input.is_action_just_pressed("interact"):
			animation_player.play("chest_open")


func _showPowerUps():
	pts.visible = true
	pts_anim.play("powerUp_upanddown")


func _on_interact_area_body_entered(body: Node3D) -> void:
	player_entered = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	player_entered = false
