extends RayCast2D
var target_object



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if target_object != null:
		update_target_pos()
	
func setup(solid):
	target_object = solid
	

func update_target_pos ():
	target_position = to_local(target_object.get_center())
	

func check_lit():
	if get_collider() == target_object:
		return true
	else:
		return false
