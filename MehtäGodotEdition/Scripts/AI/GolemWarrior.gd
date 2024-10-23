extends NavAgent

@export var earthShardSpeed: float
@export var rangedDamage: int
@export var spellMods: Node
@export var projectilePool: ProjectilePool

func _ready() -> void:
	super._ready()
	customActionTick = 4
	
	#projectilePool.ReinitializePool(Global.magicManager.GetSpell("EarthShard", spellMods), 5)
	
	pass

func _process(delta: float) -> void:
	super._process(delta)
	pass

func DoRangedAttack():
	
	if projectilePool.projectileQueue.is_empty():
		return
	
	currentAction = Action.ATTACKING
	
	OverrideAnimation("ranged_attack")
	await get_tree().create_timer(0.2 * 9.0).timeout
	
	if sleeping:
		currentAction = Action.NONE
		return
	
	var projectile: Projectile = projectilePool.GetProjectile()
	
	if projectile == null:
		return
		
	projectile.Shoot(eyes.global_position, TracePlayer(earthShardSpeed))
	
	EndAction(1.2)
	pass

func ReactToDamage():
	
	if rng.randi_range(0, 2) == 0:
		return
	
	MoveToRandomPlace()
	
	pass

func DoCustomAction():
	
	if currentAction != Action.NONE:
		return
		
	if rng.randi_range(0,10) == 0:
		MoveToRandomPlace()
	
	pass
	
