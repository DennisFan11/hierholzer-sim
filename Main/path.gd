extends Line2D


var vertex_path: Array[Vertex] = []



func _process(delta: float) -> void:
	var point_arr = []
	for i in vertex_path:
		if is_instance_valid(i):
			if i.data.has("position"):
				point_arr.append(i.data["position"])
	points = point_arr
	
