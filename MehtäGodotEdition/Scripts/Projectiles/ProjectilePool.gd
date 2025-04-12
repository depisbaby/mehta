extends Node
class_name ProjectilePool

@export var poolSizeOverride: int
@export var spellModOverride: Node
@export var parentScript: Node

@export var projectilePrefab: Projectile
var poolSize: int
var projectilePool: Array[Projectile] = []
var projectileQueue: Array[Projectile] = []

#for saving/loading
@export var projectilePackedScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	if projectilePackedScene != null:
		var instance = projectilePackedScene.instantiate()
		if spellModOverride != null:
			instance.ApplySpellMods(spellModOverride)
		get_tree().root.add_child(instance)
		ReinitializePool(instance, poolSizeOverride)
	
	if parentScript != null:
		parentScript.ProjectilePoolReadyDone()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func GetProjectile() -> Projectile:
	var projectile = projectileQueue.pop_front()
	return projectile

func ReturnAllProjectiles():
	for i in projectilePool:
		i.Despawn()
		
	
		
func ReinitializePool(_projectilePrefab:Projectile, size:int):
	
	#clear the previous pool
	if !projectilePool.is_empty():
		ReturnAllProjectiles()
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
	
	
	pass
	
func SavePool():
	var packedScene = PackedScene.new()
	packedScene.pack(projectilePrefab)
	projectilePackedScene = packedScene
