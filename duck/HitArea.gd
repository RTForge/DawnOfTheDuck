extends Area

onready var duck = $".."

func process_hit(var position : Vector3, var normal : Vector3):
	duck.process_hit(position, normal)
