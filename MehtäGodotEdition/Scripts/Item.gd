extends Node3D
class_name Item

@export var itemName: String
@export var displayName: String
@export var description: String
@export var sprite: Sprite3D
@export var viewModel: CompressedTexture2D
@export var viewModelOffset: Vector2
@export var itemShine : Node3D
@export var customData: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	itemShine.rotate(Vector3(0,1,0),delta)
	pass

func PickUp():
	var inventory = %Inventory as Inventory
	inventory.PickUpItem(self)
	
	pass

func GetSpriteTexture():
	return sprite.texture
	
func UsePrimaryPressed():
	#print("item")
	pass
	
func UseSecondaryPressed():
	pass
	
func UsePrimaryReleased():
	pass
	
func UseSecondaryReleased():
	pass
