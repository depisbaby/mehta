extends Node3D
class_name Projectile

@export var sprite: Sprite3D

var ignoreEnemies: bool

var speed: float
var raycast: PhysicsRayQueryParameters3D
var _awake: bool
var bouncesRemaining: int
var velocity: Vector3
var projectilePool: Array[Projectile]
var damage: int

var lastPosition: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MoveProjectile(delta)
	HitReg()
	lastPosition = global_position
	pass
	
func Shoot(shooterData: ShooterData):
	
	global_position = shooterData.startPosition
	velocity = shooterData.direction * shooterData.startSpeed
	lastPosition = global_position
	damage = shooterData.startDamage
	
	sprite.show()
	_awake = true
	pass
	
func Despawn():
	_awake = false
	sprite.hide()
	if projectilePool != null:
		projectilePool.push_back(self)
	pass
	
func HitReg():
	raycast.from = lastPosition
	raycast.to = global_position
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(raycast)
	if !intersection.is_empty():
		print(intersection.collider.name)
		if intersection.collider.is_in_group("Hitbox"):
			
			var health = intersection.collider as Health
			health.health = health.health - damage
			
		if bouncesRemaining == 0:
			Despawn()
			return
		
		global_position = intersection.position
		var normal = intersection.normal.normalized()
		velocity = velocity - 2 * velocity.dot(normal) * normal
	
		bouncesRemaining = bouncesRemaining - 1
			
	pass

func MoveProjectile(delta):
	global_position = global_position + velocity * delta
	pass
	
func Init(ignoreEnemies: bool):
	if ignoreEnemies:
		raycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),5)
	else:
		raycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),13)
		
	raycast.hit_from_inside = false
	raycast.hit_back_faces = false
	raycast.collide_with_areas = true
	sprite.hide()
	pass
