extends RayCast2D
var target_object



# Called when the node enters the scene tree for the first time.
#allows collision with areas
func _ready():
	collide_with_areas = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	if target_object != null:
		update_target_pos()
	
func setup(area):
	target_object = area
	

func update_target_pos ():
	target_position = to_local(target_object.get_center())
	

func check_lit():
	var count = 0
	var actually_updated
	if get_collider() == target_object:
		return true
	elif str(get_collider()).contains("Area"):
		while actually_updated == true:
			print(count)
			actually_updated = update_exceptions()
			count = count+1
		if get_collider() == target_object:
			return true
	else:
		return false

func update_exceptions():
	if get_collider() == target_object:
		return false
	elif get_collider() != target_object:
		if str(get_collider()).contains("Area"):
			add_exception(get_collider())
			return true
