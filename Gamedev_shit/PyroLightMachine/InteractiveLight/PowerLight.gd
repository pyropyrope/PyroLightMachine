class_name PowerLight
extends Node2D
@export var light_energy = 1
var ray_for_solids = preload('res://InteractiveLight/LightParts/Raycasts/ForSolids/light_for_solids.tscn')
var ray_for_areas = preload("res://InteractiveLight/LightParts/Raycasts/ForAreas/light_for_areas.tscn")
var player_generated = false
var is_bursting = false
var is_player_light = false
var active = true

## Displays visible light and sensors for objects in the light's radius 
##
## PowerLight is a multipurpose light that can sense both the presence of CollisionObjects in its 
## radius and if that object is or is not obscured by another non-Area2D CollisionObject that is
## interacting with the light system. It only inteacts with CollisionObjects that contain specific
## methods outlined in the templates for their class


## Causes the LightBus to emit a signal listend for by the LightObjectManager Class to track 
## all existing lights and sets energy of the PointLight2D
func _ready():
	LightBus.light_created.emit(self)
	$LightLight.energy = light_energy


## empty 
func _process(_delta):
	pass


## empty
func _physics_process(_delta):
	pass


## MUST be called after initalization in code or light will appear at 0,0 global
## sets position, must be provided as a Vector2 or Vector2i
## pg sets if the light was created by the player, false by default
## s sets Scale can be provided as a float, inr, Vector2 or Vector2i

func setup(p,s,pg):
	position = (p)
	match typeof(s):
		TYPE_FLOAT, TYPE_INT:
			scale = Vector2(s,s)
		TYPE_VECTOR2, TYPE_VECTOR2I:
			scale = s
		_:
			print('Error in PowerLight' + str(self))
			scale = Vector2.INF
	player_generated = pg


## call instead of queue_free() to alert LightObjectManager that the light has been removed 
func delete():
	LightBus.light_deleted.emit(self)
	queue_free()


## Call to deactive the light rather than delete it
## Manager treats light as if it were deleted
func deactivate():
	if active == true:
		$LightLight.kill()
		$BroadSensor.kill()
		LightBus.light_deleted.emit(self)
	


## Call to reactivate lights that have been deactivated
func reactivate():
	if active == false:
		$LightLight.revive()
		$BroadSensor.revive()
		LightBus.light_created.emit(self)


## returns a dictonary of objects tracked by this specific light
func get_tracked_objects():
	return ($TrackingRays.get_tracked_objects())

## returns the status of a specific object tracked by this light 
func get_object_status(obj):
	return ($TrackingRays.get_tracked_object_status(obj))

#region private methods
# this code is a mess

# checks if a Area2D entering the sensor region cares about light
# not all objects need to be checked so the list isnt cluttered with Wall1, Wall2, Wall3, etc.
func _on_broad_sensor_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if check_light_sensitive(area) == true:
		start_tracking(area, false)
		LightBus.object_entered.emit(area,self)

# checks if a PhysicsBody2D entering the sensor region cares about light
func _on_broad_sensor_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	#check if object cares about light
	if check_light_sensitive(body) == true:
		start_tracking (body, true)
		LightBus.object_entered.emit(body,self)
	
# called by object entered methods to check if light is 
func check_light_sensitive(obj):
	#returns false if the object has no light seneitive property (eg. walls, decor, teleport areas)
	if obj == null:
		return false
	elif obj.has_method(StringName('is_light_sensitive'))== false:
		return false
	# returns false if light sensitivity turned off
	elif obj.is_light_sensitive() == false:
		return false
	# returns true if light sensitivity present
	elif obj.is_light_sensitive() == true:
		return true


# creates a tracking ray of appropriate type for given object
# takes object and a booleen for if you can see through it
func start_tracking (obj, is_solid):
	#checks if object is "solid"
	var ray
	if is_solid == true:
		#creates a solids ray
		ray = ray_for_solids.instantiate()
		
	elif is_solid == false:
		ray = ray_for_areas.instantiate()
	#passes new ray the object
	ray.setup(obj)
	#adds to the tracking rays node
	$TrackingRays.add_child(ray)
	$TrackingRays.add_to_dict(obj,ray)


func _on_broad_sensor_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if (check_light_sensitive(body) == true):
		stop_tracking(body)
		LightBus.object_exited.emit(body,self)


func _on_broad_sensor_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if (check_light_sensitive(area) == true):
		stop_tracking(area)
		LightBus.object_exited.emit(area,self)

# self explanatory
func stop_tracking(obj):
	$TrackingRays.delete(obj)
#endregion


## tracks if the player is directly on top of the light to avoid visual glitches
func _on_light_center_body_entered(body):
	if body.has_method('is_player'):
		$LightLight.set_item_cull_mask(1)
		$LightLight.set_item_shadow_cull_mask(1)


## tracks if the player is directly on top of the light to avoid visual glitches
func _on_light_center_body_exited(body):
	if body.has_method('is_player'):
		$LightLight.set_item_cull_mask(3)
		$LightLight.set_item_shadow_cull_mask(3)
