extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
onready var water : WaterArea = $"../Water"
onready var splash : Particles = $Splash

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hit_water(var position : Vector3, var normal : Vector3):
	var surfacePosition :Vector3 = water.water_height_at(position)
	splash.global_transform.origin = surfacePosition
	splash.restart()