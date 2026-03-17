class_name VertexUI
extends Node2D

var vertex: Vertex





func _process(delta: float) -> void:
	if not is_instance_valid(vertex):
		push_warning("vertex not exist")
		return
	global_position = vertex.data.get("position", Vector2.ZERO)
	
	match vertex.data.get("current", "IDLE"):
		"IDLE":
			
			modulate = Color.FIREBRICK
		"WALK":
			modulate = Color.GREEN_YELLOW
		"BACK":
			modulate = Color.SKY_BLUE
	(%Icon.material as ShaderMaterial).set_shader_parameter("circle_color",modulate)
	





##
