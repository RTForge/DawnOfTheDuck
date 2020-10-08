tool
extends VisualShaderNodeCustom
class_name VS_WaveNormal

func _get_name():
	return "WaveNormal"

func _get_category():
	return "Custom"

func _get_description():
	return "Returns the wave normal at a given coordinate"

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
	return "normal"

func _get_output_port_type(port):
	return VisualShaderNode.PORT_TYPE_VECTOR

func _get_global_code(mode):
	return """
		vec3 wave_normal(vec2 _amplitude, vec2 _frequency, float _time, vec2 _time_factor, vec2 _pos, float _res) {
			vec2 rPos = _pos + vec2(_res, 0.0);
			float rHeight = height(_amplitude, _frequency, _time, _time_factor, rPos);
			vec2 lPos = _pos - vec2(_res, 0.0);
			float lHeight = height(_amplitude, _frequency, _time, _time_factor, lPos);
			vec2 uPos = _pos + vec2(0.0, _res);
			float uHeight = height(_amplitude, _frequency, _time, _time_factor, uPos);
			vec2 dPos = _pos - vec2(0.0, _res);
			float dHeight = height(_amplitude, _frequency, _time, _time_factor, dPos);
			
			vec3 left = vec3(lPos.x, lHeight, lPos.y);
			vec3 right = vec3(rPos.x, rHeight, rPos.y);
			vec3 up = vec3(uPos.x, uHeight, uPos.y);
			vec3 down = vec3(dPos.x, dHeight, dPos.y);
			
			return -normalize(cross(right-left, down-up));
		}
	"""
	
func _get_code(input_vars, output_vars, mode, type):
	return """
	{
		{normal} = wave_normal({amplitude}.xy, {frequency}.xy, {time}, {time_factor}.xy, {coord_in}.xz, 0.1);
	}
	""".format({
		"coord_in": input_vars[0],
		"amplitude": input_vars[1],
		"frequency": input_vars[2],
		"time": input_vars[3],
		"time_factor": input_vars[4],
		"normal": output_vars[0]
	})
