extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	for b in get_overlapping_bodies():
		if b is RigidBody:
			b.apply_impulse(global_transform.origin, Vector3(0, -200, 0))
