extends Spatial

export var maxDucks := 10
export var launchInterval := 15
export var launchVariance := 0.25
export var launchSpeed := 100000
export var enabled := false setget setEnabled

var duckPool = []
var gameTime := 0.0
var nextLaunch := 0.0

func setEnabled(value):
	enabled = value
	setLaunchTime()
	
func loadDucks():
		var duck = load("res://Duck.tscn")
		print("pooling ", maxDucks, " ducks")
		for i in range(maxDucks):
			var d = duck.instance()
			add_child(d)
			duckPool.append(d)
			d.connect("killed", self, "incrementDuckKills")

func setLaunchTime():
	var varianceAmount := int(ceil(launchInterval * launchVariance))
	nextLaunch = gameTime + launchInterval + randi() % (varianceAmount * 2) - varianceAmount

func getAvailableDuck():
	for i in range(maxDucks):
		if !duckPool[i].active:
			return duckPool[i]
	return null

func launchDuck():
	var duck : HydroRigidBody = getAvailableDuck()
	if duck:
		duck.initialize(global_transform, launchSpeed)


func _process(delta):
	if !enabled:
		return
		
	gameTime += delta
	if gameTime > nextLaunch:
		launchDuck()
		setLaunchTime()

func incrementDuckKills():
	$"../InputManager".incrementDuckKills()