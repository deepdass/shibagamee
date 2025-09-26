extends Node3D

var gameMangager : Node = null
@onready var gamemanagerPath = "/root/World/GameManager"

func _ready() -> void:
	gameMangager = get_node("/root/World/GameManager")


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body == gameMangager.player:
		gameMangager.won()
