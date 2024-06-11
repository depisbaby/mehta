extends Node

@export var rayCast: RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(rayCast.is_colliding() && Input.is_action_just_pressed("interact")):
		
		var hit = rayCast.get_collider() as Node
		if hit.get_parent().is_in_group("Item"):
			var item = hit.get_parent() as Item
			item.PickUp()
		
		
		pass
	
	pass
