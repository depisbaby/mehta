extends CanvasLayer
class_name EnemyHealthBar

@export var fill: TextureRect
@export var label: Label

var fullSize: float = 1000
var currentShownHealth: Health

var showTime: float
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.enemyHealthBar = self
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	UpdateBar()
	
	if currentShownHealth == null:
		return
	
	showTime -= delta
	
	if currentShownHealth.health < 0 || showTime < 0.0:
		currentShownHealth = null
		
	pass
	
	
func UpdateBar():
	
	if currentShownHealth == null:
		visible = false
		return
	
	visible = true
	
	fill.size.x = clamp(fullSize * currentShownHealth.healthPercentage, 0, fullSize)
	label.text = str(currentShownHealth.ownerName, " | ",currentShownHealth.health, "/", currentShownHealth.maxHealth)
	pass
	
func ShowHealth(health: Health):
	currentShownHealth = health
	showTime = 10.0
