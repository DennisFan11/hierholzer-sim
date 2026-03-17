class_name EdgeUI

extends Node2D


var edge: Edge



func _process(delta: float) -> void:
	if not is_instance_valid(edge):
		push_warning("edge not exist")
		return
	var a = edge.vertex_a.data.get("position", Vector2.ZERO)
	var b = edge.vertex_b.data.get("position", Vector2.ZERO)
	%Line2D.points = [a, b]
