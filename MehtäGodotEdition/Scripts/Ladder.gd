extends Node3D

func _on_area_3d_body_entered(body):
	print("sgjsdoigjosdjg")
	if body is fps_controller:
		body.isOnLadder = true
	
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	
	if body is fps_controller:
		body.isOnLadder = false
	
	pass # Replace with function body.
