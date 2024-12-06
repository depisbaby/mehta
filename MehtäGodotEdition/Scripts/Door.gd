extends Node3D
class_name Door

var open: bool
@export var doorObject: Node3D
@export var lockedWithId: String #"" is not locked
var targetRotation: Vector3
var closedRotation : Vector3
var openRotation : Vector3

#mapgen
var parentRoom: Room
var filled: bool
@export var seal: Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Global.gameManager.doors.push_back(self)
	
	if doorObject == null:
		return
	closedRotation = doorObject.rotation_degrees
	openRotation = closedRotation + Vector3(0,90,0)
	targetRotation = openRotation
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if doorObject == null:
		return
	doorObject.rotation_degrees = lerp(doorObject.rotation_degrees, targetRotation, delta*5)
	
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

func Remove():
	queue_free() 
	pass
	
func RemoveSeal():
	seal.queue_free()
	
func Close():
	open = false
	targetRotation = closedRotation
