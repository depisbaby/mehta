extends Projectile

@export var ball: MeshInstance3D
@export var ball2: MeshInstance3D 
@export var ball3: MeshInstance3D
@export var ball4: MeshInstance3D
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	name = "Windball"
	pass # Replace with function body.

func Shoot(startPosition: Vector3, startDirection: Vector3):
	super.Shoot(startPosition, startDirection)
	rotate(Vector3(0,1,0),rng.randf_range(-90.0, 90.0))
	
	ball.rotate(Vector3(1,0,0), rng.randf_range(-90.0, 90.0))
	ball2.rotate(Vector3(0,1,0), rng.randf_range(-90.0, 90.0))
	ball3.rotate(Vector3(0,0,1), rng.randf_range(-90.0, 90.0))
	ball4.rotate(Vector3(1,1,1), rng.randf_range(-90.0, 90.0))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	Animations(delta)
	pass
	
func Animations(delta):
	if !_awake:
		return 
	ball.rotate_object_local(Vector3(1,0,0), delta * -10)
	ball2.rotate_object_local(Vector3(1,0,0), delta * -13)
	ball3.rotate_object_local(Vector3(1,0,0), delta * -16)
	ball4.rotate_object_local(Vector3(1,0,0), delta * -19)
	pass
	
