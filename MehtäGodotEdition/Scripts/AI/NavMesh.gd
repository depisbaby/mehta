extends NavigationRegion3D
class_name NavMesh

var navMeshBaked: bool

func _enter_tree():
	Global.navMesh = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func BakeNavMesh():
	print("baking...")
	bake_navigation_mesh(false)
	
	pass


func _on_bake_finished():
	navMeshBaked = true

	pass # Replace with function body.
