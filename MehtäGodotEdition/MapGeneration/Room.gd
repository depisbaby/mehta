extends Node3D
class_name Room

@export var doors : Array[Door]
@export var overlapBoxes : Array[Area3D]
@export var roomGruntsIds: Array[int]
@export var roomElitesIds: Array[int]
@export var roomMinibossIds: Array[int]
#
var id: int
var visionRaycast: PhysicsRayQueryParameters3D
var enemySpawnPoints : Array[EnemySpawnPoint]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Place(mapGenerator: MapGenerator):
	for door in doors:
		door.parentRoom = self
		if door.filled:
			door.RemoveSeal()
			door.Remove()
		else :
			mapGenerator.AddOpenDoor(door)
			pass
	
	Global.enemyManager.AddRoom(self)
	visionRaycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),1)
	
	pass

func GetOverLapping()-> bool:
	
	for box in overlapBoxes:
		if box.has_overlapping_areas():
			return true
	
	return false
	pass

func SpawnGrunt():
	var spawnPoint:EnemySpawnPoint = GetEnemySpawnPoint()
	if spawnPoint == null:
		return
	var rng = randi_range(0,roomGruntsIds.size()-1)
	var chosen: PackedScene = Global.enemyManager.enemyScenes[roomGruntsIds[rng]]
	spawnPoint.Spawn(chosen)
		
	pass
	
func SpawnElite():
	var spawnPoint:EnemySpawnPoint = GetEnemySpawnPoint()
	if spawnPoint == null:
		return
	var rng = randi_range(0,roomElitesIds.size()-1)
	var chosen: PackedScene = Global.enemyManager.enemyScenes[roomElitesIds[rng]]
	spawnPoint.Spawn(chosen)
	pass
	
func SpawnMiniboss():
	var spawnPoint:EnemySpawnPoint = GetEnemySpawnPoint()
	if spawnPoint == null:
		return
	var rng = randi_range(0,roomMinibossIds.size()-1)
	var chosen: PackedScene = Global.enemyManager.enemyScenes[roomMinibossIds[rng]]
	spawnPoint.Spawn(chosen)
	pass
	
func GetEnemySpawnPoint()-> EnemySpawnPoint:
	var rng = randi_range(0,enemySpawnPoints.size()-1)
	var chosen:EnemySpawnPoint = enemySpawnPoints[rng]
	
	if chosen.occupied:
		return null
	
	visionRaycast.from = chosen.top.global_position
	visionRaycast.to = Global.player.camera.global_position
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(visionRaycast)
	if intersection.is_empty():
		return null
		
	return chosen
	pass
