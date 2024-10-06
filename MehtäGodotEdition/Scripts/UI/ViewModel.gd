extends Node
class_name ViewModel

@export var textureRect: TextureRect
var walking: bool 

func _enter_tree():
	Global.viewModel = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func ChangeViewModel(texture: CompressedTexture2D, offset: Vector2):
	
	if texture == null:
		textureRect.hide()
	else:
		textureRect.texture = texture
		textureRect.position = offset
		textureRect.show()
		
	pass
	
