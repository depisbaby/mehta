extends Node
class_name EnemyManager

@export var maxSpawnDistance: int
@export var targetAmountOfEnemies: int
@export var gruntsRatio: int
@export var elitesRatio: int
@export var minibossRatio: int

var tick: int
var amountOfSpawnedEnemies

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
	tick = tick + 1
	
	if tick % 30 == 0:
		Update()
	
	pass

func Update():
	rooms.shuffle()
	var room
	
	for i in rooms:
		var distance = rooms[i].global_position - Global.player.global_position
		if distance < maxSpawnDistance:
			room = rooms[i]
			break
			
	if room == null:
		return
		
	
	
	pass

func AddRoom(room:Room):
	rooms.push_back(room)
	pass
