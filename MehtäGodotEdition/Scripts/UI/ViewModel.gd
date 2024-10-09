extends Node
class_name ViewModel

@export var textureRect: TextureRect
@export var viewModelSwing: Control
var walking: bool 

var walkingWeight:float
var time: float
var useItemWeight1:float
var useItemWeight2:float
var viewModelOrigin: Vector2

func _enter_tree():
	Global.viewModel = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 8.0
	
	if Global.player.walking == true:
		walkingWeight += delta * 5.0
	else: 
		walkingWeight -= delta * 5.0
	walkingWeight = clamp(walkingWeight, 0.0, 1.0)
	
	Swinging()
	UseItemAnimation(delta)
	pass
	
func ChangeViewModel(texture: CompressedTexture2D, offset: Vector2):
	
	if texture == null:
		textureRect.hide()
	else:
		textureRect.texture = texture
		textureRect.position = offset
		viewModelOrigin = offset
		textureRect.show()
		
	pass
	
func Swinging():
	viewModelSwing.position = Vector2(0,0) + Vector2(cos(time)* 60.0 *walkingWeight,-abs(cos(time)* 20.0 *walkingWeight))
	pass
	
func UseItemAnimation(delta):
	if useItemWeight1 == 0.0:
		return
	useItemWeight1 = lerp(useItemWeight1, 0.0, delta * 20.0)
	useItemWeight2 = lerp(useItemWeight2, useItemWeight1, delta * 20.0)
	
	textureRect.position = viewModelOrigin + Vector2(-useItemWeight2 * 400.0, -useItemWeight2 * 60.0)
	pass

func UseItem():
	useItemWeight1 = 1.0
	pass
	
