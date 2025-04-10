extends CharacterBody3D
class_name NavAgent

@export var displayName: String 
@export var speed: float
@export var accel: float
@export var stoppingDistance: float #also a melee range
@export var eyes: Node3D
@export var health: Health
@export var despawnDelay: float
@export var desiredRangedRange: float #distance where the ai will go if the player if farther than that
@export var goToMeleeRange: float #distance after which the ai tries to go into melee
@export var meleeWindUp: float 
@export var meleeCooldown: float
@export var meleeDamage: int #if this is zero or lower, it doesnt do melee attacks

@onready var visuals: AnimatedSprite3D = $AnimatedSprite3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var rng = RandomNumberGenerator.new()

var player: Player
var tick: int
var customActionTick: int
var cycleProgress:float
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
enum Action {NONE, ATTACKING, FLEEING, STUNNED}
var currentAction: Action
var distanceToPlayer: float
var wasDamaged: bool
var originSpawnPoint: EnemySpawnPoints

@onready var debug: PackedScene = preload("res://PackedScenes/Debug/debugsphere.tscn")

func WakeUp():
	health.SetHealth(health.maxHealth)
	if health.health <= 0:
		health.SetHealth(1)
	targetMovePosition = global_position
	sleeping = false
	originSpawnPoint.occupied = false
	pass
	
func Die():
	sleeping = true
	
	OverrideAnimation("death")
	
	await get_tree().create_timer(despawnDelay).timeout
	Despawn()
	
func  Despawn():
	queue_free()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if customActionTick == 0:
		customActionTick = 1
	currentAction = Action.NONE
	facingDirection = Vector3(1,0,0)
	visionRaycast = PhysicsRayQueryParameters3D.create(Vector3(0,0,0), Vector3(0,0,0),1)
	player = Global.player as Player
	health.ownerName = displayName
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	
	if(sleeping == false):
		
		CheckHealth()
		GetDistanceToPlayer()
		LogicCycle(delta)
		Move(delta) #this before animations
		CheckPlayerPerspective()#this before animations
		Animations()
		#print(currentAction)
	else:
		if tick % 60 == 0:
			CheckPlayerVisibility()
			if knowsAboutPlayer:
				WakeUp()
	
	if tick > 10000: # reset tick
		tick = 0
	
	tick += 1	
	
func LogicCycle(delta):
	
	
	cycleProgress += delta
	if cycleProgress < 0.1:
		return
	
	if tick % customActionTick == 0 && knowsAboutPlayer == true:
		DoCustomAction()
	
	if tick % 3 == 0: #happens often
		if Global.player != null:
			if knowsAboutPlayer == true && currentAction != Action.FLEEING && player.health.health > 0:
				targetMovePosition = Global.player.playerFloorPoint
	
	if tick % 10 == 0: #happens less often
		CheckPlayerVisibility()	
		
		if currentAction == Action.NONE && knowsAboutPlayer:
			
			if player.health.health <= 0:
				MoveToRandomPlace()
			
			if wasDamaged:
				wasDamaged = false
				ReactToDamage()
				
			Attack()
		
	cycleProgress = 0.0
	#print("tick: ", tick)
	pass
	
	
func Move(delta):
	
	isWalking = false
	
	if currentAction != Action.NONE && currentAction != Action.FLEEING:
		return	
	
	if((targetMovePosition - global_position).length() < stoppingDistance):
		facingDirection = targetMovePosition - global_position
		if currentAction == Action.FLEEING:
			currentAction = Action.NONE
		return
	
	isWalking = true
	
	var direction = Vector3()
	
	nav.target_desired_distance = stoppingDistance - 1.0
	nav.target_position = targetMovePosition
	
	if !nav.is_target_reachable():
		#print("not reachable")
		currentAction = Action.NONE
		return
	
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
	
	if distanceToPlayer < stoppingDistance + 1.0 && meleeDamage > 0: #melee
		DoMeleeAttack()
		pass
	else:
		if distanceToPlayer < desiredRangedRange && distanceToPlayer > goToMeleeRange && seesPlayer:
			targetMovePosition = global_position
			DoRangedAttack() 
	
	pass
	
func DoCustomAction():
	
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

func Stun(time):
	currentAction = Action.STUNNED
	await get_tree().create_timer(time).timeout
	EndAction(0)
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

func ReactToDamage():
	
	pass

func MoveToRandomPlace():
	
	currentAction = Action.FLEEING
	var randomPosition: Vector3 = Vector3(global_position.x + rng.randf_range(-20.0, 20.0), eyes.global_position.y, global_position.z + rng.randf_range(-10.0, 10.0))
	
	visionRaycast.from = eyes.global_position
	visionRaycast.to = randomPosition
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(visionRaycast)
	if intersection.is_empty():
		targetMovePosition = Vector3(randomPosition.x, global_position.y, randomPosition.z)
	else:
		targetMovePosition = Vector3(intersection.position.x, global_position.y, intersection.position.z)
	pass
	
	#var instance = debug.instantiate()
	#get_tree().root.add_child(instance)
	#instance.global_position = targetMovePosition

#signals
func _on_animated_sprite_3d_animation_finished() -> void:
	if animationsOverridden:
		animationsOverridden = false
	pass # Replace with function body.
