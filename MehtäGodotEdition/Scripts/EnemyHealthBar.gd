extends CanvasLayer
class_name EnemyHealthBar

@export var fill: TextureRect
@export var frame: TextureRect
@export var healthAmountLabel: Label
@export var ownerNameLabel: Label

var fullSize: float = 945
var currentShownHealth: Health

var showTick: int

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.enemyHealthBar = self
	HideHealth()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if currentShownHealth != null && showTick != 0:
		
		healthAmountLabel.text = str(currentShownHealth.health, "/", currentShownHealth.maxHealth)
		ownerNameLabel.text = currentShownHealth.ownerName
		
		var percentage: float
		percentage = currentShownHealth.health as float / currentShownHealth.maxHealth as float
		print(percentage)
		fill.size.x = clamp(fullSize * percentage, 0, fullSize)
	
	if currentShownHealth == null && showTick != 0:
		HideHealth()
	
	if showTick > 0:
		showTick = showTick - 1
		
		
	if showTick == 1:
		showTick = 0
		HideHealth()
		
	pass
	
func ShowHealth(health: Health):
	
	if(showTick > 2500):
		return
	
	showTick = 5000
	currentShownHealth = health
	
	fill.show()
	frame.show()
	healthAmountLabel.show()
	ownerNameLabel.show()
	pass

func HideHealth():
	showTick = 0
	
	fill.hide()
	frame.hide()
	healthAmountLabel.hide()
	ownerNameLabel.hide()
	pass
