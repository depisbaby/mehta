extends Node
class_name Health

@export var maxHealth: int
@export var playerHealth: bool
var ownerName: String
var health: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func DealDamage(damage: int):
	health = health - damage
	
	if playerHealth:
		Global.hud.DamageDealt(damage)
	
	pass
	
