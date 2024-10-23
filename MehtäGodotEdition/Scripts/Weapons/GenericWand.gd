extends Item
class_name GenericWand

#default spellmods
@export var defaultSpellMods: Node

@onready var projectilePool: ProjectilePool = $ProjectilePool

var cooldownTick: float
var primaryHeld: bool

func _ready():
	super._ready()
	
	
	
	pass # Replace with function body.

func _process(delta):
	super._process(delta)
	cooldownTick = clamp(cooldownTick - delta,0.0, 100.0)
	
	
func UsePrimaryPressed():
	
	if cooldownTick != 0:
		return
	
	cooldownTick = defaultSpellMods.coolDown
	
	var projectile = projectilePool.GetProjectile()
	if(projectile != null):
		projectile.Shoot(Global.player.hand.global_position, (Global.player.aimPoint - Global.player.hand.global_position).normalized())
		
		
	pass
	
func UseSecondaryPressed():
	
	pass
	
func UsePrimaryReleased():
	pass
	
func UseSecondaryReleased():
	pass
	
func PickUp():
	super.PickUp()
	#print("speed ", defaultSpellMods.speed)
