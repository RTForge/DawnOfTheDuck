extends HydroRigidBody

signal killed

export var thinkTime := 0.5
export var targetPlayerDistance := 400.0
export var targetCloseDistance := 50.0
export var baseThrust := 20000
export var maxFireballs := 5
export var shootCooldownTime := 5.0
export var startingMass := 10000.0

onready var duckBody = $Hull/DuckBody
onready var leftFoot = $LeftFootProp
onready var rightFoot = $RightFootProp

var targetPosition := Vector2(0, 0)
var thinkCounter := 0.0

var angleToPlayer : float
var distanceToPlayer : float

onready var weaponSpawn = $WeaponSpawn
var fireballPool := []
var lastShotTime := 0.0

var bulletHoles := []
var maxBulletHoles := 10
var sinkers := []
var maxSinkers := 5
var hits := 0

var active := false

func quat_angle_to(var a : Quat, var b : Quat) -> float:
	var diff := b * a.inverse()
	var angle := acos(diff.w) * 2.0
	return angle
	
func _ready():
	match GlobalSettings.difficulty:
		0:
			maxFireballs = 2
			shootCooldownTime = 6
		1:
			maxFireballs = 3
			shootCooldownTime = 4.5
		2:
			maxFireballs = 4
			shootCooldownTime = 3
	
	add_to_group("ducks")
	var fireball := preload("res://Fireball.tscn")
	for i in range(maxFireballs):
		var fb = fireball.instance()
		fireballPool.append(fb)
		get_parent().call_deferred("add_child", fb)
	
	var bulletHole = preload("res://BulletHole.tscn")
	for i in range(maxBulletHoles):
		var hole = bulletHole.instance()
		duckBody.add_child(hole)
		bulletHoles.append(hole)
		
	for i in range(maxSinkers):
		var sinker = WatercraftBallast.new()
		add_child(sinker)
		sinkers.append(sinker)
		
	thinkCounter = randf() * thinkTime
	disable()

func process_hit(var position : Vector3, var normal : Vector3):
	var localPos := to_local(position)
	
	if hits < maxBulletHoles:
		var hole : Spatial = bulletHoles[hits]
		hole.translation = localPos
		hole.look_at(to_local(position - normal), Vector3.UP)
		hole.show()
	
	if (hits < maxSinkers):
		var sinker : WatercraftBallast = sinkers[hits]
		sinker.mass = 2000
		sinker.origin = localPos

	lastShotTime = 0	
	hits += 1

func _process(delta):
	if !active:
		return
		
	thinkCounter += delta
	if thinkCounter > thinkTime:
		calculate_motion()
		calculate_shot(thinkCounter)
		calculate_sink(thinkCounter)
		thinkCounter = 0

func calculate_sink(delta):
	mass += hits * hits * 100 * delta

func calculate_motion():
	var gt := get_global_transform()
	var globalPos := Vector2(gt.origin.x, gt.origin.z)
	var currentAngle := -Vector2(gt.basis.z.x, gt.basis.z.z).normalized()
	var targetAngle := (globalPos - targetPosition).normalized()
	angleToPlayer = currentAngle.angle_to(targetAngle)
	distanceToPlayer = globalPos.distance_squared_to(targetPosition)
	var thrust = baseThrust
	#print(distanceToPlayer, ", ", angleToPlayer)
	if hits >= 5:
		mass += 500
	if gt.origin.y < -10:
		disable()
	elif abs(distanceToPlayer - targetPlayerDistance) < targetCloseDistance:
		#print("close distance")
		if abs(angleToPlayer) < 1.0:
			#print("close angle")
			thrust /= 4
		if angleToPlayer < 0:
			#print("turn right")
			leftFoot.value = -thrust / 2
			rightFoot.value = thrust / 2
		else:
			#print("turn left")
			leftFoot.value = thrust / 2
			rightFoot.value = -thrust / 2
	else:
		if abs(angleToPlayer) > 1.0:
			#print("big turn")
			if angleToPlayer < 0:
				#print("big turn right")
				leftFoot.value = 0
				rightFoot.value = thrust / 2
			else:
				#print("big turn left")
				leftFoot.value = thrust / 2
				rightFoot.value = 0
		elif distanceToPlayer - targetPlayerDistance > targetCloseDistance:
			#print("big distance")
			if angleToPlayer > 0:
				#print("curve right")
				leftFoot.value = thrust * 1.25
				rightFoot.value = thrust * 0.8
			else:
				#print("curve left")
				leftFoot.value = thrust * 0.8
				rightFoot.value = thrust * 1.25
		else:
			#print("too close")
			if angleToPlayer > 0:
				#print("curve back right")
				leftFoot.value = thrust * -1.25
				rightFoot.value = thrust * -0.8
			else:
				#print("curve back left")
				leftFoot.value = thrust * -0.8
				rightFoot.value = thrust * -1.25

func get_fireball():
	for i in range(maxFireballs):
		if !fireballPool[i].active:
			return fireballPool[i]
	return null

func calculate_shot(var delta):
	lastShotTime += delta
	if abs(angleToPlayer) < 0.1 and lastShotTime > shootCooldownTime:
		lastShotTime = 0
		var fb = get_fireball()
		if (fb):
			fb.initialize(weaponSpawn.global_transform.origin, Vector3(targetPosition.x, 1, targetPosition.y))

func initialize(var launchPosition : Transform, var launchSpeed):
	global_transform = launchPosition
	mode = RigidBody.MODE_RIGID
	call_deferred("apply_central_impulse", launchPosition.basis.z * launchSpeed)
	active = true

func disable():
		if active:
			emit_signal("killed")
		active = false
		mass = startingMass
		sleeping = true
		mode = RigidBody.MODE_STATIC
		hits = 0
		
		for i in range(maxBulletHoles):
			#bulletHoles[i].translation = Vector3.UP
			bulletHoles[i].hide()
		
		for i in range(maxSinkers):
			sinkers[i].mass = 0
		
		global_transform.origin = Vector3(0, -100, 0)
	
func update_target_position(var position : Vector3):
	targetPosition = Vector2(position.x, position.z)
	
func shoot_at(var position: Vector3):
		var fb = get_fireball()
		if (fb):
			fb.initialize(weaponSpawn.global_transform.origin, position)

func unlock_position():
	axis_lock_angular_x = false
	axis_lock_angular_z = false
	axis_lock_linear_x = false
	axis_lock_linear_z = false
