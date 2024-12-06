extends Node3D

@export var cage: MeshInstance3D
@export var cageWarning: MeshInstance3D

var warningTargetSize: Vector3 = Vector3(5.0,5.0,5.0)
var deployed:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	cageWarning.scale = Vector3(0.0,5.0,0.0)
	
	await get_tree().create_timer(2).timeout
	
	deployed = true;
	
	await get_tree().create_timer(10).timeout
	
	deployed = false;
	
	await get_tree().create_timer(1).timeout
	
	queue_free()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cageWarning.scale = lerp(cageWarning.scale, warningTargetSize,delta*5)
	
	if deployed:
		cage.position = lerp(cage.position, Vector3(0.0,0.0,0.0), delta*5)
	else :
		cage.position = lerp(cage.position, Vector3(0.0,-20.0,0.0), delta*5)
	
	pass
	
