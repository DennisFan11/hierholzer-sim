extends Node2D


@onready var _force_graph: ForceGraph = %ForceGraph

var _graph: Graph

func _ready() -> void:
	new_graph()
	


## 清理 連線
func new_graph():
	await get_tree().process_frame
	
	if is_instance_valid(_graph):
		_graph.clear()

	_graph = Graph.new()
	
	_graph.new_vertex.connect(_new_vertex)
	_graph.new_edge.connect(_new_edge)
	
	_force_graph._graph = _graph
	starting = false
	next.emit()


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





## Euler Circuit ALG

var sql: int
var starting: bool = false
signal next

var to_end: bool = false

func step(to_end: bool=false):
	self.to_end = to_end
	
	if not starting:
		starting = true
		sql = 0
		var arr: Array[Vertex] = []
		%Path.vertex_path = arr
		await dfs(_graph.get_vertex_list().pick_random(), null)
		to_end = false
	else:
		next.emit()



func dfs(current: Vertex, in_edge: Edge ):
	if not is_instance_valid(current): return
	current.data["current"] = "WALK"
	
	if in_edge: in_edge.data["walked"] = true
	for edge in current.get_edge_list():
		if not edge.data.get("walked", false):
			if not to_end: await next
			if not is_instance_valid(current): return
			
			current.data["current"] = "IDLE"
			await dfs(edge.another(current), edge)
			if not is_instance_valid(current): return
	
	
	if not is_instance_valid(current): return
	
	if in_edge: 
		in_edge.another(current).data["current"] = "BACK"
		sql+=1
		in_edge.data["SEQ"] = sql
	%Path.vertex_path.append(current)
	if not to_end: await next
	if not is_instance_valid(current): return
	
	if in_edge: 
		in_edge.another(current).data["current"] = "IDLE"
	
	




## CONTROL
func _process(delta: float) -> void:
	control()

var hold_vertex: Vertex

func control():
	var mouse_pos = get_global_mouse_position()
	
	# 當滑鼠剛按下的瞬間，尋找鼠標範圍內最近的節點
	if Input.is_action_just_pressed("click"):
		var min_distance: float = 30.0
		hold_vertex = null
		
		# 確保 graph 存在並迭代所有節點
		if is_instance_valid(_graph):
			for v in _graph.get_vertex_list():
				# 假設你的節點座標儲存在 data["position"] 中，若無則預設為 Vector2.ZERO
				var v_pos = v.data.get("position", Vector2.ZERO) 
				var dist = v_pos.distance_to(mouse_pos)
				
				# 找出距離小於 30 且最近的節點
				if dist < min_distance:
					min_distance = dist
					hold_vertex = v
					
	# 當滑鼠放開時，清空選取的節點
	elif Input.is_action_just_released("click"):
		hold_vertex = null
	
	# 如果目前有抓取節點，則將其位置更新為滑鼠當前位置
	if hold_vertex:
		hold_vertex.data["position"] = mouse_pos








### TEST CASES

func _on_next_pressed() -> void:
	step()
func _on_to_end_pressed() -> void:
	step(true)



func _on_case_20_pressed() -> void:
	await new_graph()
	_graph.parse_graph(
"20
30
0 1
1 2
2 0
2 3
3 4
4 2
4 5
5 6
6 4
6 7
7 8
8 6
8 9
9 10
10 8
10 11
11 12
12 10
12 13
13 14
14 12
14 15
15 16
16 14
16 17
17 18
18 16
18 19
19 0
0 18")


func _on_case_6_pressed() -> void:
	await new_graph()
	_graph.parse_graph(
"6
7
0 1
0 3
1 2
2 3
3 4
3 5
4 5")



func _on_custom_pressed() -> void:
	await new_graph()
	_graph.parse_graph(%LineEdit.text)


func _on_case_10_pressed() -> void:
	await new_graph()
	_graph.parse_graph("10
12
0 1
1 2
2 3
3 0
0 4
4 5
5 6
6 0
0 7
7 8
8 9
9 0")


func _on_case_30_pressed() -> void:
	await new_graph()
	_graph.parse_graph("30
80
0 1
1 2
2 3
3 4
4 5
5 6
6 7
7 8
8 9
9 0
10 11
11 12
12 13
13 14
14 15
15 16
16 17
17 18
18 19
19 10
20 21
21 22
22 23
23 24
24 25
25 26
26 27
27 28
28 29
29 20
0 10
0 11
1 11
1 12
2 12
2 13
3 13
3 14
4 14
4 15
5 15
5 16
6 16
6 17
7 17
7 18
8 18
8 19
9 19
9 10
10 20
10 21
11 21
11 22
12 22
12 23
13 23
13 24
14 24
14 25
15 25
15 26
16 26
16 27
17 27
17 28
18 28
18 29
19 29
19 20
20 22
21 23
22 24
23 25
24 26
25 27
26 28
27 29
28 20
29 21")
