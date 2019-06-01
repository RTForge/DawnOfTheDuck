extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func round_to_dec(num, digit):
    return round(num * pow(10.0, digit)) / pow(10.0, digit)

func setSurvivalTime(time):
	var survivalString : String
	if time < 60:
		survivalString = str(round_to_dec(time, 1)) + " seconds"
	else:
		survivalString = str(round_to_dec(time / 60.0, 1)) + " minutes"
	$"MarginContainer/VBoxContainer/GridContainer/SurvivalTime".text = survivalString
	
func setKillCount(count):
	$"MarginContainer/VBoxContainer/GridContainer/DucksEliminated".text = str(count)

func _on_DoneButton_pressed():
	print("reset game")
	get_tree().reload_current_scene()
