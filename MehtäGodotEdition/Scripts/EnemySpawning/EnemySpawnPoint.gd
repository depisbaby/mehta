extends Node3D
class_name EnemySpawnPoint

@export var top: Node3D

@onready var devSprite: Sprite3D = $Sprite3D

var occupied

func _ready():
	get_parent().get_parent().enemySpawnPoints.push_back(self)
	devSprite.hide()

func Spawn(enemyScene:PackedScene):
	var enemy:NavAgent = enemyScene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	enemy.originSpawnPoint = self
	occupied = true
	pass
	
