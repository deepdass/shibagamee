extends Resource

class_name EnemyStats

@export var health : float
@export var defence : float

@export var damage : int
@export var attack_range : float 
@export var KnockbackMul : int 

@export var enem_KnockbackMul : int

@export var movement_speed : float

static var player : CharacterBody3D = null
static func set_player(player_ref : CharacterBody3D) -> void:
	player = player_ref
