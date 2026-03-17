class_name Graph
extends RefCounted



signal new_vertex(vertex: Vertex)
signal new_edge(edge: Edge)


var _vertex_list: Dictionary[int, Vertex]
var _edge_list: Array[Edge]

func get_vertex(vertex_id: int)-> Vertex:
	return _vertex_list.get(vertex_id, null)

func get_vertex_list()-> Array[Vertex]:
	return _vertex_list.values()

func add_vertex(vertex_id: int):
	var vertex := Vertex.new(self, vertex_id)
	_vertex_list.set(vertex_id, vertex)
	new_vertex.emit(vertex)

func add_edge(vertex_a_id: int, vertex_b_id: int):
	if not _vertex_list.has(vertex_a_id):
		push_error("vertex_a_id dosen't exist: ", vertex_a_id)
		return
	if not _vertex_list.has(vertex_b_id):
		push_error("vertex_b_id dosen't exist: ", vertex_b_id)
		return 
	var edge := Edge.new(
			self,
			_vertex_list[vertex_a_id],
			_vertex_list[vertex_b_id])
	_edge_list.append(edge)
	_vertex_list[vertex_a_id]._edge_list.append(edge)
	_vertex_list[vertex_b_id]._edge_list.append(edge)
	
	new_edge.emit(edge)


func remove_vertex_byinstance(vertex: Vertex):
	vertex._dead.emit()
	_vertex_list.erase(vertex.vertex_id)
	for edge in vertex.get_edge_list().duplicate(true):
		remove_edge_byinstance(edge)
	vertex.free()

func remove_edge_byinstance(edge: Edge):
	edge._dead.emit()
	_edge_list.erase(edge)
	edge.vertex_a._edge_list.erase(edge)
	edge.vertex_b._edge_list.erase(edge)
	edge.free()
	
func clear():
	for i in _vertex_list.duplicate(true).values():
		remove_vertex_byinstance(i)

"""
格式:
	int # vertex count
	int # edge count
	int int # edge
"""
func parse_graph(input: String)-> void:
	var graph = self
	
	# 將換行與 Tab 統一替換為空格，並過濾掉連續的空字串
	var clean_input := input.replace("\n", " ").replace("\r", " ").replace("\t", " ")
	var tokens := clean_input.split(" ", false) 
	
	if tokens.size() < 2:
		push_error("Graph 格式錯誤：輸入資料不足")
		return
	var vertex_count := tokens[0].to_int()
	var edge_count := tokens[1].to_int()
	
	# 建立 Vertex (假設頂點 ID 為 0 到 vertex_count - 1)
	for i in range(vertex_count):
		graph.add_vertex(i)
		
	# 讀取並建立 Edge
	var token_idx := 2
	for _i in range(edge_count):
		if token_idx + 1 >= tokens.size():
			push_error("Graph 格式錯誤：邊的資料數量不足")
			break
			
		var vertex_a_id := tokens[token_idx].to_int()
		var vertex_b_id := tokens[token_idx + 1].to_int()
		
		graph.add_edge(vertex_a_id, vertex_b_id)
		token_idx += 2
		
	#return graph
