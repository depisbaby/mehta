extends CharacterBody3D
class_name NavAgent

@export var speed: float
@export var accel: float
@export var stoppingDistance: float

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player: Player

var tick: int
var sleeping: bool
var targetMovePosition: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Global.player as Player
	sleeping = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(sleeping == false):
		
		MonsterBehaviour()
		Move(delta)
		
	pass
	
func MonsterBehaviour():
	
	tick = tick + 1
	
	if(tick % 10 == 0):
		if Global.player != null:
			targetMovePosition = Global.player.global_position
		#print("hep")
		
	if(tick > 10000):
		tick = 0
	
	pass
	
func Move(delta):
	
	if((targetMovePosition - global_position).length() < stoppingDistance):
		return
	
	var direction = Vector3()
	nav.target_position = targetMovePosition
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
	
	pass
