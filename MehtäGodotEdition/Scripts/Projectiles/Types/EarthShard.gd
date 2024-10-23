extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	visible = false
	pass # Replace with function body.

func Shoot(startPosition: Vector3, startDirection: Vector3):
	super.Shoot(startPosition, startDirection)
	visible = true
	pass
	
func _process(delta):
	super._process(delta)
	if _awake:
		rotate_object_local(Vector3(0,0,1), delta * 5)


	
func AfterHit(hitSolid: bool):
	_awake = false
	
	if hitSolid:
		await get_tree().create_timer(10.0).timeout
	else :
		return
	pass
	
