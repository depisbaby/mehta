extends Node
class_name MagicManager

@export var spells: Array[PackedScene]


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.magicManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
