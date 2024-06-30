extends Node3D
class_name Player

@export var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.player = self
	PlayerInputs(delta)
	pass

func PlayerInputs(delta):
	
	if(Global.inventory != null):
		
		if Global.inventory.equippedItem == null:
			return
		
		if(Input.is_action_just_pressed("mouse0")):
			Global.inventory.equippedItem.UsePrimaryPressed()
			pass
		if(Input.is_action_just_pressed("mouse1")):
			Global.inventory.equippedItem.UseSecondaryPressed()
			pass
		if(Input.is_action_just_released("mouse0")):
			Global.inventory.equippedItem.UsePrimaryReleased()
			pass
		if(Input.is_action_just_released("mouse1")):
			Global.inventory.equippedItem.UseSecondaryReleased()
			pass
		
		pass
	
	pass
