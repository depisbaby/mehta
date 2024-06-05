extends Node

@export var movementSpeed: float
@export var acceleration: float
@export var movementEnabled: bool

var lastFramePosition: Vector2
var lastFrameDirection: Vector2
@export var movementSlope: float

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent() as CharacterBody2D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	var parent = get_parent() as CharacterBody2D
	var input: Vector2 
	var motion: Vector2
	
	input.x = Input.get_action_raw_strength("MoveRight") - Input.get_action_raw_strength("MoveLeft")
	input.y = Input.get_action_raw_strength("MoveDown") - Input.get_action_raw_strength("MoveUp")
	
	movementSlope = clamp(movementSlope + (acceleration * ((clamp(abs(input.x) + abs(input.y),0.0,1.0)*2)-1)), 0.0, 1.0)
	
	if (abs(input.x) + abs(input.y)) <= 0:
		motion = parent.velocity.normalized()
	else:
		motion = input.normalized()
	
	if movementEnabled:
		
		var collision = parent.move_and_collide(motion * movementSlope * movementSpeed * 250 * delta)
		if collision:
			parent.velocity = parent.velocity.slide(collision.get_normal())
		
	pass

