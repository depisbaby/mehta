extends Node3D
class_name Item

@export var itemName: String
@export var displayName: String
@export var description: String
@export var sprite: Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func PickUp():
	var inventory = %Inventory as Inventory
	inventory.PickUpItem(self)
	
	pass

func GetSpriteTexture():
	return sprite.texture
	
func UsePrimaryPressed():
	print("item")
	pass
	
func UseSecondaryPressed():
	pass
	
func UsePrimaryReleased():
	pass
	
func UseSecondaryReleased():
	pass
