extends Node3D
class_name Door

var open: bool
@export var doorObject: Node3D
var targetRotation: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	doorObject.rotation = lerp(doorObject.rotation, targetRotation, 0.05)
	
	pass
	
func Operate():
	
	if open:
		open = false
		targetRotation = Vector3(0,0,0)
		
	else:
		open = true
		targetRotation = Vector3(0,2,0)
	
	pass


