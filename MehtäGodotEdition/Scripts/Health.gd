extends Node
class_name Health

@export var maxHealth: int
@export var playerHealth: bool
@export var ai: NavAgent
var ownerName: String
var health: int
var healthPercentage: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func DealDamage(damage: int):
	if health <= 0:
		return
		
	health = health - damage
	SetHealth(health)
	
	if playerHealth:
		Global.hud.DamageDealt(damage)
		Global.player.CheckHealth()
	else:
		ai.wasDamaged = true
		pass
		
	
	pass
	
func SetHealth(_health: int):
	health = _health
	healthPercentage = health as float / maxHealth as float
	
	if playerHealth:
		Global.hud.UpdateHealth()
		Global.player.CheckHealth()
	else:
		
		pass
