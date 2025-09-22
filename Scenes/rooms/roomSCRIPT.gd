extends Node3D


var power_up_Chest : PackedScene = load("res://Scenes/powerUPs/PowerUp_chest.tscn")

var player : CharacterBody3D = null
@onready var player_path := "/root/World/SubViewportContainer/SubViewport/myy/per/Player"

var enemySCENEs : Dictionary = {"minion" : preload("res://Scenes/characters/enemy/skeleton_minion.tscn"),
 								"rogue" : preload("res://Scenes/characters/enemy/skeleton_rogue.tscn")
								}

var num_enemyCount : int
@onready var enemy_spawns : Node3D = $NavigationRegion3D/spwans

@onready var doors : Node = $NavigationRegion3D/env/door_Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	for door in doors.get_children():
		door.get_node("Area3D").queue_free()
	if body == player:
		closeDoors()
		spawnEnemy()


func spawnEnemy():
	for whichpt in enemy_spawns.get_children():
		num_enemyCount += 1
		var keys = enemySCENEs.keys()
		var enemy = enemySCENEs[keys.pick_random()].instantiate()
		enemy.position = whichpt.global_position
		get_node("NavigationRegion3D").add_child(enemy)
			
		enemy.died.connect(_on_enemy_killed)

func _on_enemy_killed():
	num_enemyCount -= 1
	if num_enemyCount == 0:
		openDoors()
		var power_up_Chest_inst = power_up_Chest.instantiate()
		power_up_Chest_inst.position = player.position + Vector3(0, 10, 0)
		get_tree().get_current_scene().add_child(power_up_Chest_inst)

func openDoors():
	for door in doors.get_children():
		door.get_node("doorBlock").disabled = true

func closeDoors():
	for door in doors.get_children():
		door.get_node("doorBlock").disabled = false
