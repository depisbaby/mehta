extends Node3D

@export var enemyScene: PackedScene

@onready var devSprite: Sprite3D = $Sprite3D

var exhausted: bool

func _ready():
	await get_tree().create_timer(1).timeout
	Spawn()
	pass

func _process(delta):
	
	pass

func Spawn():
	exhausted = true
	var enemy = enemyScene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	enemy.WakeUp()
	
	
	pass
	
