extends Resource
class_name PersistentData

#player character data
@export var playerPosition: Vector3

#inventory
@export var inventory: Array[PackedScene]

func _init():
	inventory.resize(25)
