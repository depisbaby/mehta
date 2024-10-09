extends Node3D

@export var enemyScene: PackedScene

@onready var devSprite: Sprite3D = $Sprite3D

var exhausted: bool

func _ready():
	devSprite.visible = false
	pass

func _process(delta):
	
	if exhausted:
		return
	
	if Global.player == null:
		return
	
	if (Global.player.global_position - global_position).length() < 100:
		Spawn()
			
	pass

func Spawn():
	exhausted = true
	var enemy = enemyScene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	enemy.WakeUp()
	
	
	pass
	
