extends Node


@onready var heart_1: TextureRect = $"../UI/Panel/Heart1"
@onready var heart_2: TextureRect = $"../UI/Panel/Heart2"
@onready var heart_3: TextureRect = $"../UI/Panel/Heart3"
@onready var timer: Timer = $Timer

var score = 0
var lives = 3

@export var hearts : Array[Node]

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

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1

func _on_area_3d_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://Scenes/map/underWorld.tscn")
