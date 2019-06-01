extends MarginContainer

signal game_started

func _ready():
	$IntroSound.play()
	print(Engine.get_version_info()["string"])

func _on_StartButton_pressed():
	hide()
	$IntroSound.stop()
	emit_signal("game_started")


func _on_SettingsButton_pressed():
	$PopupContainer/SettingsPage.show()
	$PopupContainer.show()

func _on_CreditsButton_pressed():
	$PopupContainer/CreditsPage.show()
	$PopupContainer.show()

func _on_Quit_pressed():
	get_tree().quit()

func _on_PopupContainer_gui_input(event):
	if event is InputEventMouseButton and !event.pressed:
		$PopupContainer/CreditsPage.hide()
		$PopupContainer/SettingsPage.hide()
		$PopupContainer.hide()
