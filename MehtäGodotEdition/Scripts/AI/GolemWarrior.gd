extends NavAgent

@onready var projectilePrefab = preload("res://Prefabs/projectile.tscn")

func _ready() -> void:
	super._ready()
	pass

func _process(delta: float) -> void:
	super._process(delta)
	pass

func DoRangedAttack():
	currentAction = Action.ATTACKING
	
	OverrideAnimation("attack")
	
	
	
	pass
