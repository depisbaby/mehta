extends Node3D
class_name Player

@export var camera: Camera3D
@export var health: Health
@export var character: CharacterBody3D

var frozen: bool
var blindness: float
var walking: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	Respawn()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	PlayerInputs(delta)
	
	
	pass

func Respawn():
	health.maxHealth = 100
	health.SetHealth(health.maxHealth)
	frozen = false
	pass

func PlayerInputs(delta):
	
	if health.health <= 0 || frozen:
		return
	
	if(Global.inventory != null):
		
		if Global.inventory.equippedItem == null:
			return
		
		if(Input.is_action_just_pressed("mouse0")):
			Global.viewModel.UseItem()
			Global.inventory.equippedItem.UsePrimaryPressed()
			pass
		if(Input.is_action_just_pressed("mouse1")):
			Global.viewModel.UseItem()
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

	
func CheckHealth():
	
	if health.health < 1: #die
		frozen = true
		Global.deathscreen.ShowDeathscreen(true)
		
			
		pass
	
	pass
	
