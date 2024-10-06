extends CharacterBody3D
class_name NavAgent

@export var displayName: String
@export var speed: float
@export var accel: float
@export var stoppingDistance: float
@export var eyes: Node3D
@export var health: Health
@export var despawnDelay: float
@export var rangedRange: float
@export var meleeWindUp: float
@export var meleeCooldown: float
@export var meleeDamage: int

@onready var visuals: AnimatedSprite3D = $AnimatedSprite3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player: Player
var tick: int
var sleeping: bool
var knowsAboutPlayer: bool
var seesPlayer: bool
var targetMovePosition: Vector3
var visionRaycast: PhysicsRayQueryParameters3D
var facingDirection: Vector3
var isWalking: bool
var animationsOverridden: bool
enum PlayerPerspective {FRONT,RIGHT,BACK,LEFT}
var playerPerspective: PlayerPerspective
enum Action {NONE, ATTACKING}
var currentAction: Action
var distanceToPlayer: float

func WakeUp():
	health.health = health.maxHealth
	if health.health <= 0:
		health.health = 1
	targetMovePosition = global_position
	sleeping = false
	pass
	
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
	currentAction = Action.NONE
	facingDirection = Vector3(1,0,0)
	visionRaycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),1)
	player = Global.player as Player
	health.ownerName = displayName
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if(sleeping == false):
		
		CheckHealth()
		GetDistanceToPlayer()
		EnemyBehaviour()
		Move(delta) #this before animations
		CheckPlayerPerspective()#this before animations
		Animations()
		#print(currentAction)
		
	pass
	
func EnemyBehaviour():
	
	tick = tick + 1
	
	if(tick % 10 == 0): #happens often
		if Global.player != null:
			if knowsAboutPlayer == true:
				targetMovePosition = Global.player.global_position
	
	if(tick % 100 == 0): #happens less often
		CheckPlayerVisibility()
		
		if currentAction == Action.NONE && knowsAboutPlayer:
			DoAction()
			Attack()
			
	if(tick > 1000000): # reset tick
		tick = 0
	
	pass
	
func Move(delta):
	
	isWalking = false
	
	if currentAction == Action.ATTACKING:
		return	
	
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
	seesPlayer = false
	
	visionRaycast.from = eyes.global_position
	visionRaycast.to = Global.player.global_position
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(visionRaycast)
	if intersection.is_empty():
		seesPlayer = true
		knowsAboutPlayer = true

func GetDistanceToPlayer():
	distanceToPlayer = (player.global_position - global_position).length()
	#print(distanceToPlayer)
	return distanceToPlayer
	
func GetVectorToPlayer():
	return (player.camera.global_position - eyes.global_position).normalized()

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
	
func OverrideAnimation(name):
	animationsOverridden = true
	visuals.play(name)
	
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
	
func Attack():
	
	if currentAction != Action.NONE:
		return
	
	if distanceToPlayer < stoppingDistance + 1.0: #melee
		DoMeleeAttack()
		pass
	else:
		if distanceToPlayer > rangedRange && seesPlayer:
			targetMovePosition = global_position
			DoRangedAttack() 
	
	pass
	
func DoAction():
	
	pass

func DoRangedAttack():
	
	pass
	
func DoMeleeAttack():
	currentAction = Action.ATTACKING
	
	OverrideAnimation("attack")
	await get_tree().create_timer(meleeWindUp).timeout
	
	if distanceToPlayer < stoppingDistance + 1.0: #melee
		player.health.DealDamage(meleeDamage)
		pass
	
	EndAction(meleeCooldown)
	pass
	
func EndAction(timeInSeconds):
	
	await get_tree().create_timer(timeInSeconds).timeout
	currentAction = Action.NONE
	pass

func TracePlayer(projectileSpeed: float) -> Vector3:
	var aimDirection: Vector3
	print(Global.player.character._velocity)
	#copy paste
	var relativePos = Global.player.camera.global_position - eyes.global_position
	
	var a: float = Global.player.character._velocity.length_squared() - projectileSpeed * projectileSpeed
	var b: float = 2 * Global.player.character._velocity.dot(relativePos)
	var c: float = relativePos.length_squared()
	
	var discriminant: float  = b * b - 4 * a * c
	if discriminant < 0: #invalid
		print("1")
		return Vector3(0,0,0)
		
	var sqrtDiscriminant: float = sqrt(discriminant)
	var t1: float = (-b + sqrtDiscriminant) / (2*a)
	var t2: float = (-b - sqrtDiscriminant) / (2*a)
	
	var t: float = min(t1,t2)
	if t < 0: #invalid
		t = max(t1,t2)
		if t < 0:
			print("2")
			return Vector3(0,0,0)
			
	var futurePlayerPos: Vector3 = Global.player.camera.global_position + Global.player.character._velocity * t
	aimDirection = (futurePlayerPos - eyes.global_position).normalized()
	#copy paste
	
	return aimDirection
	pass

#signals
func _on_animated_sprite_3d_animation_finished() -> void:
	if animationsOverridden:
		animationsOverridden = false
	pass # Replace with function body.
