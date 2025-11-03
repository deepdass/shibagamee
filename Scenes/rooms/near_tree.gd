extends Area3D


var player: CharacterBody3D
@onready var addhealthcooldown: Timer = $addhealthcooldown

const healingflower : PackedScene = preload("res://Assets/_my/vfx/flowerheal/flower_heal.tscn")
var healingflower_inst : Node3D

func _on_body_entered(body: Node3D) -> void:
	player = get_parent().get_parent().player
	if body == player and player.StatsManager.stats.health < 7:
		healingflower_inst = healingflower.instantiate()
		player.add_child(healingflower_inst)
		addhealthcooldown.start()
		


func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player.remove_child(healingflower_inst)
		addhealthcooldown.stop()

func _on_addhealthcooldown_timeout() -> void:
	add_health()

func add_health() -> void:
	player.StatsManager.stats.health += 1
	player.game_manager.update_UI()
	if player.StatsManager.stats.health < 7:
		addhealthcooldown.start()
	else:
		player.remove_child(healingflower_inst)
