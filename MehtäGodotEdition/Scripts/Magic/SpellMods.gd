extends Node
class_name SpellMods

@export var ignoreEnemies: bool
@export var damage: int
@export var speed: float
@export var coolDown: float
@export var bounces: int
@export var damageType: String
@export var damageTypeQuality: int
@export var lifeSpan: float
@export var penetration: int
@export var weight: float
@export var size: float
@export var homing: bool

func CombineSpellMods(otherSpellMods: SpellMods):
	damage = clamp(damage + otherSpellMods.damage, 0, 999999)
	speed = clamp(speed + otherSpellMods.speed, 0.0, 999.9)
	coolDown = clamp(coolDown + otherSpellMods.coolDown, 0.1, 999.9)
	bounces = clamp(bounces + otherSpellMods.bounces,0,99)
	
	if otherSpellMods.damageType != "":
		damageType = otherSpellMods.damageType
	
	damageTypeQuality = damageTypeQuality + otherSpellMods.damageTypeQuality
	lifeSpan = clamp(lifeSpan + otherSpellMods.lifeSpan, 0, 60.0)
	penetration = clamp(penetration + otherSpellMods.penetration, 0, 99)
	weight = clamp(weight + otherSpellMods.weight, 0.0, 99.9)
	size = clamp(size + otherSpellMods.size, 0.0, 9.9)
	
	if otherSpellMods.homing:
		homing = true
	
func ApplySpellMods(spellMods):
	#No logic here, just an implementation
	pass

#var spellMods = SpellMods.new()
	
#	spellMods.ignoreEnemies = 
#	spellMods.damage =
#	spellMods.speed =
#	spellMods.bounces =
#	spellMods.damageType =
#	spellMods.damageTypeQuality =
# 	spellMods.lifespan =
