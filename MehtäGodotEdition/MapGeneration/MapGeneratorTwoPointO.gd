extends Node
class_name MapGenerator

var tyrmaStartingRoom:PackedScene = preload("res://MapGeneration/Rooms/Starting_room.tscn")
var tyrmaRoomSet: Array[PackedScene] = [
	preload("res://MapGeneration/Rooms/Generic_room1.tscn"),
	preload("res://MapGeneration/Rooms/Generic_room2.tscn"),
	preload("res://MapGeneration/Rooms/Generic_room3.tscn"),
	preload("res://MapGeneration/Rooms/Generic_room4.tscn"),
	preload("res://MapGeneration/Rooms/Generic_room5.tscn"),
	preload("res://MapGeneration/Rooms/Generic_room6.tscn"),
]

var roomLibrary: Array[Room]
var seed: int
var rng = RandomNumberGenerator.new()
var openDoors: Array[Door]
var numOfRoomsGenerated: int

func _enter_tree():
	Global.mapGenerator = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func GenerateMap(mapName: String, _seed: String):
	
	seed = hash(_seed)
	rng.seed = seed
	rng.state = 0
	
	#wait
	await get_tree().create_timer(0.1).timeout
	
	#select map to generate
	match mapName:
		"tyrma":
			await GenerateTyrma()
		_:
			return
	
	print("map generation done")
	
	
func AddOpenDoor(door: Door):
	
	print("adding open door...")
	
	if rng.randi_range(0,1) == 0:
		openDoors.push_back(door)
	else :
		openDoors.push_front(door)
	
	print("amount of open doors: ", openDoors.size())	
	pass

func GenerateRoomAt(door: Door):
	print("generating room at, ", door.global_position)
	var numberOfTries: int = 0
	while true:
		
		if numberOfTries > 3:
			print("too many tries...")
			openDoors.erase(door)
			print("amount of open doors: ", openDoors.size())
			break

		
		var room: Room = roomLibrary[rng.randi_range(0,roomLibrary.size()-1)] #get room
		var doorI: int = rng.randi_range(0,room.doors.size()-1)
		var _door: Door = room.doors[doorI] #get door in that room
		
		var angleToRotate: float = door.get_global_transform().basis.x.angle_to(-_door.get_global_transform().basis.x)
		room.rotate(Vector3(0,1,0), angleToRotate)
		room.global_position = door.global_position + (room.global_position - _door.global_position)
		
		await get_tree().create_timer(0.1).timeout
		if !room.GetOverLapping():
			print("fitted at ", door.global_position)
			PlaceRoom(room, doorI)
			openDoors.erase(door)
			door.RemoveSeal()
			room.global_position = Vector3(-10000, -10000, -10000)
			numOfRoomsGenerated = numOfRoomsGenerated +1
			print("amount of open doors: ", openDoors.size())
			break
		else:
			
			angleToRotate = door.get_global_transform().basis.x.angle_to(_door.get_global_transform().basis.x)
			room.rotate(Vector3(0,1,0), angleToRotate)
			room.global_position = door.global_position + (room.global_position - _door.global_position)
			
			await get_tree().create_timer(0.01).timeout
			if !room.GetOverLapping():
				print("fitted at ", door.global_position)
				PlaceRoom(room, doorI)
				openDoors.erase(door)
				door.RemoveSeal()
				room.global_position = Vector3(-10000, -10000, -10000)
				numOfRoomsGenerated = numOfRoomsGenerated +1
				print("amount of open doors: ", openDoors.size())
				break
		
		print("didnt fit trying another configuration...")
		
		numberOfTries = numberOfTries + 1
		room.global_position = Vector3(-10000, -10000, -10000)
	
			
	
	pass

func PlaceRoom(room: Room, door: int):
	var _room: Room = room.duplicate(8)
	Global.navMesh.add_child(_room)
	_room.visible = true
	_room.global_position = room.global_position
	_room.global_rotation = room.global_rotation
	_room.doors[door].filled = true
	_room.Place(self)
	

#generation methods
func GenerateTyrma():
	
	# initialize rooms
	InitalizeTyrmaRooms()
	
	#place first
	var startingRoom:Room = tyrmaStartingRoom.instantiate()
	get_tree().root.add_child(startingRoom)
	Global.navMesh.add_child(startingRoom)
	startingRoom.visible = true
	startingRoom.global_position = Vector3(0,0,0)
	startingRoom.Place(self)
	
	#generate
	while openDoors.size() > 0 && numOfRoomsGenerated < 10:
		
		var door: Door #pick door to close next
		if rng.randi_range(0,1) == 0:
			door = openDoors.pop_back()
		else :
			door = openDoors.pop_front()
		
		await GenerateRoomAt(door)
	
	#enemypool
	Global.enemyManager.InitializeTyrmaPool()
	
	#bake navmesh
	await Global.navMesh.BakeNavMesh()
	var _seconds: int
	while !Global.navMesh.navMeshBaked:
		await get_tree().create_timer(1.0).timeout
		_seconds = _seconds + 1
	print("baking done after ", _seconds, " seconds")
	
	
	pass

#init methods
func InitalizeTyrmaRooms():
	var i:int
	for room in tyrmaRoomSet:
		var instance:Room = room.instantiate()
		get_tree().root.add_child(instance)
		instance.id = i
		roomLibrary.push_back(instance)
		instance.visible = false
		instance.global_position = Vector3(-10000,-10000,-10000)
		i = i +1
