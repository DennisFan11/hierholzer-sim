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
	
	%Marker2D.global_position = (a+b) /2.0 
	%Label.text = "[color=green][font_size=60]"+str(edge.data.get("SEQ", ""))
	
	%Line2D.modulate = \
		Color.WHITE if edge.data.get("walked", false) else Color.RED

	## 已回收
	if edge.data.get("SEQ", -1) != -1:
		%Line2D.modulate = Color.AQUA
