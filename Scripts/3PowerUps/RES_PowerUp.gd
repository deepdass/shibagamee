extends Stats
class_name PowerUps

@export var mesh : PackedScene
@export var name : String
@export_multiline var description : String

@export_enum("Mythic", "Legendary", "Epic", "Rare", "Common") var rarity : String
@export_enum("equip_prop", "bacisAttack", "spAttack" , "justUpgrades") var type : String

@export var equip_path : String
@export var basicAttack : PackedScene
@export var spAttack : PackedScene
