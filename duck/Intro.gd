extends Spatial

var started := false
var timer : Timer

onready var introDuck = $Duck

func _ready():
	introDuck.initialize(Transform(Basis(Vector3.UP, 2.5), Vector3(0.0, 0.0, 20.0)), Vector3.ZERO)
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "playIntro")
	timer.set_wait_time(3)
	timer.one_shot = true

func _process(delta):
	pass
	
func startIntro():
	$AudioStreamPlayer.play()
	timer.start()
	
	match GlobalSettings.difficulty:
		0:
			$"../DuckLauncher1".maxDucks = 4
			$"../DuckLauncher2".maxDucks = 4
			$"../DuckLauncher3".maxDucks = 4
			$"../DuckLauncher4".maxDucks = 4
			$"../DuckLauncher1".launchInterval = 10
			$"../DuckLauncher2".launchInterval = 12
			$"../DuckLauncher3".launchInterval = 12
			$"../DuckLauncher4".launchInterval = 13
		1:
			$"../DuckLauncher1".maxDucks = 6
			$"../DuckLauncher2".maxDucks = 6
			$"../DuckLauncher3".maxDucks = 6
			$"../DuckLauncher4".maxDucks = 6
			$"../DuckLauncher1".launchInterval = 9
			$"../DuckLauncher2".launchInterval = 7
			$"../DuckLauncher3".launchInterval = 8
			$"../DuckLauncher4".launchInterval = 9
		2:
			$"../DuckLauncher1".maxDucks = 8
			$"../DuckLauncher2".maxDucks = 8
			$"../DuckLauncher3".maxDucks = 8
			$"../DuckLauncher4".maxDucks = 8
			$"../DuckLauncher1".launchInterval = 3
			$"../DuckLauncher2".launchInterval = 4
			$"../DuckLauncher3".launchInterval = 5
			$"../DuckLauncher4".launchInterval = 6
	$"../DuckLauncher1".call_deferred("loadDucks")
	$"../DuckLauncher2".call_deferred("loadDucks")
	$"../DuckLauncher3".call_deferred("loadDucks")
	$"../DuckLauncher4".call_deferred("loadDucks")
	

func playIntro():
	introDuck.shoot_at(Vector3(10, 0, -10))
	introDuck.unlock_position()
	$"../OrbitTargetCam".target = @"../Player"
	$"../DuckLauncher1".enabled = true
	$"../DuckLauncher2".enabled = true
	$"../DuckLauncher3".enabled = true
	$"../DuckLauncher4".enabled = true
	$"../InputManager".active = true
	$"../GameOverlay".show()
	

func _on_TitleScreen_game_started():
	startIntro()
