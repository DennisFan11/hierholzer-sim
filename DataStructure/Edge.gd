class_name Edge
extends Object

signal _dead
var _graph: Graph
func _init(graph: Graph, v_a: Vertex, v_b: Vertex) -> void:
	self._graph = graph
	self.vertex_a = v_a
	self.vertex_b = v_b


var vertex_a: Vertex:
	set(new):
		vertex_a = new

var vertex_b: Vertex:
	set(new):
		vertex_b = new

## 客製化資料
var data: Dictionary = {}
