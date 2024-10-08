extends NavAgent

@export var ball1: MeshInstance3D
@export var ball2: MeshInstance3D
@export var projectilePool: ProjectilePool

var direction1: Vector3
var direction2: Vector3

var healTick: float

func _ready():
	super._ready()
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
	super._process(delta)
	if !sleeping:
		ball1.rotate_object_local(Vector3(0.0,1.0, 0.0),delta)
		ball2.rotate_object_local(Vector3(0.0,1.0, 0.0),-delta)
		
		if distanceToPlayer < 10.0:
			Global.hud.MakeBlinder(delta)
			
		healTick += delta
		if healTick > 3.0:
			healTick = 0.0
			health.health = clamp(health.health + 10, 0, health.maxHealth)
		
	
	
	pass
	
func CheckPlayerPerspective():
	#override
	pass
	
func Despawn():
	projectilePool.DeletePool()	
	super.Despawn()
	
func DoCustomAction():
	
	if !seesPlayer || player.health.health <= 0:
		return
	
	var projectile: Projectile = projectilePool.GetProjectile()
	if projectile == null:
		return
	
	projectile.objectToHomeTo = Global.player.camera
		
	var shooterData = ShooterData.new()
	shooterData.startPosition = eyes.global_position 
	shooterData.startDamage = 41
	shooterData.startSpeed = 7
	shooterData.startDirection = Vector3(0,1,0)
	shooterData.ignoreEnemies = true
	projectile.Shoot(shooterData)
	pass
	
