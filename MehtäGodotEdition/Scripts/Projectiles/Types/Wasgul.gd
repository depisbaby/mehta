extends Projectile

var objectToHomeTo: Node3D


func MoveProjectile(delta):
	
	var targetDirection: Vector3 = (objectToHomeTo.global_position - global_position).normalized() * speed
	
	velocity = velocity.move_toward(targetDirection,delta * 2)
	
	var nextPosition: Vector3 = global_position + velocity * delta
	
	look_at(nextPosition, Vector3(0,1,0))
	
	global_position = nextPosition
	
	pass
