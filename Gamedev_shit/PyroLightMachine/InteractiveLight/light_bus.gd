extends Node

signal light_created(obj)
signal light_deleted(obj)
signal object_entered(obj,source)
signal object_exited(obj,source)
signal burst_triggered()
signal object_lit(obj)
signal object_unlit(obj)
signal count_reset()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
