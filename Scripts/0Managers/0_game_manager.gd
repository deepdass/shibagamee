extends Node

@onready var camera_3d: Camera3D = %Camera3D
@onready var camera_rig: Node3D = %camera_rig
@onready var cam_initailpt: Node3D = $"../SubViewportContainer/SubViewport/myy/per/camera_rig/cam_Initailpt"
@onready var cam_finalpt: Node3D = $"../SubViewportContainer/SubViewport/myy/per/camera_rig/cam_finalpt"

@onready var world: Node3D = $".."
@onready var player: CharacterBody3D = %Player


@onready var timer: Timer = $Timer
@onready var sub_viewport: SubViewport = $"../SubViewportContainer/SubViewport"


var ray_origin : Vector3
var ray_target_pt : Vector3

########################################
@export var hearts : Array[Node]
@onready var hearts_overload: Label = $"../UI/Panel/heartsOverload"

@onready var dungeon_generator_3d: DungeonGenerator3D = $"../SubViewportContainer/SubViewport/myy/DungeonGenerator3D"

########################################

func _init() -> void:
	randomize()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	

func  _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("menuu"):
		Global.loadscreen("res://Scenes/map/SelectLang.tscn")

	
	#####print(sub_viewport.get_camera_3d().unproject_position(player.global_position))
	##
	camera_rig.position = lerp(camera_rig.position,player.position,0.13)
	
	if Input.is_action_just_pressed("zoomIN"):
		camera_3d.position = camera_3d.position.move_toward(cam_finalpt.position + Vector3(0,4,4), delta * 25)
		camera_3d.position = camera_3d.position.move_toward(cam_finalpt.position + Vector3(0,4,4) - Vector3(0,0.01,0.01), delta * 25)
	if Input.is_action_just_pressed("zoomOUT"):
		camera_3d.position = camera_3d.position.move_toward(cam_initailpt.position, delta * 25)
		camera_3d.position = camera_3d.position.move_toward(cam_initailpt.position + Vector3(0,0.01,0.01), delta * 25)
	##
		
	#var mouse_pos : Vector2 = sub_viewport.get_mouse_position()
	#ray_origin = camera_3d.project_ray_origin(mouse_pos)
	#ray_target_pt = ray_origin + camera_3d.project_ray_normal(mouse_pos) * 1000
	#
	#var space_state : PhysicsDirectSpaceState3D = world.get_world_3d().direct_space_state
	#var params : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin,ray_target_pt,1)
	#params.exclude = [player]
	#var intersection : Dictionary = space_state.intersect_ray(params)
	#
	#if not intersection.is_empty():
		#var look_at_me : Vector3 = Vector3(intersection.position.x, player.position.y, intersection.position.z)
		#player._rotate(look_at_me)

		
	#if panel_2 != null:
		#panel_2.get_node("score").text = "Score: " + str(player.StatsManager.stats.score)
		#if player.StatsManager.stats.score == 0:
			#panel_2.get_node("tip").visible = true
		#else:
			#panel_2.get_node("tip").visible = false
		

func shakeCamera(duration :float, strength: float) -> void:
	var camera_initial_pos : Vector3 = camera_rig.global_position
	var shake_start_time : float = Time.get_ticks_msec()/1000.0
	
	while (Time.get_ticks_msec() / 1000.0) - shake_start_time < duration:
		var x: float = randf_range(-strength, strength)
		var y: float = randf_range(-strength, strength)
		camera_rig.global_position = Vector3(x, y, 0) + camera_initial_pos
		await get_tree().process_frame
		
	camera_rig.global_position = lerp(camera_rig.position,player.position,0.13)


func update_UI() -> void: 
	if hearts.size() >= player.StatsManager.stats.health:
		for i : int in hearts.size():
			if (i < player.StatsManager.stats.health):
				hearts[i].show()
			else:
				hearts[i].hide()
	else:
		if hearts_overload:
			hearts_overload.text = "+" + str(player.StatsManager.stats.health - hearts.size())
			hearts_overload.visible = true
	if player.StatsManager.stats.health <= 0:
		get_tree().set_meta("saved_stats", null)
		timer.start()
		Engine.time_scale = 0.3
		

func _on_timer_timeout() -> void:  ## kill timeout
	Engine.time_scale = 1
	if dungeon_generator_3d:
		dungeon_generator_3d.cleanup_and_reset_dungeon_generator()
		dungeon_generator_3d.clear_rooms_container_and_setup_for_next_iteration()
	Global.loadscreen(get_tree().current_scene.scene_file_path)
	

func won() -> void:
	player.StatsManager.stats.score += 1
	get_tree().set_meta("saved_stats", player.StatsManager.stats)
	Engine.time_scale = 0.3
	await get_tree().create_timer(0.1).timeout
	Engine.time_scale = 1
	Global.loadscreen(get_tree().current_scene.scene_file_path)

func _on_area_3d_body_entered(body: Node3D) -> void: ##inside crypt
	if !Global.which_scene:
		Global.loadscreen("res://Scenes/map/PDG_underWorld.tscn")
	elif body == player:
		Global.loadscreen(Global.which_scene)


func _on_killzone_body_entered(body: Node3D) -> void:
	if body == player:
		player.decrease_health(player.StatsManager.stats.health)
