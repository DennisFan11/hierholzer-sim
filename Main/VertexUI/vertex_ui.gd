class_name VertexUI
extends Node2D

var vertex: Vertex





func _process(delta: float) -> void:
	if not is_instance_valid(vertex):
		push_warning("vertex not exist")
		return
	global_position = vertex.data.get("position", Vector2.ZERO)
