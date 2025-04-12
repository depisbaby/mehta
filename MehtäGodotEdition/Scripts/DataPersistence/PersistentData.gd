extends Resource
class_name PersistentData

#saveData
@export var seed: String
@export var playerPosition: Vector3
@export var inventory: Array[PackedScene]



#currentGameState
@export var playerCurrentMap: String


func _init():
	inventory.resize(25)
