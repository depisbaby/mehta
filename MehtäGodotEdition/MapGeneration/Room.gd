extends Node3D
class_name Room

@export var doors : Array[Door]
@export var overlapBoxes : Array[Area3D]
@export var enemySpawnPoints : Array[EnemySpawnPoints]
#
var id: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Place(mapGenerator: MapGenerator):
	for door in doors:
		door.parentRoom = self
		if door.filled:
			door.RemoveSeal()
			door.Remove()
		else :
			mapGenerator.AddOpenDoor(door)
			pass
	
	Global.enemyManager.AddRoom(self)
		
	pass

func GetOverLapping()-> bool:
	
	for box in overlapBoxes:
		if box.has_overlapping_areas():
			return true
	
	return false
	pass
