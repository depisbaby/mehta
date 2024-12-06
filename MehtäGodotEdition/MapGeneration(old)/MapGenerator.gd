extends Node3D

# i = z + y * ZSize + x * ZSize * YSize

var blocksPackedScenes : Array[PackedScene] = [
	
	#preload("res://MapGeneration/Blocks/Empty.tscn"),
	preload("res://MapGeneration/Blocks/One_Wall.tscn"),
	preload("res://MapGeneration/Blocks/Corner.tscn"),
	preload("res://MapGeneration/Blocks/Dead_End.tscn"),
	
	#corridor
	preload("res://MapGeneration/Blocks/Corridor_Corner.tscn"),
	preload("res://MapGeneration/Blocks/Corridor_Door.tscn"),
	preload("res://MapGeneration/Blocks/Corridor.tscn"),
	preload("res://MapGeneration/Blocks/Corridor_Dead_End.tscn"),
	preload("res://MapGeneration/Blocks/Corridor_To_Empty.tscn"),
	
	#recess
	preload("res://MapGeneration/Blocks/Recess/Recess_Bottom_Corner_Inner.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Bottom_Corner_Outer.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Bottom_Section.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Top_Section.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Top_Section_Corner_Inner.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Top_Section_Corner_Outer.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Top_Section_Edge.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Top_Wall.tscn"),
	preload("res://MapGeneration/Blocks/Recess/Recess_Top_Wall_Corner.tscn"),
	
]

@export var mapSize: int
@export var blockSize: float
@export var spawnPlayerToStart:bool

var blockLibrary : Array[Block]
var map : Array[MapCell] #2D array
var openCells : Array[MapCell]

var rng = RandomNumberGenerator.new()

#debug
var stepInput: bool
@onready var debugFlag = preload("res://MapGeneration/mapGenDebug.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	InstantiateBlockLibrary()
	
	GenerateMap(mapSize)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_0):
		stepInput = true
	pass
	
func InstantiateBlockLibrary():
	var i:int
	for block in blocksPackedScenes:
		var instance:Block = block.instantiate()
		get_tree().root.add_child(instance)
		instance.id = i
		blockLibrary.push_back(instance)
		instance.visible = false
		i = i +1
		
	pass
	
func GenerateMap(
	_mapSize: int
):
	
	mapSize = _mapSize
	map.resize(mapSize*mapSize*mapSize)
	
	##test()
	#return
	
	var startingBlock = blockLibrary[0].duplicate()
	get_tree().root.add_child(startingBlock)
	PlaceBlockAt(startingBlock, mapSize/2, 0, mapSize/2, 0)
	
	if spawnPlayerToStart:
		Global.player.character.global_position = Vector3(mapSize/2 * blockSize, 0, mapSize/2 * blockSize)
	
	while openCells.size() > 0:
		
		var mapCell = FindLowestEntropy()
		
		var i = rng.randi_range(0,mapCell.fittingBlocks.size()-1) #replace
		
		if mapCell.fittingBlocks.size() == 0:
			PrintRequiredBlock(mapCell)
		
		var blockId = mapCell.fittingBlocks[i] # replace
		var block : Block = blockLibrary[blockId].duplicate()
		get_tree().root.add_child(block)
		PlaceBlockAt(block, mapCell.xPos, mapCell.yPos, mapCell.zPos, mapCell.fittingRotation[i])
		
		
	pass

func PlaceBlockAt(block : Block, x: int, y: int, z :int, rotation:int):
	
	var position : int = x + z * mapSize + y * mapSize * mapSize
	
	if map[position] == null:
		PlaceMapCellAt(x,y,z)
		
	
	map[position].block = block
	block.global_position = Vector3(x * blockSize, y * blockSize, z * blockSize) #!
	block.visible = true
	block._rotation = rotation
	
	RotateBlock(block, rotation)
	
	if block.sidesOpen[0]:
		OpenCellAt(x,y,z+1)
	if block.sidesOpen[1]:
		OpenCellAt(x-1,y,z)
	if block.sidesOpen[2]:
		OpenCellAt(x,y,z-1)
	if block.sidesOpen[3]:
		OpenCellAt(x+1,y,z)
		
	if block.topOpen:
		OpenCellAt(x,y+1,z)
	if block.bottomOpen:
		OpenCellAt(x,y-1,z)
	
	UpdateEntropy(x,y,z+1)
	UpdateEntropy(x-1,y,z)
	UpdateEntropy(x,y,z-1)
	UpdateEntropy(x+1,y,z)
	
	UpdateEntropy(x,y+1,z)
	UpdateEntropy(x,y-1,z)
	
	print("placed ", block.id, ", with rotation ", rotation)
	
	pass	

func GetMapCellAt(x: int, y: int, z :int) -> MapCell:
	
	var position : int = x + z * mapSize + y * mapSize * mapSize
	
	if x >= mapSize || x < 0:
		return null
	if y >= mapSize || y < 0:
		return null
	if z >= mapSize || z < 0:
		return null
	
	return map[position]
	
func PlaceMapCellAt(x: int, y: int, z :int) -> MapCell:
	
	var position : int = x + z * mapSize + y * mapSize * mapSize
	
	var mapCell :MapCell = MapCell.new()
	
	mapCell.xPos = x
	mapCell.yPos = y
	mapCell.zPos = z
	
	map[position] = mapCell
	#print("placed cell at: ", x,", ",y,", ",z, ", ",position)
	
	return mapCell
	
func OpenCellAt(x: int, y: int, z :int):
	
	if x >= mapSize || x < 0:
		return
	
	if y >= mapSize || y < 0:
		return
		
	if z >= mapSize || z < 0:
		return
	
	var position : int = x + z * mapSize + y * mapSize * mapSize
	
	if map[position] == null:
		var mapCell = PlaceMapCellAt(x,y,z)
		openCells.push_back(mapCell)
		#var debug = debugFlag.instantiate()
		#debug.global_position = Vector3(x*blockSize, y*blockSize, z*blockSize)
		#get_tree().root.add_child(debug)
		
	pass

func UpdateEntropy(x: int, y: int, z :int):
	
	var position : int = x + z * mapSize + y * mapSize * mapSize
	
	if x >= mapSize || x < 0:
		return
	if y >= mapSize || y < 0:
		return
	if z >= mapSize || z < 0:
		return
	
	if map[position] == null:
		return
	
	if map[position].block != null:
		return
	
	var mapCell = map[position]
	mapCell.entropy = 0
	mapCell.fittingBlocks.clear()
	mapCell.fittingRotation.clear()
	
	for block in blockLibrary:
		for rotation in 4:
			if TestFitting(block, rotation, mapCell):
				mapCell.entropy = mapCell.entropy + 1
				mapCell.fittingBlocks.push_back(block.id)
				mapCell.fittingRotation.push_back(rotation)
				
	if mapCell.entropy == 0:
		print("huutista")
	
	pass

func TestFitting(block:Block, rotation: int, mapCell : MapCell) -> bool:
	
	var neighbour: MapCell = GetMapCellAt(mapCell.xPos, mapCell.yPos+1, mapCell.zPos)
	if neighbour != null:
		if neighbour.block != null:
			if neighbour.block.bottom != block.top || neighbour.block._rotation != block._rotation:
				return false
				
	neighbour = GetMapCellAt(mapCell.xPos, mapCell.yPos-1, mapCell.zPos)
	if neighbour != null:
		if neighbour.block != null:
			if neighbour.block.bottom != block.top || neighbour.block._rotation != block._rotation:
				return false
				
	
	var northSide = block.sides[0]
	var eastSide = block.sides[1]
	var southSide = block.sides[2]
	var westSide = block.sides[3]
	
	if rotation != 0: #im going to cry
		match rotation:
			1:
				var x = westSide
				westSide = southSide
				southSide = eastSide
				eastSide = northSide
				northSide = x
			2:
				var x = southSide
				var y = westSide
				westSide = eastSide
				southSide = northSide
				northSide = x
				eastSide = y
				
			3: 
				var x = westSide
				westSide = northSide
				northSide = eastSide
				eastSide = southSide
				southSide = x
	
	var a : Array[int] = [northSide, eastSide, southSide, westSide]
	var b : Array[int] = [northSide, eastSide, southSide, westSide]
	
	neighbour = GetMapCellAt(mapCell.xPos, mapCell.yPos, mapCell.zPos + 1)
	if neighbour != null:
		if neighbour.block != null:
			b[0] = neighbour.block.sides[2]
	
	neighbour = GetMapCellAt(mapCell.xPos - 1, mapCell.yPos, mapCell.zPos)
	if neighbour != null:
		if neighbour.block != null:
			b[1] = neighbour.block.sides[3]
	
	neighbour = GetMapCellAt(mapCell.xPos, mapCell.yPos, mapCell.zPos - 1)
	if neighbour != null:
		if neighbour.block != null:
			b[2] = neighbour.block.sides[0]
			
	neighbour = GetMapCellAt(mapCell.xPos + 1, mapCell.yPos, mapCell.zPos)
	if neighbour != null:
		if neighbour.block != null:
			b[3] = neighbour.block.sides[1]
			
	if a == b:
		return true
	return false
	
func FindLowestEntropy() -> MapCell:
	
	var lowest: int = blockLibrary.size() * 4
	
	for mapCell in openCells: #find lowest etropy
		if mapCell.entropy < lowest:
			lowest = mapCell.entropy
			
	var pool : Array[MapCell]
	for mapCell in openCells:
		if mapCell.entropy == lowest:
			pool.push_back(mapCell)
	
	var i =rng.randi_range(0,pool.size()-1)
	var result = pool[i] #replace this
	openCells.erase(result)
	
	return result
	
	pass
	
func MapGenMessages(message: String):
	print(message)

func RotateBlock(block:Block, rotation:int):
	block.global_rotation_degrees = Vector3(0, rotation * -90.0, 0)
	
	var northSide = block.sides[0]
	var eastSide = block.sides[1]
	var southSide = block.sides[2]
	var westSide = block.sides[3]
	
	var northOpen = block.sidesOpen[0]
	var eastOpen = block.sidesOpen[1]
	var southOpen = block.sidesOpen[2]
	var westOpen = block.sidesOpen[3]
	
	if rotation != 0: #im going to cry
		match rotation:
			1:
				var x = westSide
				westSide = southSide
				southSide = eastSide
				eastSide = northSide
				northSide = x
				
				var y = westOpen
				westOpen = southOpen
				southOpen = eastOpen
				eastOpen = northOpen
				northOpen = y
			2:
				var x = southSide
				var y = westSide
				westSide = eastSide
				southSide = northSide
				northSide = x
				eastSide = y
				
				var z = southOpen
				var d = westOpen
				westOpen = eastOpen
				southOpen = northOpen
				northOpen = z
				eastOpen = d
				
			3: 
				var x = westSide
				westSide = northSide
				northSide = eastSide
				eastSide = southSide
				southSide = x
				
				var y = westOpen
				westOpen = northOpen
				northOpen = eastOpen
				eastOpen = southOpen
				southOpen = y
	
	block.sides = [northSide, eastSide, southSide, westSide]
	block.sidesOpen = [northOpen, eastOpen, southOpen, westOpen]
	

func PrintRequiredBlock(mapCell :MapCell):
	var b : Array[int]
	b.resize(4)
	
	var neighbour: MapCell = GetMapCellAt(mapCell.xPos, mapCell.yPos, mapCell.zPos + 1)
	if neighbour != null:
		if neighbour.block != null:
			b[0] = neighbour.block.sides[2]
	
	neighbour = GetMapCellAt(mapCell.xPos - 1, mapCell.yPos, mapCell.zPos)
	if neighbour != null:
		if neighbour.block != null:
			b[1] = neighbour.block.sides[3]
	
	neighbour = GetMapCellAt(mapCell.xPos, mapCell.yPos, mapCell.zPos - 1)
	if neighbour != null:
		if neighbour.block != null:
			b[2] = neighbour.block.sides[0]
			
	neighbour = GetMapCellAt(mapCell.xPos + 1, mapCell.yPos, mapCell.zPos)
	if neighbour != null:
		if neighbour.block != null:
			b[3] = neighbour.block.sides[1]
			
	print("Required block: ", b[0],", ", b[1],", ", b[2],", ", b[3])

func test():
	for z in mapSize:
		for y in mapSize:
			for x in mapSize:
				var block = blockLibrary[3].duplicate()
				get_tree().root.add_child(block)
				PlaceBlockAt(block, x,y,z, 0)
				
