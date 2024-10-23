extends Node
class_name ItemLibrary

var items: Array[PackedScene] = [
	
	#wands
	preload("res://PackedScenes/Items/Wands/item_vitutus.tscn")
	
]

func _enter_tree() -> void:
	Global.itemLibrary = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
