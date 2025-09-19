extends RigidBody3D


@onready var animation_player: AnimationPlayer = $chest_mesh/AnimationPlayer
@onready var pts_anim: AnimationPlayer = $ptsAnim
@onready var interact_area: Area3D = $interact_area


@onready var player_entered : bool = false


@onready var pts_parent: Node3D = $pts
@onready var powerUp : PackedScene = load("res://Scenes/powerUPs/power_up_base.tscn") 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in pts_parent.get_children():
		var powerup_inst = powerUp.instantiate()
		i.add_child(powerup_inst)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_entered:
		if Input.is_action_just_pressed("interact"):
			animation_player.play("chest_open")


func _showPowerUps():
	pts_parent.visible = true
	pts_anim.play("powerUp_upanddown")
	interact_area.queue_free()


func _on_interact_area_body_entered(body: Node3D) -> void:
	player_entered = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	player_entered = false
