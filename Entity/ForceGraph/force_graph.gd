class_name ForceGraph
extends Node2D

# --- 物理模擬參數 (可在屬性面板調整) ---
## 向心力強度 (避免圖形無限發散)
@export var center_gravity: float = 20.0

## 排斥力常數 (節點互相推開的力度)
@export var repulsion_force: float = 3000.0

## 彈簧理想長度 (相連節點之間的預期距離)
@export var spring_length: float = 200.0

## 彈簧彈力係數 (拉扯回理想長度的力道)
@export var spring_stiffness: float = 4.0

## 最小距離防呆 (防止除以零的錯誤)
@export var min_distance: float = 0.1

var _graph: Graph

func _get_pos(v: Vertex) -> Vector2:
	if not v.data.has("position"):
		v.data["position"] = Vector2.ZERO
	return v.data["position"]

func _set_pos(v: Vertex, pos: Vector2) -> void:
	v.data["position"] = pos

## 彈簧力學
func _process(delta: float) -> void:
	if not is_instance_valid(_graph):
		return
	
	var vertices := _graph.get_vertex_list()
	if vertices.is_empty():
		return

	# 暫存這回合的位移量，避免邊算邊改位置影響後續運算
	var displacements := {}
	
	# 1. 初始化每個點的位移 (加入微弱的向心力，避免圖形無限發散)
	for v: Vertex in vertices:
		var pos := _get_pos(v)
		displacements[v] = -pos.normalized() * center_gravity 

	# 2. 計算排斥力 (所有節點互相推開)
	for i in range(vertices.size()):
		var v1 := vertices[i]
		var p1 := _get_pos(v1)
		
		for j in range(i + 1, vertices.size()):
			var v2 := vertices[j]
			var p2 := _get_pos(v2)
			
			var dir := p1 - p2
			var dist := dir.length()
			
			# 防止完全重疊導致除以零
			if dist < min_distance:
				dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
				dist = min_distance
				
			# 距離越近，推力越大
			var force := dir.normalized() * (repulsion_force / dist)
			displacements[v1] += force
			displacements[v2] -= force

	# 3. 計算吸引力 (有邊相連的節點像彈簧般拉扯)
	var processed_edges := {}
	for v1: Vertex in vertices:
		var p1 := _get_pos(v1)
		
		for edge in v1.get_edge_list():
			if processed_edges.has(edge):
				continue
			processed_edges[edge] = true
			
			var v2: Vertex = edge.vertex_a if edge.vertex_b == v1 else edge.vertex_b
			var p2 := _get_pos(v2)
			
			var dir := p2 - p1
			var dist := dir.length()
			
			# 彈簧拉力：(當前距離 - 理想距離) * 彈力係數
			var force := dir.normalized() * (dist - spring_length) * spring_stiffness
			displacements[v1] += force
			displacements[v2] -= force

	# 4. 結算並「只更新位置」
	for v: Vertex in vertices:
		var current_pos := _get_pos(v)
		# 將算出的總推拉力乘上 delta 作為這幀的位移
		_set_pos(v, current_pos + displacements[v] * delta)
