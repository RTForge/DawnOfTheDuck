extends Node2D

export var crosshairLevel : int = 0
onready var crosshair : Sprite = $Crosshair
onready var healthBar : TextureProgress = $HealthBar
onready var gunHeatBar : TextureProgress = $GunHeatBar

const gunBarNormalColor = Color(0.25, 0.25, 1.0)
const gunBarHotColor = Color(1.0, 0.25, 0.25)

func _ready():
	
	if crosshairLevel == 1:
		get_tree().get_root().connect("size_changed", self, "centerCrosshair")
		centerCrosshair()
	elif crosshairLevel == 2:
		crosshair.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func centerCrosshair():
	crosshair.transform.origin = get_viewport().size / 2


func _on_OrbitTargetCam_crosshair_position_changed(var pos : Vector2):
	if crosshairLevel == 0:
		crosshair.transform.origin = pos



func _on_Player_health_changed(value):
	healthBar.value = value


func _on_Player_gun_heat_changed(value):
	#gunHeatBar.tint_progress = gunBarHotColor if value > 0.9 else gunBarNormalColor
	gunHeatBar.tint_progress = lerp(gunBarNormalColor, gunBarHotColor, value)
	gunHeatBar.value = value
