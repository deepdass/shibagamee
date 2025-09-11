extends Resource

class_name Weapons

@export var title : String
@export var texture : Texture2D
 
@export var damage : float
@export var cooldown : float
@export var speed : float

@export var projectile : PackedScene = preload("res://Scenes/zidk/mage_projectile.tscn")


func activate(_source, _target, _scene_tree):
	pass
