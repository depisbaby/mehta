extends NavAgent

@export var mancatcherSpeed: float
@export var mancatcherProjectilePool: ProjectilePool
@export var cageAbility: PackedScene

var cageUsed: bool

func _ready():
	super._ready()
	
	pass
	

func DoRangedAttack():
	
	if mancatcherProjectilePool.projectileQueue.is_empty():
		return
	
	currentAction = Action.ATTACKING
	
	OverrideAnimation("attack")
	await get_tree().create_timer(0.2 * 3).timeout
	
	if sleeping:
		currentAction = Action.NONE
		return
	
	var random = rng.randi_range(0,10)
	
	if random >= 9 && !cageUsed:
		cageUsed = true
		DoCageAbility()
		EndAction(1.0)
		return
	
	var projectile: Projectile = mancatcherProjectilePool.GetProjectile()
	
	if projectile == null:
		EndAction(1.0)
		return
		
	projectile.Shoot(eyes.global_position, TracePlayer(mancatcherProjectilePool.projectilePrefab.spellMods.speed))
	
	EndAction(1.0)
	pass

func ReactToDamage():
	
	if rng.randi_range(0, 2) == 0:
		return
	
	MoveToRandomPlace()
	
	pass

func DoCustomAction():
	
	pass
	
func DoCageAbility():
	
	if !seesPlayer:
		return
		
	var instance:Node3D = cageAbility.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = Global.player.character.global_position
	
	pass
	
