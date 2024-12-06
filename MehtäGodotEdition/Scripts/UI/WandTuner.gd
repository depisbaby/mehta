extends CanvasLayer
class_name WandTuner

@onready var base:Control = $base
@onready var inputField: TextEdit = $base/TextEdit
@export var slot: InventorySlot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.wandTuner = self
	base.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func OpenView():
	base.visible = true
	Global.uiManager.OpenView("Inventory")
	pass
	
	
func CloseView():
	base.visible = false
	pass
	
func IsOpen()-> bool:
	return base.visible

func ApplySpell(inputName:String):
	
	if slot.placedItem == null:
		return
	
	if slot.placedItem is GenericWand == false:
		return
	
	#translate language
	
	var spell = Global.magicManager.GetSpell(inputName)
	
	if spell != null && spell is SpellMods: #is a spell modifier
		slot.placedItem.projectilePool.projectilePrefab.spellMods.CombineSpellMods(spell)
		slot.placedItem.projectilePool.SavePool()
		spell.queue_free()
		print(inputName, " applied")
	
	if spell != null && spell is Projectile: #is projectile based
		slot.placedItem.projectilePool.ReinitializePool(spell, slot.placedItem.projectilePool.poolSizeOverride)
		slot.placedItem.projectilePool.projectilePrefab.spellMods.CombineSpellMods(slot.placedItem.defaultSpellMods)
		slot.placedItem.projectilePool.SavePool()
		
		print(inputName, " applied")
		
		
	
	pass

func _on_apply_button_pressed() -> void:
	#print("bruh")
	ApplySpell(inputField.text)
	pass # Replace with function body.
