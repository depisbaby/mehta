extends NavAgent

func _ready():
	super._ready()
	speed = speed + randf_range(-1.0, 1.0)

func ReactToDamage():
	
	if currentAction != Action.NONE:
		return
		
	if rng.randi_range(0,5) == 0:
		MoveToRandomPlace()
	
	pass
