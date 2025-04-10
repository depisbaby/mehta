extends Node3D
class_name EnemySpawnPoints

@export var enemyScene: PackedScene

@onready var devSprite: Sprite3D = $Sprite3D

var occupied

func _ready():
	Global.enemyManager.AddSpawnPoint(self)
	pass

func _process(delta):
	
	pass

func Spawn():
	var enemy:NavAgent = enemyScene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	enemy.originSpawnPoint = self
	occupied = true
	pass
	
