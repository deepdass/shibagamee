extends Node

var power_up_Chest : PackedScene = preload("res://Scenes/powerUPs/PowerUp_chest.tscn")

var player : CharacterBody3D = null
@onready var player_path : String = "/root/World/SubViewportContainer/SubViewport/myy/per/Player"

var enemySCENEs : Dictionary = {"minion" : preload("res://Scenes/characters/enemy/skeleton_minion.tscn"),
 								"rogue" : preload("res://Scenes/characters/enemy/skeleton_rogue.tscn")
								}

var num_enemyCount : int
var enemylist_ref : Array[CharacterBody3D]
@onready var enemy_spawns : Marker3D = $NavigationRegion3D/spwans

@onready var doors : Marker3D = $NavigationRegion3D/env/door_Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)
	#get_parent().ChangeroomCount()
	
	enemylist_ref = player.StatsManager.enemylist
	
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		for door : StaticBody3D in doors.get_children():
			door.get_node("Area3D").queue_free()
		closeDoors()
		spawnEnemy()

func spawnEnemy() -> void:
	for whichpt : Marker3D in enemy_spawns.get_children():
		num_enemyCount += 1
		var enemy : CharacterBody3D = enemySCENEs[enemySCENEs.keys().pick_random()].instantiate()
		enemy.position = whichpt.position
		get_node("NavigationRegion3D").add_child(enemy)
		enemylist_ref.append(enemy)
			
		enemy.died.connect(_on_enemy_killed)

func _on_enemy_killed() -> void:
	num_enemyCount -= 1
	if num_enemyCount == 0:
		openDoors()
		var power_up_Chest_inst : RigidBody3D = power_up_Chest.instantiate()
		power_up_Chest_inst.position = player.position + Vector3(0, 10, 0)
		get_tree().get_current_scene().add_child(power_up_Chest_inst)

func openDoors() -> void:
	for door : StaticBody3D in doors.get_children():
		var anim : AnimationPlayer = door.get_node("AnimationPlayer")
		if anim:
			door.get_node("doorBlock").disabled = true
			anim.play("door_open")
			setmesh(door, anim)
		

func setmesh(door : StaticBody3D, anim : AnimationPlayer) -> void:
	await get_tree().create_timer(anim.current_animation_length).timeout
	door.get_node("wall_doorway_door").visible = false

func closeDoors() -> void:
	for door : StaticBody3D in doors.get_children():
		if door.get_node("doorBlock").disabled == true:
			door.get_node("doorBlock").disabled = false
			door.get_node("wall_doorway_door").visible = true
			var anim : AnimationPlayer = door.get_node("AnimationPlayer")
			anim.play("door_close")
		
	


func _on_dungeon_room_3d_dungeon_done_generating() -> void:
	for door : RefCounted in get_parent().get_doors():
		if door.get_room_leads_to() == null:
			var mesh : MeshInstance3D = door.door_node.get_node("wall_doorway_door")
			mesh.visible = true
			mesh.position += Vector3(0,3,0)
			door.door_node.get_node("doorBlock").disabled = false
			door.door_node.get_node("AnimationPlayer").queue_free()
