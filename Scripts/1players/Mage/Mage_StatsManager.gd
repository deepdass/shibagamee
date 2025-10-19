extends Node

@onready var stats : Stats
var RES : Resource = load("res://Res/character/RES_mage.tres")

@onready var player : CharacterBody3D = get_parent().get_parent().get_parent()

var can_crit : bool = false


## attack basic
@export var projectile : PackedScene
@onready var fireposnode: Node3D = $"../fireposnode"
@export var projectile_speed : int = 15
@export var milli_per_shots : int = 800

var nearestEnemy : CharacterBody3D 
var nearestEnemy_distance : float = INF

var enemylist : Array[CharacterBody3D]
##


@onready var animation_tree: AnimationTree = $"../CharacterMesh/AnimationTree"


var can_attack_basic : bool = true
@onready var attack_bacis__timer: Timer = $attack_bacis__Timer



func _ready() -> void:
	if get_tree().has_meta("saved_stats"):
		stats = get_tree().get_meta("saved_stats").duplicate()
	else:
		stats = RES.duplicate()
	
	attack_bacis__timer.wait_time = milli_per_shots / 1000.0


func _physics_process(_delta: float) -> void:
	
	##pewpew
	if Input.is_action_pressed("attack"):
		nearestEnemy_distance = INF
		for i : CharacterBody3D in enemylist:
			var newdis : float = (player.global_position - i.global_position).length()
			if !(nearestEnemy_distance < newdis) and newdis < stats.attack_range:
				nearestEnemy_distance = newdis
				nearestEnemy = i
		if nearestEnemy:
			player.get_node("visuals").look_at(Vector3(nearestEnemy.global_position.x, player.global_position.y, nearestEnemy.global_position.z), Vector3.UP)
		#player.get_node("visuals").look_at(player.look_at_me, Vector3.UP)
		attack_basic()


func attack_basic() -> void:
	if can_attack_basic:
		animation_tree.set("parameters/attack_basic/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		var new_projectile : Node3D = projectile.instantiate()
		new_projectile.global_transform = fireposnode.global_transform
		new_projectile.projectile_speed = projectile_speed
		get_tree().get_current_scene().add_child(new_projectile)
		
		new_projectile.attack_thisenemy(nearestEnemy)
		
		can_attack_basic = false
		attack_bacis__timer.start()
	


func _on_timer_timeout() -> void: ##  attack basic timer
	can_attack_basic = true


###################################################################
func CAL_defence() -> float:
	if stats.attack == 0 and stats.defence == 0:
		return 0.0
	return (stats.attack/(stats.attack + stats.defence))


func crit(rate : float) -> float:
	var num : float = randf_range(0,1)
	
	if num < rate:
		can_crit = true
		return stats.crit_damage / 100.0
	else:
		can_crit = false
		return 1.0 

func randomnessFactor() -> float:
	return randf_range(0.9,1.1)
	
func effective_damage() -> float:
	return stats.attack * CAL_defence() * crit(stats.crit_rate/100) * randomnessFactor()



###############################################################################
func applyUpgrades(receivedPowerups: Stats) -> void:
	stats.health += receivedPowerups.health
	stats.movement_speed += receivedPowerups.movement_speed
	stats.sp_Meter += receivedPowerups.sp_Meter
	stats.attack += receivedPowerups.attack
	stats.attack_range += receivedPowerups.attack_range
	stats.crit_rate += receivedPowerups.crit_rate
	stats.crit_damage += receivedPowerups.crit_damage
	stats.movement_speed += receivedPowerups.movement_speed
	stats.luck += receivedPowerups.luck
	
	if !receivedPowerups.stamina == 0:
		player.set_maxVal(receivedPowerups.stamina)
		stats.stamina += receivedPowerups.stamina
		player.set_stamina()
	
	
	if receivedPowerups.type == "equip_prop":
		var equip_prop_path : BoneAttachment3D = get_node(receivedPowerups.equip_path)
		equip_prop_path.visible = true
	
	player.ui()
