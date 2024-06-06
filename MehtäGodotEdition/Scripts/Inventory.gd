extends CanvasLayer

@export var backGround: Node

var windowOpen: bool

var grid_width = 5
var grid_height = 5

var inventorySlotScene
var inventorySlots


func _ready():
	
	inventorySlotScene = preload("res://Prefabs/item_slot.tscn")
	
	for i in grid_width:
		
		for j in grid_height:
			var instance = inventorySlotScene.instantiate()
			inventorySlots.append(instance)
			backGround.add_child(instance)
			instance.position = Vector2(120 * i + 20, 120 * j + 20)
			
			
	
	print("Inventory size: ", inventorySlots.size())
	
	pass
			



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		print("Inventory button pressed")
		
		if windowOpen:
			CloseWindow()
		else:
			OpenWindow()
		
	pass

func CloseWindow():
	windowOpen = false
	hide()
	
	pass
	
func OpenWindow():
	windowOpen = true
	show()
	
	pass

func Start():
	
	pass
	

func _on_player_slot_item_dropped(id):
	pass # Replace with function body.
