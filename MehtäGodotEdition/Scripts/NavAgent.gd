extends CharacterBody3D
class_name NavAgent

@export var displayName: String
@export var speed: float
@export var accel: float
@export var stoppingDistance: float
@export var eyes: Node3D
@export var health: Health
@export var despawnDelay: float

@onready var visuals: AnimatedSprite3D = $AnimatedSprite3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player: Player
var tick: int
var sleeping: bool
var knowsAboutPlayer: bool
var targetMovePosition: Vector3
var visionRaycast: PhysicsRayQueryParameters3D
var facingDirection: Vector3
var isWalking: bool
var animationsOverridden: bool
enum PlayerPerspective {FRONT,RIGHT,BACK,LEFT}
var playerPerspective: PlayerPerspective

func WakeUp():
	health.health = health.maxHealth
	if health.health <= 0:
		health.health = 1
	targetMovePosition = global_position
	sleeping = false
	
	

func Die():
	sleeping = true
	
	#death animation here
	
	await get_tree().create_timer(despawnDelay).timeout
	Despawn()
	
func  Despawn():
	queue_free()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	facingDirection = Vector3(1,0,0)
	visionRaycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),1)
	player = Global.player as Player
	health.ownerName = displayName
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if(sleeping == false):
		
		CheckHealth()
		MonsterBehaviour()
		Move(delta) #this before animations
		CheckPlayerPerspective()#this before animations
		Animations()
		
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
	
	isWalking = false
	
	if((targetMovePosition - global_position).length() < stoppingDistance):
		facingDirection = targetMovePosition - global_position
		return
	
	isWalking = true
	
	var direction = Vector3()
	nav.target_position = targetMovePosition
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	facingDirection = direction
	
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

func Animations():
	
	if animationsOverridden:
		return
	
	if isWalking: #is walking
		
		if playerPerspective == PlayerPerspective.FRONT:
			ContinueAnimation("walk_front")
			visuals.flip_h = false
			return
		if playerPerspective == PlayerPerspective.RIGHT:
			ContinueAnimation("walk_side")
			visuals.flip_h = false
			return
		if playerPerspective == PlayerPerspective.BACK:
			ContinueAnimation("walk_back")
			visuals.flip_h = false
			return
		if playerPerspective == PlayerPerspective.LEFT:
			ContinueAnimation("walk_side")
			visuals.flip_h = true
			return
	
	else: #is idle
		
		if playerPerspective == PlayerPerspective.FRONT:
			ContinueAnimation("idle_front")
			visuals.flip_h = false
			return
		if playerPerspective == PlayerPerspective.RIGHT:
			ContinueAnimation("idle_side")
			visuals.flip_h = false
			return
		if playerPerspective == PlayerPerspective.BACK:
			ContinueAnimation("idle_back")
			visuals.flip_h = false
			return
		if playerPerspective == PlayerPerspective.LEFT:
			ContinueAnimation("idle_side")
			visuals.flip_h = true
			return
		
		pass
	
	pass
	
func ContinueAnimation(name):
	
	if visuals.animation == name:
		return
	visuals.play(name)
	
	pass	
	
func CheckPlayerPerspective():
	
	var angle: float 
	var playerToThis: Vector2
	var _facingDirection :Vector2
	playerToThis = Vector2(player.global_position.x - global_position.x, player.global_position.z - global_position.z)
	_facingDirection = Vector2(facingDirection.x, facingDirection.z)
	
	angle = rad_to_deg(playerToThis.angle_to(_facingDirection))
	
	if angle > -45.0 && angle < 45.0:
		playerPerspective = PlayerPerspective.FRONT
		return	
		
	if angle > 45.0 && angle < 135.0:
		playerPerspective = PlayerPerspective.LEFT
		return	
		
	if angle < -45.0 && angle > -135.0:
		playerPerspective = PlayerPerspective.RIGHT
		return	
		
	else:
		playerPerspective = PlayerPerspective.BACK
		return	
	
	pass	
		
