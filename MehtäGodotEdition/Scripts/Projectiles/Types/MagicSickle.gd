extends Projectile

@onready var axis1: Node3D = $axis1
@onready var axis2: Node3D = $axis1/axis2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if _awake:
		axis1.rotate_object_local(Vector3(0,0,1.0),delta * -3.0)
		axis2.rotate_object_local(Vector3(1.0,0,0),delta * -20.0)
		
	pass
