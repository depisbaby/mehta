extends CanvasLayer
class_name ToolTips

@export var labels : Array[Label]
@export var moreLabel: Label

@onready var base = $base

var currentActions : Array[String]
var currentSender
var currentHoveredButton: int
var pageNumber: int


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.toolTips = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !base.visible:
		return
	
	if Input.is_action_just_released("mouse0"):
		if currentHoveredButton == -2: #more button
			NextPage()
			return
			
		if currentHoveredButton == -1:
			base.visible = false
		else:
			if currentActions.size()-1 >= currentHoveredButton + (pageNumber*3):
				currentSender.ToolTipsResult(currentActions[currentHoveredButton + (pageNumber*3)])
				#print(currentHoveredButton)
				#print(pageNumber)
			base.visible = false
				
	
func ShowToolTips(actions: Array[String], sender):
	
	if actions.size() == 0:
		return
	
	pageNumber = 0
	
	currentSender = sender
	currentActions = actions
	var mouse_pos_global = get_viewport().get_mouse_position()
	base.position = mouse_pos_global
	
	UpdateLabels()
	
	base.visible = true
	
func UpdateLabels():
	moreLabel.text = "Next"
	
	for label in labels:
		label.text = ""
	
	var i = 0
	for label in labels:
		if currentActions.size()-1 >= i + (pageNumber*3):
			label.text = currentActions[i + (pageNumber*3)]
		else:
			if pageNumber == 0:
				moreLabel.text = ""
		i = i+1

func NextPage():
	pageNumber = pageNumber + 1	
	
	if !currentActions.size()-1 >= (pageNumber*3):
		pageNumber = 0
	
	UpdateLabels()

func _on_sprite_mouse_entered(extra_arg_0):
	if extra_arg_0 == 3:
		currentHoveredButton = -2
		return
	currentHoveredButton = extra_arg_0	
	pass # Replace with function body.

func _on_sprite_mouse_exited(extra_arg_0):
	currentHoveredButton = -1
	pass # Replace with function body.
