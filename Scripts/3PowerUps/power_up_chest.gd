extends RigidBody3D

@export var PowerUp : PowerUps 

var allRES_dict : Dictionary = {"Mythic": ["res://Scenes/powerUPs/1_mythic/attack_mythic.tres"],

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


@onready var animation_player: AnimationPlayer = $chest_mesh/AnimationPlayer
@onready var pts_anim: AnimationPlayer = $ptsAnim
@onready var interact_area: Area3D = $interact_area


var player_entered : bool = false
var already_opened : bool = false


@onready var pts_parent: Node3D = $pts
@onready var powerUp : PackedScene = preload("res://Scenes/powerUPs/power_up_base.tscn") 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
		

func _physics_process(_delta : float) -> void:
	var up : Vector3 = global_transform.basis.y
	var upright : Vector3 = Vector3.UP
	var tilt : Vector3 = up.cross(upright) * 100  # strength factor
	apply_torque_impulse(tilt)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_entered and !already_opened:
		if Input.is_action_just_pressed("interact"):
			already_opened = true
			animation_player.play("chest_open")
			pts_anim.play("powerUp_upanddown")
			spawn_powerUps()
			
			pts_parent.visible = true
			interact_area.queue_free()

func spawn_powerUps() -> void:
	
	for i : Node3D in pts_parent.get_children():
		var powerup_inst : Area3D = powerUp.instantiate()
		i.add_child(powerup_inst)
		
		var powerUP_rarity : String = allRES_dict.keys().pick_random()
		
		if !allRES_dict[powerUP_rarity].is_empty():
			var RESstring : String = allRES_dict[powerUP_rarity].pick_random()
			PowerUp = load(RESstring)
			powerup_inst.ThepowerUp = PowerUp
			var powerup_mesh_inst : Node3D = PowerUp.mesh.instantiate()
			i.add_child(powerup_mesh_inst)
		
			for path in allRES_dict[powerUP_rarity]:
				if path == RESstring:
					allRES_dict[powerUP_rarity].erase(path)
					break
		
		#############
		var levVFX : PackedScene = load(VFXarray[allrarity.find(powerUP_rarity)])
		var levVFX_inst : Node3D = levVFX.instantiate()
		i.add_child(levVFX_inst)
		#############

func _on_interact_area_body_entered(_body: Node3D) -> void:
	player_entered = true

func _on_interact_area_body_exited(_body: Node3D) -> void:
	player_entered = false
