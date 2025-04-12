extends Node3D
class_name EnemySpawnPoint

@export var top: Node3D

@onready var devSprite: Sprite3D = $Sprite3D

var occupied

func _ready():
	get_parent().get_parent().enemySpawnPoints.push_back(self)
	devSprite.hide()

func Spawn():
	var enemy:NavAgent = Global.enemyManager.PopFromPool()
	if enemy == null:
		return
	enemy.global_position = global_position
	enemy.originSpawnPoint = self
	occupied = true
	enemy.Spawn()
	pass
	
