extends CanvasLayer

class_name HUD

#Damage screen
@export var DamageScreen: ColorRect
@export var BlindnessScreen: ColorRect
var currentDamage: float
var currentBlindness: float

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.hud = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DamageScreen.color.a = currentDamage
	currentDamage = clamp(currentDamage - 0.2 * delta,0.0,1.0)
	BlindnessScreen.color.a = currentBlindness
	currentBlindness = clamp(currentBlindness - 0.2 * delta,0.0,1.0)
	pass
	
func DamageDealt(amount):
	
	var _amount: float = clamp(amount, 10, 100)
	currentDamage = clamp(currentDamage + (_amount * 0.02),0.0,0.9)
	pass
	
func MakeBlinder(delta):
	currentBlindness = clamp(currentBlindness + 5.0 * delta,0.0,1.0)
	pass
