extends Node2D
var rays = {}
var seen_objects = []
var seen_objects_status = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	pass

# deletes a body from tracking arrays
func delete(body):
	if check_light_sensitive(body) == true:
		rays[body].queue_free()
		rays.erase(body)
		update_object_status()
	else:
		pass

func add_to_dict(obj,ray):
	rays[obj] = ray
	update_object_status()


# updates the status of objects tracked
func update_object_status():
	seen_objects.clear()
	seen_objects_status.clear()
	for i in rays:
		var status
		seen_objects.append(i)
		status = rays[i].check_lit()
		seen_objects_status[i] = status


# redundant light sensitivity checkers to allow for null returns vs errors
func check_light_sensitive(obj):
	#returns false if the object has no light seneitive property (eg. walls, decor)
	if obj == null:
		return false
	elif obj.has_method(StringName('is_light_sensitive'))== false:
		return false
	#returns false if light sensitivity turned off
	elif obj.is_light_sensitive() == false:
		return false
	#returns true if light sensitivity present
	elif obj.is_light_sensitive() == true:
		return true


func get_tracked_objects():
	update_object_status()
	return seen_objects


func get_tracked_object_status(obj):
	update_object_status()
	if check_light_sensitive(obj) == true:
		return seen_objects_status[obj]
	else: return null


func kill():
	for r in get_children():
		r.queue_free()
	seen_objects.clear()
	seen_objects_status.clear()
	update_object_status()
