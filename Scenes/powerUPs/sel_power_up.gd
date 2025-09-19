extends Area3D


@export var PowerUp : PowerUps 

const allRES := ["res://Scenes/powerUPs/hihello.tres","res://Scenes/powerUPs/hihello1.tres", "res://Scenes/powerUPs/hihello2.tres"]
@onready var meshspawn: Node3D = $meshspawn
@onready var player = null
@onready var entered : bool = false

func _ready() -> void:
	var RESstring = allRES[randi_range(0,(allRES.size()-1))]
	PowerUp = load(RESstring)
	var powerup_inst = PowerUp.mesh.instantiate()
	powerup_inst.position = meshspawn.position
	meshspawn.add_child(powerup_inst)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered == true:
		player.ApplyUpgrades(PowerUp.health, PowerUp.movement_speed , PowerUp.name)
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("ApplyUpgrades"):
		player = body
		entered = true


func _on_body_exited(body: Node3D) -> void:
	entered = false
