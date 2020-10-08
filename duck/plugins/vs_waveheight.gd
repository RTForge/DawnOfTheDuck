tool
extends VisualShaderNodeCustom
class_name VS_WaveHeight

func _get_name():
	return "WaveHeight"

func _get_category():
	return "Custom"

func _get_description():
	return "Returns the wave height at a given coordinate"

func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_input_port_count():
	return 5;

func _get_input_port_name(port):
	match port:
		0:
			return "coord"
		1:
			return "amplitude"
		2:
			return "frequency"
		3:
			return "time"
		4:
			return "time factor"

func _get_input_port_type(port):
	match port:
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR
		_:
			return VisualShaderNode.PORT_TYPE_VECTOR

func _get_output_port_count():
	return 1

func _get_output_port_name(port):
	return "coord"

func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_global_code(mode):
	return """
		float height(vec2 _amplitude, vec2 _frequency, float _time, vec2 _time_factor, vec2 _pos) {
			return _amplitude.x * sin(_pos.x * _frequency.x + _time * _time_factor.x) + _amplitude.y * sin(_pos.y * _frequency.y + _time * _time_factor.y) - 0.5;
		}
	"""
	
func _get_code(input_vars, output_vars, mode, type):
	return """
	{
		float h = height({amplitude}.xy, {frequency}.xy, {time}, {time_factor}.xy, {coord_in}.xz);
		{coord_out} = vec3({coord_in}.x, h, {coord_in}.z);
	}
	""".format({
		"coord_in": input_vars[0],
		"amplitude": input_vars[1],
		"frequency": input_vars[2],
		"time": input_vars[3],
		"time_factor": input_vars[4],
		"coord_out": output_vars[0]
	})
