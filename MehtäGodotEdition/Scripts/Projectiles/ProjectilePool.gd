extends Node
class_name ProjectilePool

@export var projectilePrefab: PackedScene
@export var poolSize: int

var projectilePool: Array[Projectile] = []
var projectileQueue: Array[Projectile] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	while projectileQueue.is_empty():
		await get_tree().create_timer(0.1).timeout
		for i in poolSize:
			var projectile = projectilePrefab.instantiate()
			get_tree().root.add_child(projectile)
			projectile.projectilePool = projectileQueue
			projectile.Init(false)
			projectileQueue.push_back(projectile)
			projectilePool.push_back(projectile)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func GetProjectile() -> Projectile:
	var projectile = projectileQueue.pop_front()
	return projectile

func DeletePool():
	for i in projectilePool:
		i.DeleteFromMemory()
