extends Node
class_name DataPersistenceManager

var subscribers: Array[Node]

const SAVE_GAME_PATH = "user://save.tres"
var persistentData: PersistentData

func _enter_tree() -> void:
	Global.dataPersistenceManager = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Global.uiManager.viewOpen:
		return
	
	if(Input.is_action_just_pressed("debug1")):
		Save()
	
	if(Input.is_action_just_pressed("debug2")):
		Load()
	
	pass
	
func Save():
	
	persistentData = PersistentData.new()
	
	for subscriber in subscribers:
		print("attempting to save subscriber ", subscriber.name)
		subscriber.Save(persistentData)
	
	ResourceSaver.save(persistentData, SAVE_GAME_PATH)
	
	pass
	
func Load():
	
	persistentData = ResourceLoader.load(SAVE_GAME_PATH)
	
	for subscriber in subscribers:
		print("attempting to load subscriber ", subscriber.name)
		subscriber.Load(persistentData)
	
	pass
	
func Subscribe(node :Node):
	subscribers.push_back(node)
	print("[DataPersistenceManager] ",node.name, " subscribed")
	pass
