extends NavAgent

@export var earthShardSpeed: float
@export var rangedDamage: int

@onready var projectilePrefab = preload("res://Prefabs/Projectiles/EarthShard.tscn")
var projectileQueue: Array[Projectile] = []

func _ready() -> void:
	super._ready()
	customActionTick = 4
	
	while projectileQueue.is_empty():
		await get_tree().create_timer(0.1).timeout
		for i in 5:
			var projectile = projectilePrefab.instantiate()
			get_tree().root.add_child(projectile)
			projectile.projectilePool = projectileQueue
			projectile.Init(false)
			projectileQueue.push_back(projectile)
	
	pass

func _process(delta: float) -> void:
	super._process(delta)
	pass

func DoRangedAttack():
	
	if projectileQueue.is_empty():
		return
	
	currentAction = Action.ATTACKING
	
	OverrideAnimation("ranged_attack")
	await get_tree().create_timer(0.2 * 9.0).timeout
	
	if sleeping:
		currentAction = Action.NONE
		return
	
	var projectile = projectileQueue.pop_front()
	if(projectile != null):
		var shooterData = ShooterData.new()
		shooterData.startPosition = eyes.global_position
		var dir: Vector3 = TracePlayer(earthShardSpeed)
		shooterData.startDirection = dir
		shooterData.startSpeed = earthShardSpeed
		shooterData.startDamage = rangedDamage
		shooterData.ignoreEnemies = true
		projectile.global_position = eyes.global_position
		projectile.look_at(Global.player.global_position)
		projectile.Shoot(shooterData)
	
	
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
	
