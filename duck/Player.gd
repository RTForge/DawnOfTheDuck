extends HydroRigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
signal gun_target_changed
signal health_changed
signal gun_heat_changed

const gunSpeed : float = 1.2
var targetAimPosition := Vector3(0, 0, 0)
var isShooting := false

const forward := Vector3(0, 0, 1)
const up := Vector3(0, 1, 0)
onready var prop : WatercraftPropulsion = $"WatercraftPropulsion"
onready var rudder : WatercraftRudder = $"WatercraftRudder"
onready var turret : Spatial = $"Hull/TurretBase"
onready var gun : Spatial = $"Hull/TurretBase/Gun"
onready var barrel : Spatial = $"Hull/TurretBase/Gun/Barrel"
onready var raycast : RayCast = $"Hull/TurretBase/Gun/RayCast"
onready var muzzleFlash : Particles = $"Hull/TurretBase/Gun/MuzzleFlash"
onready var engineAudio : AudioStreamPlayer = $"EngineAudio"
onready var engineSplash : Particles = $"EngineSplash"

var gunAudio = []

const shootInterval := 0.167
const gunHeatRate := 0.086
const gunCoolRate := 0.25
var shootTimeout := 0.0
var gunHeat := 0.0


export var health := 10

func quat_swing(var rotation : Quat, var direction : Vector3):
	var p : Vector3 = Vector3(rotation.x, rotation.y, rotation.z).project(direction)
	return Quat(p.x, p.y, p.z, rotation.w).normalized()

func quat_angle_to(var a : Quat, var b : Quat):
	var diff := b * a.inverse()
	var angle = acos(diff.w) * 2
	if angle > PI:
		return abs(angle - TAU)
	return angle
	
func rotate_gun(delta):
	var maxRotation = gunSpeed * delta
	
	var boatUp = get_global_transform().basis.y.normalized()
	var gunTransform = gun.get_global_transform()
	var gunCurrentAngle = Quat(gunTransform.basis)
	var gunTargetAngle = gunTransform.looking_at(targetAimPosition, boatUp).basis
	var totalAngle = quat_angle_to(gunCurrentAngle, gunTargetAngle)
	if (totalAngle > 0):
		var turnPortion = min(maxRotation / totalAngle, 1.0)
		var gunNewAngle = gunCurrentAngle.slerp(gunTargetAngle, turnPortion)
		var swing = quat_swing(gunNewAngle, boatUp)
		turret.set_global_transform(Transform(swing, gunTransform.origin))
		gun.set_global_transform(Transform(gunNewAngle, gunTransform.origin))
	
	var crosshairPos : Vector3
	if raycast.is_colliding():
		crosshairPos = raycast.get_collision_point()
	else:
		crosshairPos = raycast.to_global(raycast.cast_to)
	emit_signal("gun_target_changed", crosshairPos)

func _on_OrbitTargetCam_look_position_changed(pos):
	targetAimPosition = pos
	
func throttle(var amount : float):
	engineAudio.pitch_scale = lerp(0.9, 2.5, abs(amount))
	engineSplash.amount = 30 + floor(70 * abs(amount))
	engineSplash.process_material.initial_velocity = 1.0 + 5 * amount
	prop.value = 180000 * amount
	

func steer(var amount : float):
	prop.direction = forward.rotated(up, 0.45 * amount)
	rudder.direction = -forward.rotated(up, 0.45 * amount)
	

func shoot(var enable : bool):
	isShooting = enable
	
func _ready():
	gunAudio.append($"GunAudio1")
	gunAudio.append($"GunAudio2")
	gunAudio.append($"GunAudio3")
	gunAudio.append($"GunAudio4")
	engineAudio.play()

func _process(delta):
	rotate_gun(delta)
	process_shoot(delta)
	#engineSplash.global_transform.basis.z = Vector3.UP

func _physics_process(delta):
	get_tree().call_group("ducks", "update_target_position", get_global_transform().origin)
	
func process_shoot(delta):
	shootTimeout += delta
	
	if !isShooting or shootTimeout < shootInterval or gunHeat >= 1.0:
		gunHeat -= gunCoolRate * delta
		if gunHeat < 0:
			gunHeat = 0
		emit_signal("gun_heat_changed", gunHeat)
		return
	
	print("bang!")
	#muzzleFlash.restart()
	muzzleFlash.emitting = true

	gunHeat += gunHeatRate
	emit_signal("gun_heat_changed", gunHeat)
	shootTimeout = 0
	var gunTransform := gun.get_global_transform()
	var gunLookDir := (targetAimPosition - gunTransform.origin).normalized()
	
	var hit := raycast.get_collider()
	if hit:
		print(hit)
		hit.process_hit(raycast.get_collision_point(), raycast.get_collision_normal())
	
	var gunPlayer : AudioStreamPlayer = gunAudio[randi() % 4]
	gunPlayer.pitch_scale = 1.0 + randf() * 0.1
	gunPlayer.play()

func process_hit(var position : Vector3, var normal : Vector3):
	print("hit!")
	health -= 1
	emit_signal("health_changed", health)
	if health <= 0:
		print("game over")
