extends Node

onready var player : HydroRigidBody = $"../Player"
onready var camera : Spatial = $"../OrbitTargetCam"
var isPaused := false

var softThrottle : float
var fpsInterval := 0.0
var active := false setget setActive

var survivalTime := 0.0
var duckCount := 0

func setActive(value):
	active = value
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if active else Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if !active: 
		return
		
	survivalTime += delta

	if Input.is_action_just_released("pause"):
		isPaused = !isPaused
		get_tree().paused = isPaused
		if isPaused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$"../PausedScreen".show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$"../PausedScreen".hide()
	
	if isPaused:
		return
	
	if Input.is_action_pressed("ui_up"):
		if softThrottle < 1.0:
			softThrottle += delta
		if softThrottle > 1.0:
			softThrottle = 1.0
	elif Input.is_action_pressed("ui_down"):
		if softThrottle > -0.5:
			softThrottle -= delta
		if softThrottle < -0.5:
			softThrottle = -0.5
	else:
		if softThrottle > 0:
			softThrottle -= delta
		elif softThrottle < 0:
			softThrottle += delta
	player.throttle(softThrottle)
	
	if Input.is_action_pressed("ui_left"):
		player.steer(-1.0)
	elif Input.is_action_pressed("ui_right"):
		player.steer(1.0)
	else:
		player.steer(0.0)
		
	if Input.is_action_pressed("shoot"):
		player.shoot(true)
	else:
		player.shoot(false)
		
	fpsInterval += delta
	if fpsInterval > 1.0:
		fpsInterval = 0
		print("FPS: ", Engine.get_frames_per_second())
		

func _input(event):
	if !active or isPaused:
		return
	if event is InputEventMouseMotion:
		camera.applyRotation(event.relative * GlobalSettings.mouseSensitivity / 500.0)

func _on_Player_health_changed(health):
	if health == 0:
		setActive(false)
		var gameOver := $"../GameOverScreen"
		gameOver.setSurvivalTime(survivalTime)
		gameOver.setKillCount(duckCount)
		gameOver.show()
		
		player.shoot(false)
		player.steer(0.0)
		player.throttle(0.0)

func incrementDuckKills():
	 duckCount += 1
	