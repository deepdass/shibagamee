extends Area3D

@export var PowerUp : PowerUps 

var sub_viewport : SubViewport = null
@onready var sub_viewport_path : String = "/root/World/SubViewportContainer/SubViewport"

@onready var player : CharacterBody3D= null
@onready var entered : bool = false
#@onready var sprite_3d: Sprite3D = $Sprite3D

@onready var ThepowerUp : PowerUps = null

	#sub_viewport = get_node(sub_viewport_path)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered == true and ThepowerUp != null:
		player.StatsManager.applyUpgrades(ThepowerUp)
		get_parent().queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("ui"):
		player = body
		entered = true
		#popup(Rect2i(sub_viewport.get_camera_3d().unproject_position(global_position), Vector2i(960,540)),null)


func _on_body_exited(_body: Node3D) -> void:
	entered = false
	#hidepopup() 
	

#func popup(slot : Rect2i,item):
	#
	#var correction
	#
	#if sub_viewport.get_camera_3d().unproject_position(player.global_position).x <= sub_viewport.get_size().x /2:
		#print(player.position.x <= sub_viewport.get_size().x /2)
		#correction = Vector2i(slot.size.x , 0)
	#else:
		#correction = -Vector2i(%PowerUp_popUP.size.x , 0)
	#
	#%PowerUp_popUP.popup(Rect2i(slot.position + correction , %PowerUp_popUP.size ))
	#
#func hidepopup():
	#%PowerUp_popUP.hide()
