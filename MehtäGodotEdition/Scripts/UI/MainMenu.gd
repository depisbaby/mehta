extends CanvasLayer
class_name MainMenu

@export var mainMenuWindow: Control
@export var loadingScreen: Control

func _enter_tree():
	Global.mainMenu = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_new_button_pressed():
	Global.gameManager.StartNewGame()
	pass # Replace with function body.

#UI interface
func OpenView():
	pass

func CloseView():
	mainMenuWindow.hide()
	#loadingScreen.hide()
	pass
	
func IsOpen()->bool:
	if mainMenuWindow.visible:
		return true
	#if loadingScreen.visible:
		#return true
		
	return false
	pass
