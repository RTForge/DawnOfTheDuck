extends CSGCombiner

#This has a separate collider, reroute to the proper function
func takeDamage(var position : Vector3, var normal : Vector3):
	get_parent().get_parent().takeDamage(position, normal)