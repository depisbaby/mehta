extends CharacterBody3D
class_name NavAgent

@export var speed: float
@export var accel: float
@export var stoppingDistance: float
@export var eyes: Node3D
@export var health: Health

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player: Player

var tick: int
var sleeping: bool
var knowsAboutPlayer: bool
var targetMovePosition: Vector3

var visionRaycast: PhysicsRayQueryParameters3D

func WakeUp():
	health.health = health.maxHealth
	if health.health <= 0:
		health.health = 1
	targetMovePosition = global_position
	sleeping = false

func Die():
	sleeping = true
	await get_tree().create_timer(5).timeout
	Despawn()
	
func  Despawn():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	visionRaycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),1)
	player = Global.player as Player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(sleeping == false):
		
		CheckHealth()
		MonsterBehaviour()
		Move(delta)
		
	pass
	
func MonsterBehaviour():
	
	tick = tick + 1
	
	if(tick % 10 == 0):
		if Global.player != null:
			if knowsAboutPlayer == true:
				targetMovePosition = Global.player.global_position
		#print("hep")
	
	if(tick % 100 == 0):
		CheckPlayerVisibility()
	
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

func CheckPlayerVisibility():
	
	if knowsAboutPlayer:
		return
	
	visionRaycast.from = eyes.global_position
	visionRaycast.to = Global.player.global_position
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(visionRaycast)
	if intersection.is_empty():
		knowsAboutPlayer = true

func CheckHealth():
	if health.health <= 0:
		Die()
