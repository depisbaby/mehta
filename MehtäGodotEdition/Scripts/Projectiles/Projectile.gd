extends Node3D
class_name Projectile

#modded variables
@export var spellMods: Node

#on shooting variables
var objectHoming: Node3D

#other
var raycast: PhysicsRayQueryParameters3D
var _awake: bool
var velocity: Vector3
var projectilePool: Array[Projectile]
var lastPosition: Vector3
var remainingBounces: int
var remainingPenetration: int

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !_awake:
		return
	
	MoveProjectile(delta)
	HitReg()
	lastPosition = global_position
	pass
	
func Shoot(startPosition: Vector3, startDirection: Vector3):
	
	global_position = startPosition
	velocity = startDirection * spellMods.speed
	lastPosition = global_position
	look_at(global_position + startDirection)
	remainingBounces = spellMods.bounces
	remainingPenetration = spellMods.penetration
	
	DespawnAfterTime(spellMods.lifeSpan)
	
	visible = true
	_awake = true
	pass
	
func Despawn():
	
	if !_awake:
		return
	
	_awake = false
	if projectilePool != null:
		projectilePool.push_back(self)
	visible = false	
	
	pass
	
func HitReg():
	raycast.from = lastPosition
	raycast.to = global_position
	var hitSolid = true
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(raycast)
	if !intersection.is_empty():
		print(intersection.collider.name)
		if intersection.collider.is_in_group("Hitbox"): #hit character
			
			var health = intersection.collider as Health
			health.DealDamage(spellMods.damage)
			
			if remainingPenetration == 0:
				await AfterHit(false)
				Despawn()
				return
				
			remainingPenetration = remainingPenetration - 1
			
		else: #hit environment
			
			if remainingBounces == 0:
				await AfterHit(true)
				Despawn()
				return
		
			global_position = intersection.position
			var normal = intersection.normal.normalized()
			velocity = velocity - 2 * velocity.dot(normal) * normal
		
			remainingBounces = remainingBounces - 1
			
	pass

func MoveProjectile(delta):
	
	if spellMods.homing && objectHoming != null:
		var targetVector:Vector3 = (objectHoming.global_position - global_position).normalized()
		velocity = velocity.move_toward(targetVector, spellMods.speed * delta)
	else:
		velocity.y = clamp(velocity.y - spellMods.weight * delta, -spellMods.speed, spellMods.speed)
		global_position = global_position + velocity * delta
		
	pass
	
func Init():
	if spellMods.ignoreEnemies:
		raycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),5)
	else:
		raycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),13)
		
	raycast.hit_from_inside = false
	raycast.hit_back_faces = false
	raycast.collide_with_areas = true
	visible = false
	pass
	
func AfterHit(hitSolid: bool):
	
	pass
	
func DespawnAfterTime(time: float):
	
	await get_tree().create_timer(time).timeout
	if _awake:
		Despawn()
	pass


func ApplySpellMods(_spellMods):
	spellMods = _spellMods
	pass
	
