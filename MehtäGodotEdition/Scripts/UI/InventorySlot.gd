extends TextureRect

class_name InventorySlot

@export var id: int
var placedItem: Item

@export var amountLabel: Label
@export var icon: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func SetSpriteTexture(texture: CompressedTexture2D):
	icon.texture = texture
	pass
	

func _on_mouse_entered():
	var inventory = get_tree().get_root().get_node("root").get_node("%Inventory") as Inventory
	inventory.SelectInventorySlot(id)
	
	pass 
