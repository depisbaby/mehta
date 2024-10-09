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

var equippedItem: Item

var messageTick: int


func _ready():
	Global.inventory = self
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
			
	UpdateInventory()
	CloseWindow()
			
	
	#print("Inventory size: ", inventorySlots.size())
	
	pass
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("Inventory"):
		#wwwwwwwwwwwwwwwwwwwww("Inventory button pressed")
		
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
		
	if Input.is_action_just_pressed("switch"):
		MoveItem(inventorySlots[0], inventorySlots[1])
		
	if Input.is_action_just_pressed("mouse0"):
		
		if selectedInventorySlot != null:
			activeInventorySlot = selectedInventorySlot
		
	if Input.is_action_just_released("mouse0"):
		
		if activeInventorySlot != null && selectedInventorySlot != null:
			MoveItem(activeInventorySlot, selectedInventorySlot)
		
		activeInventorySlot = null
	
	if Input.is_action_just_released("mouse1"):
		if selectedInventorySlot != null:
			if selectedInventorySlot.placedItem != null:
				Global.toolTips.ShowToolTips(selectedInventorySlot.placedItem.actions, selectedInventorySlot.placedItem as Item)
	

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
	UpdateInventory()
	
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
		
	if inventorySlots[0].placedItem != null:
		equippedItem = inventorySlots[0].placedItem
		if equippedItem.viewModel != null:
			Global.viewModel.ChangeViewModel(equippedItem.viewModel, equippedItem.viewModelOffset)
		else:
			Global.viewModel.ChangeViewModel(null, Vector2(0,0))
	else :
		Global.viewModel.ChangeViewModel(null, Vector2(0,0))
		equippedItem = null
	pass

func SelectInventorySlot(index: int):
	selectedInventorySlot = inventorySlots[index]
	pass
	
func CheckForKey(id: String) -> bool:
	var result = false
	for slot in inventorySlots:
		if slot.placedItem != null && slot.placedItem.customData.size() == 2:
			if slot.placedItem.customData[0] == "key" && slot.placedItem.customData[1] == id:
				result = true
			
	return result
	pass

func ShowMessage(message: String):
	pickUpMessage.text = message
	messageTick = 500
	
