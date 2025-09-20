extends Area3D


@export var PowerUp : PowerUps 

const allRES := ["res://Scenes/powerUPs/hihello.tres","res://Scenes/powerUPs/hihello1.tres", "res://Scenes/powerUPs/hihello2.tres"]
@onready var meshspawn: Node3D = $meshspawn
@onready var player = null
@onready var entered : bool = false

func _ready() -> void:
	var RESstring = allRES[randi_range(0,(allRES.size()-1))]
	PowerUp = load(RESstring)
	var powerup_mesh_inst = PowerUp.mesh.instantiate()
	powerup_mesh_inst.position = meshspawn.position
	meshspawn.add_child(powerup_mesh_inst)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered == true:
		player.StatsManager.applyUpgrades(PowerUp)
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("ui"):
		player = body
		entered = true


func _on_body_exited(body: Node3D) -> void:
	entered = false
