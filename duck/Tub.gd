extends StaticBody

var bulletHoles := []
var maxBulletHoles := 100
var currentBulletHit := 0

var hitPlayers = []

func _ready():
	hitPlayers.append($"TubHitPlayer1")
	hitPlayers.append($"TubHitPlayer2")
	hitPlayers.append($"TubHitPlayer3")
	hitPlayers.append($"TubHitPlayer4")
	
	var bulletHole = load("res://BulletHole.tscn")
	for i in range(maxBulletHoles):
		var hole : Spatial = bulletHole.instance()
		hole.global_transform.origin = Vector3(0, -100, 0)
		get_parent().call_deferred("add_child", hole)
		bulletHoles.append(hole)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func process_hit(var position : Vector3, var normal : Vector3):
	var player : AudioStreamPlayer3D = hitPlayers[randi() % 4]
	player.pitch_scale = 1.0 + randf() * 0.1
	player.global_transform.origin = position
	player.play()
	
	var hole : Spatial = bulletHoles[currentBulletHit]
	hole.global_transform.origin = position
	hole.look_at(position - normal, Vector3.UP)
	currentBulletHit = (currentBulletHit + 1) % maxBulletHoles
