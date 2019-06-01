extends Spatial

export var target : NodePath setget setTarget
export var distance : float = 15.0
export var height : float = 8.0
export var maxVelocity = 8.0

signal look_position_changed
signal crosshair_position_changed

onready var crosshair : Spatial = $Crosshair
onready var camera : Camera = $Camera
var targetNode : Spatial
var targetRotation = Vector2(PI, 0)
var centerCamera = Vector2(0, 0)


var up := Vector3(0, 1, 0)
var maxVerticalAngle = 0.4
var minVerticalAngle = -0.4

func setTarget(val):
	if val:
		target = val
		targetNode = get_node(target)

func applyRotation(var deltaRotation : Vector2):
	targetRotation -= deltaRotation
	if targetRotation.x < 0:
		targetRotation.x += TAU
	elif targetRotation.x > TAU:
		targetRotation.x -= TAU

	targetRotation.y = clamp(targetRotation.y, minVerticalAngle, maxVerticalAngle);

func _ready():
	targetNode = get_node(target)
	camera.translation = Vector3(0, height, distance)
	findCenter()
	get_tree().get_root().connect("size_changed", self, "findCenter")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var maxDistance = maxVelocity * delta
	var dir := targetNode.global_transform.origin - global_transform.origin
	if dir.length() > maxDistance :
		dir = dir.normalized() * maxDistance

	global_transform.origin += dir
	camera.rotation.x = targetRotation.y
	rotation.y = targetRotation.x
	#camera.look_at(targetNode.translation, up)
	
func _physics_process(_delta):
	var from = camera.project_ray_origin(centerCamera)
	var to = from + camera.project_ray_normal(centerCamera) * 50
	crosshair.set_global_transform(Transform(crosshair.get_global_transform().basis, to))
	emit_signal("look_position_changed", to)

func findCenter():
	centerCamera = get_viewport().size / 2
	print(centerCamera)

func _on_Player_gun_target_changed(var target : Vector3):
	emit_signal("crosshair_position_changed", camera.unproject_position(target))
