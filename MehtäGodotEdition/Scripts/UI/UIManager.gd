extends Node
class_name UIManager
@export var UIViews: Array[CanvasLayer]

var viewOpen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.uiManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OpenView(name:String):
	for view in UIViews:
		if view.name == name:
			view.OpenView()
		
	CheckForOpen()
	
func CloseView(name:String):
	for view in UIViews:
		if view.name == name:
			view.CloseView()
			
	CheckForOpen()
	Global.toolTips.Close()

func OpenOnly(name:String):
	CloseAll()
	OpenView(name)
	
func CloseAll():
	for view in UIViews:
		view.CloseView()
	
	CheckForOpen()

func CheckForOpen():
	viewOpen = false
	for view in UIViews:
		if view.IsOpen():
			viewOpen = true
