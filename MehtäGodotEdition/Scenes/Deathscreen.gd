extends CanvasLayer
class_name Deathscreen

@onready var window: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.deathscreen = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ShowDeathscreen(show: bool):
	if show:
		window.show()
	else:
		window.hide()
	pass

#signals
func _on_button_button_down() -> void:
	ShowDeathscreen(false)
	Global.player.Respawn()
	pass # Replace with function body.
