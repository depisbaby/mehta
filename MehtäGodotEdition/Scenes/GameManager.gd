extends Node
class_name GameManager

var doors: Array[Door]
var gameOnGoing: bool
var preparationDone: bool
var rng = RandomNumberGenerator.new()

func _enter_tree():
	Global.gameManager = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func StartNewGame():
	preparationDone = false
	if gameOnGoing:
		return
	gameOnGoing = true
	
	#generate seed
	var my_random_number = randf_range(-9223372036854775808, 9223372036854775807)
	rng.seed = my_random_number
	rng.state = 0
	
	#new save file
	Global.dataPersistenceManager.Save()
	Global.dataPersistenceManager.persistentData.seed = my_random_number
	
	#generate new map
	await Global.mapGenerator.GenerateMap("tyrma",my_random_number)
	
	#await get_tree().create_timer(3.0).timeout
	
	#prepare player
	#Global.player.character.global_position = Vector3(0,-2,10)
	Global.player.character.global_position = Vector3(0,0,0)
	Global.player.frozen = false
	
	#play
	Global.uiManager.CloseAll()
	preparationDone = true
	
	pass
	
func ContinueGame():
	preparationDone = false
	if gameOnGoing:
		return
	gameOnGoing = true
	
	await Global.mapGenerator.GenerateMap(Global.dataPersistenceManager.persistentData.playerCurrentMap,Global.dataPersistenceManager.persistentData.seed)
	
	Global.dataPersistenceManager.Load()
	Global.player.frozen = false
	
	#play
	Global.uiManager.CloseAll()
	preparationDone = true
	
	pass
