extends Node

## attack basic
@export var projectile : PackedScene
@onready var fireposnode: Node3D = $"../fireposnode"
@export var projectile_speed = 15
@export var milli_per_shots = 667
##


@onready var animation_tree: AnimationTree = $"../CharacterMesh/AnimationTree"


var can_attack_basic = true
@onready var attack_bacis__timer: Timer = $attack_bacis__Timer



func _ready() -> void:
	attack_bacis__timer.wait_time = milli_per_shots / 1000.0

func _physics_process(delta: float) -> void:
	pass
	
func attack_basic():
	if can_attack_basic:
		animation_tree.set("parameters/attack_basic/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		var new_projectile = projectile.instantiate()
		new_projectile.global_transform = fireposnode.global_transform
		new_projectile.projectile_speed = projectile_speed
		get_tree().root.add_child(new_projectile)
		can_attack_basic = false
		attack_bacis__timer.start()


func _on_timer_timeout() -> void: ##  attack basic timer
	can_attack_basic = true
	
