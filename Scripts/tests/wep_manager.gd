extends Node

@export var projectile : PackedScene
@onready var fireposnode: Node3D = $"../fireposnode"
@onready var timer: Timer = $Timer
var can_shoot = true
@export var projectile_speed = 15
@export var milli_per_shots = 667

func _ready() -> void:
	timer.wait_time = milli_per_shots / 1000.0

func _physics_process(delta: float) -> void:
	pass
	
func shoot():
	if can_shoot:
		var new_projectile = projectile.instantiate()
		new_projectile.global_transform = fireposnode.global_transform
		new_projectile.projectile_speed = projectile_speed
		get_tree().root.add_child(new_projectile)
		can_shoot = false
		timer.start()


func _on_timer_timeout() -> void:
	can_shoot = true
	
