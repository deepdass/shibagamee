extends RigidBody3D


@onready var animation_player: AnimationPlayer = $chest_mesh/AnimationPlayer
@onready var pts_anim: AnimationPlayer = $ptsAnim
@onready var interact_area: Area3D = $interact_area


var player_entered : bool = false
var already_opened : bool = false


@onready var pts_parent: Node3D = $pts
@onready var powerUp : PackedScene = preload("res://Scenes/powerUPs/power_up_base.tscn") 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

func _physics_process(_delta):
	var up = global_transform.basis.y
	var upright = Vector3.UP
	var tilt = up.cross(upright) * 100  # strength factor
	apply_torque_impulse(tilt)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_entered and !already_opened:
		if Input.is_action_just_pressed("interact"):
			already_opened = true
			animation_player.play("chest_open")
			pts_anim.play("powerUp_upanddown")
			for i in pts_parent.get_children():
				var powerup_inst = powerUp.instantiate()
				i.add_child(powerup_inst)


func _showPowerUps():
	pts_parent.visible = true
	interact_area.queue_free()


func _on_interact_area_body_entered(_body: Node3D) -> void:
	player_entered = true

func _on_interact_area_body_exited(_body: Node3D) -> void:
	player_entered = false
