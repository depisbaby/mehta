extends Node3D

@export var player: Player
@export var interactRayCast: RayCast3D
@export var lookingAtRaycast: RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if interactRayCast.is_colliding() && Input.is_action_just_pressed("interact"):
		
		var hit = interactRayCast.get_collider() as Node
		if hit.get_parent().is_in_group("Item"):
			var item = hit.get_parent() as Item
			Global.inventory.PickUpItem(item, true)
		if hit.get_parent().is_in_group("Door"):
			var door = hit.get_parent() as Door
			door.Operate()
		if hit.get_parent().is_in_group("WandTuner"):
			Global.wandTuner.OpenView()
		
		pass
		
	if lookingAtRaycast.is_colliding():
		var hit = lookingAtRaycast.get_collider() as Node3D
		if hit == null:
			pass
		else	:
			if hit.is_in_group("Hitbox") && Global.enemyHealthBar != null:
				Global.enemyHealthBar.ShowHealth(hit)
			
		player.aimPoint = lookingAtRaycast.get_collision_point()
	else:	
		player.aimPoint = global_position + transform.basis.z.normalized() * 100	
		
			
		
		pass
	
	pass
