extends Node
@export var burst_scale = 3
var active_lights = []
var tracked_objects = []
var tracked_objects_status = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	LightBus.light_created.connect(on_light_created)
	LightBus.light_deleted.connect(on_light_deleted)
	LightBus.object_entered.connect(on_object_entered)
	LightBus.object_exited.connect(on_object_exited)
	LightBus.burst_triggered.connect(on_burst_triggered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_status()
	# debug zone
	if Input.is_action_just_pressed("debug"):
		print('tracked' + str(tracked_objects_status))
		
func on_light_created(obj):
	active_lights.append(obj)

func on_light_deleted(obj):
	active_lights.erase(obj)

func on_object_entered(obj,_source):
	if tracked_objects.has(obj) == false:
		tracked_objects.append(obj)
		update_status()
	else:
		pass

func on_object_exited(obj, source):
	var found = false
	for l in active_lights:
		if l != source:
			if (l.get_tracked_objects().has(obj)) == true:
				found = true
	if found == false:
		obj.set_is_lit(false)
		tracked_objects.erase(obj)

func get_tracked_objects():
	update_status()
	return tracked_objects

func get_object_status(obj):
	update_status()
	return tracked_objects_status.get(obj)

func update_status():
	var new_tracked_objects_status = {}
	
	# updates internal status of objects
	for obj in tracked_objects:
		var obj_lit
		for l in active_lights:
			if l.get_tracked_objects().has(obj):
				if l.get_object_status(obj) == true:
					obj_lit = true
		if obj_lit != true:
			obj_lit = false
		new_tracked_objects_status[obj] = obj_lit

	# updates external status of objects
	for obj in tracked_objects:
		if tracked_objects_status.get(obj) == null:
			pass
		else:
			obj.set_is_lit(new_tracked_objects_status.get(obj))
	
	tracked_objects_status = new_tracked_objects_status 

func on_burst_triggered():
	for l in active_lights:
		if l.player_generated == true && l.is_bursting == false:
			burst(l)


# light actions
func burst(light):
	#make animation
	var start_vector = light.scale
	var end_vector = start_vector * burst_scale
	var burst_tween = create_tween()
	burst_tween.stop()
	burst_tween.tween_property(light,"is_bursting", true, 0)
	burst_tween.chain().tween_property(light, 'scale', end_vector, .1)
	burst_tween.chain().tween_property(light,'scale', start_vector, 3)
	burst_tween.chain().tween_property(light,"is_bursting", false, 0)
	burst_tween.set_loops(1)
	burst_tween.set_trans(Tween.TRANS_ELASTIC)
	
	burst_tween.play()
	
