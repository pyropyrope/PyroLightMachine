
#NOTICE must be used with a TileMap named Map
extends Node2D
var tile_size = 32
var start_pos = Vector2(50,50)
var puzzle_sol = {}
var puzzle_state = {}
var ground_type = 'gravel'

# Called when the node enters the scene tree for the first time.
func _ready():
	#start_dialogue()
	LightBus.object_lit.connect(on_object_lit)
	LightBus.object_unlit.connect(on_object_unlit)
	puzzle_sol = {
		# list of objects and states needed to solve the puzzle
		#$Object1 : true,
		#$Object2 : false,
		}
	# sets up a dict of the objects needed to solve the puzzle and their current states
	for object in puzzle_sol:
		puzzle_state[object] = object.is_lit
	print(puzzle_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# checks the solution every 10 frames
	if Engine.get_process_frames() % 10 == 0:
		check_solution()

func start_dialogue():
	# NOTICE dialogue here
	pass

func get_width():
	#get a rectangle of the tiles used for the map
	var map_rect = $Map.get_used_rect()
	#pull the size info
	var map_size = map_rect.size
	#calculate the maps's pixel size by the amount of tiles wide by size of tiles
	var map_width = map_size.x * tile_size
	
	return map_width
	
#returns the height of the map in pixel
func get_height():
	#get a rectangle of the tiles used for the map
	var map_rect = $Map.get_used_rect()
	#pull the size info
	var map_size = map_rect.size
	#calculate the maps's pixel size by the amount of tiles wide by size of tiles
	var map_height = map_size.y * tile_size
	return map_height

# checks the solution
func check_solution():
	if puzzle_sol == puzzle_state:
		print('solved')

# update the state of the puzzle on object state change

func on_object_lit(object):
	puzzle_state[object] = true


func on_object_unlit(object):
	puzzle_state[object] = false

# Space for other stuff the level needs to do
