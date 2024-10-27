extends Node3D
class_name Door

var open: bool
@export var doorObject: Node3D
@export var lockedWithId: String #"" is not locked
var targetRotation: Vector3
var closedRotation : Vector3
var openRotation : Vector3



# Called when the node enters the scene tree for the first time.
func _ready():
	closedRotation = doorObject.global_rotation
	openRotation = closedRotation + Vector3(0,2,0)
	targetRotation = closedRotation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	doorObject.global_rotation = lerp(doorObject.global_rotation, targetRotation, 0.05)
	
	pass
	
func Operate():
	
	if lockedWithId != "":
		if !Global.inventory.CheckForKey(lockedWithId):
			Global.inventory.ShowMessage("Door is locked.")
			return
	
	if open:
		open = false
		targetRotation = closedRotation
		
	else:
		open = true
		targetRotation = openRotation
	
	pass
