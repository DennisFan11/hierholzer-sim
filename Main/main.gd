extends Node2D


@onready var _force_graph: ForceGraph = %ForceGraph

var _graph: Graph

func _ready() -> void:
	new_graph()
	


## 清理 連線
func new_graph():
	if is_instance_valid(_graph):
		_graph.clear()

	_graph = Graph.new()
	
	_graph.new_vertex.connect(_new_vertex)
	_graph.new_edge.connect(_new_edge)
	
	_force_graph._graph = _graph


func _new_vertex(v: Vertex):
	#print("ADD NODE") 
	var vertex: VertexUI = preload("uid://d3cq7tqth1513").instantiate()
	vertex.vertex = v
	v._dead.connect(vertex.queue_free)
	#v._dead.connect(print.bind("REMOVE NODE"))
	add_child(vertex)
	
func _new_edge(e: Edge):
	var edge: EdgeUI = preload("uid://b423spscijkqb").instantiate()
	edge.edge = e
	e._dead.connect(edge.queue_free)
	add_child(edge)





## ALG



var _current_node: Vertex















### TEST CASES




func _on_case_30_pressed() -> void:
	new_graph()
	_graph.parse_graph(
"30
60
0 1
1 2
2 3
3 4
4 5
5 6
6 7
7 8
8 9
9 10
10 11
11 12
12 13
13 14
14 15
15 16
16 17
17 18
18 19
19 20
20 21
21 22
22 23
23 24
24 25
25 26
26 27
27 28
28 29
29 0
0 2
1 3
2 4
3 5
4 6
5 7
6 8
7 9
8 10
9 11
10 12
11 13
12 14
13 15
14 16
15 17
16 18
17 19
18 20
19 21
20 22
21 23
22 24
23 25
24 26
25 27
26 28
27 29
28 0
29 1")
