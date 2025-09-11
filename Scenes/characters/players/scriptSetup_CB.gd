extends Node3D

@onready var animation_tree: AnimationTree = $CharacterMesh/AnimationTree

func CB_setup():
		return animation_tree
