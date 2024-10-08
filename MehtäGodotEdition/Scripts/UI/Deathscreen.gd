extends CanvasLayer
class_name Deathscreen

@onready var window: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.deathscreen = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ShowDeathscreen(show: bool):
	if show:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		window.self_modulate.a = 0.0
		window.show()
		
		while window.self_modulate.a < 1.0:
			await get_tree().create_timer(0.2).timeout
			window.self_modulate.a += 0.01
		
	else:
		window.hide()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

#signals
func _on_button_button_down() -> void:
	ShowDeathscreen(false)
	Global.player.Respawn()
	pass # Replace with function body.
