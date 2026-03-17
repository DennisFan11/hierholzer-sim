class_name Vertex
extends Object

var vertex_id: int

signal _dead
var _graph: Graph
func _init(graph: Graph, vertex_id:int) -> void:
	self._graph = graph
	self.vertex_id = vertex_id




var _edge_list: Array[Edge]


func get_edge_list()-> Array[Edge]:
	return _edge_list


## 客製化資料
var data: Dictionary = {}








#
