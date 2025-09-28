extends Area3D


var player: CharacterBody3D
@onready var addhealthcooldown: Timer = $addhealthcooldown

var healingflower_path : String = "res://Assets/_my/vfx/flowerheal/flower_heal.tscn"

func _on_body_entered(body: Node3D) -> void:
	player = get_parent().get_parent().player
	if body == player and player.StatsManager.stats.health < 7:
		addhealthcooldown.start()
		


func _on_body_exited(body: Node3D) -> void:
	addhealthcooldown.stop()

func _on_addhealthcooldown_timeout() -> void:
	add_health()

func add_health():
	player.StatsManager.stats.health += 1
	player.game_manager.update_UI()
	if player.StatsManager.stats.health < 7:
		addhealthcooldown.start()
