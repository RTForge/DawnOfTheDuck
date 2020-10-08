tool
extends VisualShaderNodeCustom
class_name VS_Panner

func _get_name():
	return "Panner"

func _get_category():
	return "Custom"

func _get_description():
	return "Moves a coordinate at a given velocity"

func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_input_port_count():
	return 3

func _get_input_port_name(port):
	match port:
		0:
			return "xyz"
		1:
			return "speed"
		2:
			return "time"

func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR

func _get_output_port_count():
	return 1

func _get_output_port_name(port):
	return "xyz"

func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_code(input_vars, output_vars, mode, type):
	return output_vars[0] + " = " + input_vars[0] + " + " + input_vars[1] + " * " + input_vars[2]
