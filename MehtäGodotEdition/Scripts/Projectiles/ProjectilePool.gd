extends Node
class_name ProjectilePool

@export var poolSizeOverride: int
@export var spellModsOverride: Node

var projectilePrefab: Projectile
var poolSize: int
var projectilePool: Array[Projectile] = []
var projectileQueue: Array[Projectile] = []

#for saving/loading
@export var projectilePackedScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if projectilePackedScene != null:
		await get_tree().create_timer(0.1).timeout
		var instance = projectilePackedScene.instantiate()
		get_tree().root.add_child(instance)
		instance.ApplySpellMods(spellModsOverride)
		ReinitializePool(instance, poolSizeOverride)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func GetProjectile() -> Projectile:
	var projectile = projectileQueue.pop_front()
	return projectile

func DeleteProjectiles():
	for i in projectilePool:
		i.DeleteFromMemory()
		
	projectilePrefab.DeleteFromMemory()
	
		
func ReinitializePool(_projectilePrefab:Projectile, size:int):
	
	#clear the previous pool
	if !projectilePool.is_empty():
		DeleteProjectiles()
		projectilePool.clear()
		projectileQueue.clear()
	
	#Make the inputed instance of the projectile the "prefab" of this pool.
	#All of the projectiles in the pool have the same spellmods as the
	#prefab.
	projectilePrefab = _projectilePrefab
	
	#Instantiate all of the projectiles
	for i in size:
		var projectile = projectilePrefab.duplicate()
		projectile.ApplySpellMods(projectilePrefab.spellMods)
		get_tree().root.add_child(projectile)
		#print(projectile.spellMods.speed)
		projectile.projectilePool = projectileQueue
		projectile.Init()
		projectileQueue.push_back(projectile)
		projectilePool.push_back(projectile)
	
	#make a packed scene out of the projectile prefab. This is used for
	#loading/saving this projectile pool
	var packedScene = PackedScene.new()
	packedScene.pack(projectilePrefab)
	projectilePackedScene = packedScene
	
	pass
