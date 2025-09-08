extends Node

@onready var camera_3d: Camera3D = %Camera3D

@onready var world: Node3D = $".."
@onready var player: CharacterBody3D = %Player

@onready var heart_1: TextureRect = $"../UI/Panel/Heart1"
@onready var heart_2: TextureRect = $"../UI/Panel/Heart2"
@onready var heart_3: TextureRect = $"../UI/Panel/Heart3"
@onready var timer: Timer = $Timer
@onready var sub_viewport: SubViewport = $"../SubViewportContainer/SubViewport"



var score = 0
var lives = 3

var ray_origin = Vector3()
var ray_target_pt = Vector3()

@export var hearts : Array[Node]

func _physics_process(delta: float) -> void:
	var mouse_pos = sub_viewport.get_mouse_position()
	ray_origin = camera_3d.project_ray_origin(mouse_pos)
	ray_target_pt = ray_origin + camera_3d.project_ray_normal(mouse_pos) * 1000
	
	var space_state = world.get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.create(ray_origin,ray_target_pt,1)
	params.exclude = [player]
	var intersection = space_state.intersect_ray(params)
	
	if not intersection.is_empty():
		var pos = intersection.position
		var look_at_me = Vector3(pos.x, player.position.y, pos.z)
		player._rotate(look_at_me)

func decrease_health():
	lives -= 1
	print(lives)
	for i in hearts.size():
		if (i < lives):
			hearts[i].show()
		else:
			hearts[i].hide()
				
	if lives == 0:
		timer.start()
		Engine.time_scale = 0.3

func _on_timer_timeout() -> void:  ## kill timeout
	get_tree().reload_current_scene()
	Engine.time_scale = 1

func _on_area_3d_body_entered(body: Node3D) -> void: ##inside crypt
	if body == player:
		get_tree().change_scene_to_file("res://Scenes/map/underWorld.tscn")
