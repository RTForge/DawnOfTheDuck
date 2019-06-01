extends WaterArea

export var amplitude := Vector2(0.2, 0.15) setget set_amplitude
export var frequency := Vector2(0.25, 0.35) setget set_frequency
export var time_factor := Vector2(2.0, 3.0) setget set_time_factor

var time = 0
var shader_material

const MaxSplash := 16
var currentSplash : int = 0
var splashPool = []

func set_amplitude(val):
	amplitude = val
	#update_shader()

func set_frequency(val):
	frequency = val
	#update_shader()
	
func set_time_factor(val):
	time_factor = val
	#update_shader()

func _ready():
	shader_material = $"WaterMesh".mesh.surface_get_material(0)
	shader_material.set_shader_param("amplitude", amplitude)
	shader_material.set_shader_param("frequency", frequency)
	shader_material.set_shader_param("time_factor", time_factor)
	
	var splash = load("res://Splash.tscn")
	for i in range(MaxSplash):
		var s = splash.instance()
		splashPool.append(s)
		add_child(s)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if shader_material:
		shader_material.set_shader_param("time", time)

func height(pos, time):
	return amplitude.x * sin(pos.x * frequency.x + time * time_factor.x) + amplitude.y * sin(pos.y * frequency.y + time * time_factor.y) - 0.5;

func water_height_at(var p : Vector3) -> Vector3:
	return Vector3(p.x, water_height + height(Vector2(p.x, p.z), time), p.z)
	
func _get_water_heights(positions):
	var ret : PoolVector3Array
	for p in positions:
		ret.append(water_height_at(p))
	return ret;
	
func process_hit(var position : Vector3, var normal : Vector3):
	print("splash: ", currentSplash)
	var surfacePosition : Vector3 = water_height_at(position)
	var splash = splashPool[currentSplash]
	currentSplash = (currentSplash + 1) % MaxSplash
	splash.run_at(surfacePosition)
