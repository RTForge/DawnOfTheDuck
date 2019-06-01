tool
extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var width : float = 10 setget set_width
export(float) var height : float = 10 setget set_height
export(float) var subdiv : float = 1.0 setget set_subdiv

func set_width(val):
	width = val
	render()

func set_height(val):
	height = val
	render()

func set_subdiv(val):
	subdiv = val
	render()

# Called when the node enters the scene tree for the first time.
func _ready():
	render()
	
func render():
	print("rendering")
	var halfWidth := width / 2.0
	var halfHeight := height / 2.0
	var halfSubdiv := subdiv / 2.0
	var subdiv_height = subdiv * 0.866
	
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var totalTris : int = 0
	var oddCol := false
	var j = -halfHeight
	while (j < halfHeight):
		oddCol = !oddCol
		var i = -halfWidth
		while (i < halfWidth):
			if oddCol:
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i, 0, j))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i + subdiv, 0, j))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i + halfSubdiv, 0, j + subdiv_height))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i, 0, j))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i + halfSubdiv, 0, j + subdiv_height))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i - halfSubdiv, 0, j + subdiv_height))
			else:
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i - halfSubdiv, 0, j))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i + halfSubdiv, 0, j))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i, 0, j + subdiv_height))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i + halfSubdiv, 0, j))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i + subdiv, 0, j + subdiv_height))
				st.add_color(Color(randf(), randf(), randf()))
				st.add_vertex(Vector3(i, 0, j + subdiv_height))
			totalTris += 2
			i += subdiv
		j += subdiv_height
	mesh = st.commit()
	print("total tris = ", totalTris)