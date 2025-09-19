extends Node3D

@onready var animation_tree: AnimationTree = $CharacterMesh/AnimationTree
@onready var wep_manager: Node = $WEP_manager



func CB_setup():
		return animation_tree
