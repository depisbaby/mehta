extends Node
class_name MagicManager

@onready var spells:Array[PackedScene] = [
	
	#projectiles
	preload("res://PackedScenes/Projectiles/Windball.tscn"),
	preload("res://PackedScenes/Projectiles/Wasgul.tscn"),
	preload("res://PackedScenes/Projectiles/EarthShard.tscn"),
	preload("res://PackedScenes/Projectiles/MagicSickle.tscn"),
	
	#spellmods
	preload("res://PackedScenes/SpellModifiers/AddBounce.tscn"),
	preload("res://PackedScenes/SpellModifiers/AddWeight.tscn"),
	preload("res://PackedScenes/SpellModifiers/SlowerSpell.tscn"),
	preload("res://PackedScenes/SpellModifiers/FasterSpell.tscn")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.magicManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func GetSpell(name:String)-> Node:
	
	for spell in spells: #is projectile based
		if spell._bundled.names[0] == name:
			
			var instance = spell.instantiate()
			get_tree().root.add_child(instance)
			
			return instance
	 
	return null
	
