extends StaticBody2D
@export var light_sensitive = true
var is_lit = false

## NOTICE USER GUIDE
## 1. Create desired type of object
## 2. Attath script with this template
## 3. Add a Sprite2D node with desired texture
## 4. While Sprite2D node is selected, use Sprite menus in 2D editor to create
##		CollisionPolygon2D sibling and OccluderPolygon2D sibling
## 5. Profit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func is_light_sensitive():
	return light_sensitive

func get_center():
	

	var children = get_children()
	var collision_node
	for child in children:
		if str(child).contains('Collision'):
			collision_node = child
	if collision_node != null:
		return collision_node.position
	else:
		print(str(self) + ' is missing a collision polygon!')

func set_is_lit(b):
	if b != is_lit:
		if is_lit == true:
			LightBus.object_unlit.emit(self)
		elif is_lit == false:
			LightBus.object_lit.emit(self)
	is_lit = b
