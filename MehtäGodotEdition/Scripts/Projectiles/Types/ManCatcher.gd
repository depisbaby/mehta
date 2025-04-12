extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	visible = false
	name = "Mancacher"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if _awake:
		rotate_object_local(Vector3(0,0,1), delta * 5)
	pass

func Shoot(startPosition: Vector3, startDirection: Vector3):
	super.Shoot(startPosition, startDirection)
	visible = true
	pass
