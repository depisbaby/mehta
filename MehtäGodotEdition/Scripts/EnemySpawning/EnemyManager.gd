extends Node3D
class_name EnemyManager

@export var maxSpawnDistance: int
@export var maxAmountOfEnemies: int
@export var gruntsRatio: int
@export var elitesRatio: int
@export var minibossRatio: int
@export var enemyScenes: Array[PackedScene]

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
	
	if tick % 60*10 == 0:
		AttemptSpawn()
	
	pass

func AttemptSpawn():
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
	
	var total = gruntsRatio + elitesRatio + minibossRatio
	var rng = randi_range(0,total)
	if rng <= gruntsRatio:
		room.SpawnGrunt()
	
	elif  rng > gruntsRatio && rng < (gruntsRatio + elitesRatio):
		room.SpawnElite()
		
	elif rng >= (gruntsRatio + elitesRatio):
		room.SpawnMiniboss()
	
	pass

func AddRoom(room:Room):
	rooms.push_back(room)
	pass
	
func AddEnemy():
	amountOfSpawnedEnemies = amountOfSpawnedEnemies + 1
	
func RemoveEnemy():
	amountOfSpawnedEnemies = amountOfSpawnedEnemies - 1
