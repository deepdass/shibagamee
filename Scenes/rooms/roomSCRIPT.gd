extends Node

var power_up_Chest : PackedScene = load("res://Scenes/powerUPs/PowerUp_chest.tscn")

var player : CharacterBody3D = null
@onready var player_path := "/root/World/SubViewportContainer/SubViewport/myy/per/Player"

var enemySCENEs : Dictionary = {"minion" : preload("res://Scenes/characters/enemy/skeleton_minion.tscn"),
 								"rogue" : preload("res://Scenes/characters/enemy/skeleton_rogue.tscn")
								}

var num_enemyCount : int
@onready var enemy_spawns : Marker3D = $NavigationRegion3D/spwans

@onready var doors : Marker3D = $NavigationRegion3D/env/door_Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)


func spawnEnemy():
	for whichpt in enemy_spawns.get_children():
		num_enemyCount += 1
		var enemy = enemySCENEs[ enemySCENEs.keys().pick_random()].instantiate()
		enemy.position = whichpt.position
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
		door.get_node("AnimationPlayer").play("door_open")

func closeDoors():
	for door in doors.get_children():
		door.get_node("doorBlock").disabled = false
		door.get_node("AnimationPlayer").play("door_close")
		
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		for door in doors.get_children():
			door.get_node("Area3D").queue_free()
		closeDoors()
		spawnEnemy()
