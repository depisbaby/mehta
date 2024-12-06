extends Node
class_name GameManager

var doors: Array[Door]
var gameOnGoing: bool

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
	
	if gameOnGoing:
		return
	
	gameOnGoing = true
	
	#generate new map
	await Global.mapGenerator.GenerateMap("tyrma","")
	
	
	#generate nav mesh
	await Global.navMesh.BakeNavMesh()
	var _seconds: int
	while !Global.navMesh.navMeshBaked:
		await get_tree().create_timer(1.0).timeout
		_seconds = _seconds + 1
	print("baking done after ", _seconds, " seconds")
	
	for door in doors:
		if door != null:
			door.Close()
	
	await get_tree().create_timer(3.0).timeout
	
	#prepare player
	Global.player.character.global_position = Vector3(0,0,0)
	Global.player.frozen = false
	
	#play
	Global.uiManager.CloseAll()
	
	pass
