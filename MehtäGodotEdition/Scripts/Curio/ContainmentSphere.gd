extends Node3D

@export var playerContainmentSphere: bool
@export var ball1: Node3D
@export var ball2: Node3D
@export var collider: Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ball1 != null && ball2 != null:
		ball1.rotate_object_local(Vector3(0.0,1.0, 0.0),delta)
		ball2.rotate_object_local(Vector3(0.0,1.0, 0.0),-delta)
	
	pass
	
