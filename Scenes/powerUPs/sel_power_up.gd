extends Area3D


@export var PowerUp : PowerUps 

var sub_viewport : SubViewport = null
@onready var sub_viewport_path : String = "/root/World/SubViewportContainer/SubViewport"

const allRES_dict : Dictionary = {"Mythic": ["res://Scenes/powerUPs/1_mythic/attack_mythic.tres"],

"Legendary": ["res://Scenes/powerUPs/2_Legendary/monster_legendary.tres"],

"Epic": ["res://Scenes/powerUPs/3_Epic/attack_epic.tres",
"res://Scenes/powerUPs/3_Epic/Boots_of_swiftness_epic.tres",
"res://Scenes/powerUPs/3_Epic/crackedskull_epic.tres",
"res://Scenes/powerUPs/3_Epic/Lifebloom_epic.tres",
"res://Scenes/powerUPs/3_Epic/monster_epic.tres",
"res://Scenes/powerUPs/3_Epic/St. Patricks_epic.tres"],

"Rare": ["res://Scenes/powerUPs/4_Rare/attack_rare.tres",
"res://Scenes/powerUPs/4_Rare/Boots_of_swiftness_rare.tres",
"res://Scenes/powerUPs/4_Rare/crackedskull_rare.tres",
"res://Scenes/powerUPs/4_Rare/Lifebloom_rare.tres",
"res://Scenes/powerUPs/4_Rare/monster_rare.tres",
"res://Scenes/powerUPs/4_Rare/St. Patricks_rare.tres"],

"Common": ["res://Scenes/powerUPs/5_Common/attack.tres",
"res://Scenes/powerUPs/5_Common/Boots_of_swiftness.tres",
"res://Scenes/powerUPs/5_Common/crackedskull.tres",
"res://Scenes/powerUPs/5_Common/Lifebloom.tres",
"res://Scenes/powerUPs/5_Common/monster.tres",
"res://Scenes/powerUPs/5_Common/St. Patricks.tres"]}

var allrarity : Array = allRES_dict.keys()

const VFXarray : Array[String] = ["res://Assets/_my/vfx/powerUp/1PUEff_mythic.tscn",
"res://Assets/_my/vfx/powerUp/2PUEff_legendary.tscn",
"res://Assets/_my/vfx/powerUp/3PUEff_epic.tscn",
"res://Assets/_my/vfx/powerUp/4PUEff_rare.tscn",
"res://Assets/_my/vfx/powerUp/5PUEff_common.tscn"]


@onready var meshspawn: Node3D = $meshspawn
@onready var player : CharacterBody3D= null
@onready var entered : bool = false
#@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready() -> void:
	
	randomize()
	
	var powerUP_rarity : String = allRES_dict.keys().pick_random()
	
	var RESstring : String = allRES_dict[powerUP_rarity].pick_random()
	PowerUp = load(RESstring)
	var powerup_mesh_inst : Node3D = PowerUp.mesh.instantiate()
	powerup_mesh_inst.position = meshspawn.position
	meshspawn.add_child(powerup_mesh_inst)
	
	spwanLevelVFX(VFXarray[allrarity.find(powerUP_rarity)])
	

	
	###
	sub_viewport = get_node(sub_viewport_path)


func spwanLevelVFX(vfx : String) -> void:
	var levVFX : PackedScene = load(vfx)
	var levVFX_inst : Node3D = levVFX.instantiate()
	levVFX_inst.position = position
	add_child(levVFX_inst)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered == true:
		player.StatsManager.applyUpgrades(PowerUp)
		queue_free()

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
