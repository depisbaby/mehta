extends NavAgent

@export var ball1: MeshInstance3D
@export var ball2: MeshInstance3D
@export var projectilePool: ProjectilePool
@export var spellMods: Node

var wasgul: Projectile
var direction1: Vector3
var direction2: Vector3

var healTick: float

func _ready():
	super._ready()
	
	#projectilePool.ReinitializePool(Global.magicManager.GetSpell("Wasgul", spellMods), 5)
	
	customActionTick = 50
	pass

func Animations():
	#override
	
	pass

func Die():
	super.Die()
	ball1.visible = false
	ball2.visible = false
	pass

func _process(delta):
	if !sleeping:
		ball1.rotate_object_local(Vector3(0.0,1.0, 0.0),delta)
		ball2.rotate_object_local(Vector3(0.0,1.0, 0.0),-delta)
		
		if distanceToPlayer < 10.0:
			Global.hud.MakeBlinder(delta*0.2)
			pass
			
		healTick += delta
		if healTick > 3.0:
			healTick = 0.0
			health.health = clamp(health.health + 10, 0, health.maxHealth)
		
	
	
	pass
	
func CheckPlayerPerspective():
	#override
	pass
	
func Despawn():
	projectilePool.DeleteProjectiles()	
	super.Despawn()
	
func DoCustomAction():
	
	if !seesPlayer || player.health.health <= 0:
		return
	
	var projectile: Projectile = projectilePool.GetProjectile()
	
	if projectile == null:
		return
	
	projectile.objectHoming = Global.player.camera
	projectile.Shoot(eyes.global_position, Vector3(0,1,0))
	
	pass
	
