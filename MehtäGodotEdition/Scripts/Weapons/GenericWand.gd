extends Item

@export var startSpeed: float

@onready var projectilePrefab = preload("res://Prefabs/projectile.tscn")
var projectileQueue: Array[Projectile] = []

func _ready():
	while projectileQueue.is_empty():
		await get_tree().create_timer(0.1).timeout
		for i in 100:
			var projectile = projectilePrefab.instantiate()
			get_tree().root.add_child(projectile)
			projectile.projectilePool = projectileQueue
			projectileQueue.push_back(projectile)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func UsePrimaryPressed():
	var projectile = projectileQueue.pop_front()
	if(projectile != null):
		var shooterData = ShooterData.new()
		shooterData.startPosition = Global.player.camera.global_position
		shooterData.direction = -Global.player.camera.get_camera_transform().basis.z
		shooterData.startSpeed = startSpeed
		projectile.Shoot(shooterData)
	
	pass
	
func UseSecondaryPressed():
	pass
	
func UsePrimaryReleased():
	pass
	
func UseSecondaryReleased():
	pass
