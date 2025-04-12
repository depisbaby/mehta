extends Node3D
class_name EnemyManager

@export var maxSpawnDistance: int
@export var maxAmountOfEnemies: int
@export var gruntsRatio: int
@export var elitesRatio: int
@export var minibossRatio: int
var gruntScenes: Array[PackedScene] = [
	preload("res://PackedScenes/Enemies/enemy_prisoner.tscn"),
]
var eliteScenes: Array[PackedScene] = [
	preload("res://PackedScenes/Enemies/enemy_warden.tscn"),
]
var minibossScenes: Array[PackedScene]= [
	preload("res://PackedScenes/Enemies/enemy_lakehorror.tscn"),
]

var enemyPool: Array[NavAgent]

var tick: int
var amountOfSpawnedEnemies: int
var rooms:Array[Room]

func _enter_tree():
	Global.enemyManager = self
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if !Global.gameManager.preparationDone:
		return
		
	tick = tick + 1
	
	if tick % (60) == 0:
		AmbientSpawning()
	
	pass

func AmbientSpawning():
	if amountOfSpawnedEnemies >= maxAmountOfEnemies:
		return
	
	rooms.shuffle()
	var room:Room
	
	for _room in rooms:
		var distance = (_room.global_position - Global.player.global_position).length()
		if distance < maxSpawnDistance:
			room = _room
			break
			
	if room == null:
		return
	
	room.Spawn()
	
	pass

func AddRoom(room:Room):
	rooms.push_back(room)
	pass
	
func AddEnemy():
	amountOfSpawnedEnemies = amountOfSpawnedEnemies + 1
	print("Enemy spawned. Amount of enemies: ", amountOfSpawnedEnemies)
	
func RemoveEnemy():
	amountOfSpawnedEnemies = amountOfSpawnedEnemies - 1
	print("Enemy despawned. Amount of enemies: ", amountOfSpawnedEnemies)

func InitializeTyrmaPool():
	for i in 30:
		
		var total = gruntsRatio + elitesRatio + minibossRatio
		var rng = randi_range(0,total)
		var instance:NavAgent
		if rng <= gruntsRatio:
			var rng1 = randi_range(0, gruntScenes.size()-1)
			instance = gruntScenes[rng1].instantiate()
		
		elif  rng > gruntsRatio && rng < (gruntsRatio + elitesRatio):
			var rng1 = randi_range(0, eliteScenes.size()-1)
			instance = eliteScenes[rng1].instantiate()
			
		elif rng >= (gruntsRatio + elitesRatio):
			var rng1 = randi_range(0, minibossScenes.size()-1)
			instance = minibossScenes[rng1].instantiate()
		
		add_child(instance)
		enemyPool.push_back(instance) 
		instance.hide()
		instance.global_position = Vector3(1000,1000,1000)
	pass

func ReturnToPool(enemy: NavAgent):
	enemy.spawned = false
	enemy.hide()
	enemy.global_position = Vector3(1000,1000,1000)
	enemyPool.push_back(enemy)
	pass
	
func PopFromPool()->NavAgent:
	if enemyPool.size() == 0:
		return null
	var enemy: NavAgent = enemyPool.pop_front()
	enemy.show()
	return enemy
