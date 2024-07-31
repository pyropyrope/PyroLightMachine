extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func kill():
	$SensorShape.set_deferred("disabled", true)

func revive():
	$SensorShape.set_deferred("disabled", false)
