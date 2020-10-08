extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/GridContainer/DifficultyDropdown.add_item("Newly Hatched", 0)
	$MarginContainer/VBoxContainer/GridContainer/DifficultyDropdown.add_item("Quack Shot", 1)
	$MarginContainer/VBoxContainer/GridContainer/DifficultyDropdown.add_item("Yippie Ki Yay, Rubber Ducker!", 2)

func _on_FullscreenCheckBox_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_DifficultyDropdown_item_selected(ID):
	GlobalSettings.difficulty = ID

func _on_HSlider_value_changed(value):
	GlobalSettings.mouseSensitivity = value
