extends CharacterBody2D
@export var light_sensitive = true
var is_lit = false

## NOTICE USER GUIDE
## 1. Create desired type of object
## 2. Attath script with this template
## 3. Add a Sprite2D node with desired texture
## 4. While Sprite2D node is selected, use Sprite menus in 2D editor to create
##		CollisionPolygon2D sibling
## 5. Profit

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


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
