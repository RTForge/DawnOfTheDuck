extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var active := false

const speed = 8.0
var trajectory : Vector3

onready var shape : CollisionShape = $CollisionShape
onready var particles : Particles = $Trail
onready var sound : AudioStreamPlayer3D = $Crackle

# Called when the node enters the scene tree for the first time.
func _ready():
	disable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		translate(trajectory * speed * delta)
		if global_transform.origin.length_squared() > 25000:
			disable()

func initialize(var start : Vector3, var end : Vector3):
	global_transform = Transform(Basis(Quat.IDENTITY), start)
	trajectory = (end - start).normalized()
	active = true
	shape.disabled = false
	sound.playing = true
	particles.emitting = true

	#call_deferred("show")
	
func disable():
	#global_transform.origin = Vector3(0, -100, 0)
	shape.disabled = true
	sound.playing = false
	particles.emitting = false
	active = false
	#hide()


func _on_Fireball_body_entered(body):
	print("Fireball hit body ", body)
	body.process_hit(Vector3.ZERO, Vector3.ZERO)
	disable()

func process_hit(var position : Vector3, var normal : Vector3):
	pass

func _on_Fireball_area_entered(area):
	print("Fireball hit area ", area)
	area.process_hit(global_transform.origin, Vector3.UP)
	disable()
