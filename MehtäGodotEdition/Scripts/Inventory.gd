extends CanvasLayer

var windowOpen: bool

var grid = []
var grid_width = 5
var grid_height = 5

func _ready():
	for i in grid_width:
		grid.append([])
		for j in grid_height:
			grid[i].append(0)
	pass
			



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Inventory"):
		print("Inventory pressed")
		
		if windowOpen:
			CloseWindow()
		else:
			OpenWindow()
		
	pass

func CloseWindow():
	windowOpen = false
	hide()
	
	pass
	
func OpenWindow():
	windowOpen = true
	show()
	
	pass

func Start():
	
