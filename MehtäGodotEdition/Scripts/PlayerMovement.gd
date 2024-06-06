extends Node

##bumpers
@export var rightBumper: Area2D
@export var leftBumper: Area2D
@export var upBumper: Area2D
@export var downBumper: Area2D

##movement
@export var movementSpeed: float
@export var acceleration: float
@export var movementEnabled: bool

var lastFramePosition: Vector2
var movementSlope: float
var movingDirection: Vector2

var tick: int

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	
	Movement(delta)
	
	pass
	
func Movement(delta):
	var parent = get_parent() as CharacterBody2D
	var input: Vector2 
	var motion: Vector2
	
	var right = Input.get_action_raw_strength("MoveRight")
	var left = Input.get_action_raw_strength("MoveLeft")
	var down = Input.get_action_raw_strength("MoveDown")
	var up = Input.get_action_raw_strength("MoveUp")
	
	if rightBumper.has_overlapping_bodies():
		right = 0
	if leftBumper.has_overlapping_bodies():
		left = 0
	if upBumper.has_overlapping_bodies():
		up = 0
	if downBumper.has_overlapping_bodies():
		down = 0
	
	input.x = right - left
	input.y = down - up
	
	if input == Vector2.ZERO:
		motion = movingDirection
	else:
		motion = input.normalized()
		
	
	movementSlope = clamp(movementSlope + (acceleration * ((clamp(abs(input.x) + abs(input.y),0.0,1.0)*2)-1)), 0.0, 1.0)
	
	parent.velocity = motion * delta * movementSpeed * movementSlope * 100
	parent.move_and_collide(parent.velocity)
			
	
	if tick > 0:
		tick = 0
		movingDirection = (parent.global_position - lastFramePosition).normalized()
		lastFramePosition = parent.global_position
	else:
		tick = tick + 1
	
	pass




func _on_player_slot_focus_entered():
	pass # Replace with function body.
