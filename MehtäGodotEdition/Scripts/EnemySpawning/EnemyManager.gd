extends Node
class_name EnemyManager

var enemyLibrary

var tick: int

var tyrmaEnemies : Array[NavAgent]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	tick = tick + 1
	
	if tick % 30 == 0:
		Update()
	
	pass

func Update():
	
	pass
