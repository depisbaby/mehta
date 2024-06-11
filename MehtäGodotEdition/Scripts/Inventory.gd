extends CanvasLayer
class_name Inventory

@export var inventoryWindow: Node
@export var pickUpMessage: Label

var windowOpen: bool

var grid_width = 5
var grid_height = 5

var inventorySlotScene
var inventorySlots: Array[InventorySlot] = []
var activeInventorySlot: InventorySlot
var selectedInventorySlot: InventorySlot

var messageTick: int


func _ready():
	CloseWindow()
	UpdateInventory()
	
	inventorySlotScene = preload("res://Prefabs/inventory_slot.tscn")
	
	for i in grid_height:
		
		for j in grid_width:
			var instance = inventorySlotScene.instantiate()
			var i_inventorySlot = instance as InventorySlot
			inventorySlots.append(instance)
			inventoryWindow.add_child(instance)
			instance.position = Vector2(120 * j + 20, 120 * i + 20)
			i_inventorySlot.id = ((i-1) * grid_width + j) + grid_width
			inventorySlots[i_inventorySlot.id] = i_inventorySlot
			var label: Label = inventorySlots[i_inventorySlot.id].amountLabel
			
			
			
			
	
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
		
	if messageTick > 0:
		pickUpMessage.show()
		messageTick = messageTick - 1
	else :
		pickUpMessage.hide()
		pickUpMessage.text = ""
		
	if Input.is_action_just_pressed("mouse0"):
		
		if selectedInventorySlot != null:
			activeInventorySlot = selectedInventorySlot
		
	if Input.is_action_just_released("mouse0"):
		
		if activeInventorySlot != null && selectedInventorySlot != null:
			MoveItem(activeInventorySlot, selectedInventorySlot)
		
		activeInventorySlot = null
		
	pass

func CloseWindow():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	windowOpen = false
	inventoryWindow.hide()
	
	pass
	
func OpenWindow():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	UpdateInventory()
	windowOpen = true
	inventoryWindow.show()
	
	pass

func Start():
	
	pass

func PickUpItem(item: Item):
	
	if windowOpen:
		return
	
	var targetSlot = FindSlot()
	if targetSlot == -1: 
		pickUpMessage.text = str(pickUpMessage.text, "You can't carry more items")
		messageTick = 500
		return
	
	item.hide()
	item.global_position = Vector3.ZERO
	pickUpMessage.text = str(pickUpMessage.text,"Picked up ", item.displayName, "\n")
	messageTick = 500
	
	inventorySlots[targetSlot].placedItem = item
	
	pass

func MoveItem(startSlot: InventorySlot, endSlot: InventorySlot):
	
	if startSlot == endSlot:
		return
	
	if endSlot.placedItem != null:
		var item = endSlot.placedItem
		endSlot.placedItem = startSlot.placedItem
		startSlot.placedItem = item
	
	else:
		endSlot.placedItem = startSlot.placedItem
		startSlot.placedItem = null
	
	UpdateInventory()
	pass

func FindSlot():
	for i in inventorySlots.size():
		if inventorySlots[i].placedItem == null:
			return i
	return -1
		
	pass
	
func UpdateInventory():
	
	for i in inventorySlots.size():
		var slot = inventorySlots[i]
		
		if slot.placedItem == null:
			slot.icon.hide()
			continue
		
		slot.SetSpriteTexture(slot.placedItem.GetSpriteTexture())
		slot.icon.show()
		
	pass

func SelectInventorySlot(index: int):
	selectedInventorySlot = inventorySlots[index]
	pass

