extends Item

@export var startSpeed: float
@export var damage: int
@export var coolDown: float

@onready var projectilePrefab = preload("res://Prefabs/Projectiles/Windball.tscn")
var projectileQueue: Array[Projectile] = []

var cooldownTick: float


func _ready():
	super._ready()
	#COPY PASTE
	
	while projectileQueue.is_empty():
		await get_tree().create_timer(0.1).timeout
		for i in 30:
			var projectile = projectilePrefab.instantiate()
			get_tree().root.add_child(projectile)
			projectile.projectilePool = projectileQueue
			projectile.Init(false)
			projectileQueue.push_back(projectile)
			
	
	#COPY PASTE	
	
	pass # Replace with function body.

func _process(delta):
	super._process(delta)
	cooldownTick = clamp(cooldownTick - delta,0.0, 100.0)
	
	

	
func UsePrimaryPressed():
	
	if cooldownTick != 0:
		return
	
	cooldownTick = coolDown
	
	var projectile = projectileQueue.pop_front()
	if(projectile != null):
		var shooterData = ShooterData.new()
		shooterData.startPosition = Global.player.camera.global_position
		shooterData.startDirection = -Global.player.camera.get_camera_transform().basis.z
		shooterData.startSpeed = startSpeed
		shooterData.startDamage = damage
		projectile.Shoot(shooterData)
	
	pass
	
func UseSecondaryPressed():
	pass
	
func UsePrimaryReleased():
	pass
	
func UseSecondaryReleased():
	pass
