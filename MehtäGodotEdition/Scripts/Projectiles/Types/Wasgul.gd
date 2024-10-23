extends Projectile
var overrideSpeed: float

func Shoot(startPosition: Vector3, startDirection: Vector3):
	super.Shoot(startPosition, startDirection)
	overrideSpeed = 2.0
	velocity = startDirection * overrideSpeed
	pass
	
func _process(delta: float):
	super._process(delta)
	
	if _awake:
		overrideSpeed = move_toward(overrideSpeed, spellMods.speed,delta)
		
	

func MoveProjectile(delta):
	
	if(objectHoming == null):
		return
	
	var targetDirection: Vector3 = (objectHoming.global_position - global_position).normalized() * overrideSpeed
	
	velocity = velocity.move_toward(targetDirection,delta * 2.0)
	
	var nextPosition: Vector3 = global_position + velocity * delta
	
	look_at(nextPosition, Vector3(0,1,0))
	
	global_position = nextPosition
	
	pass
