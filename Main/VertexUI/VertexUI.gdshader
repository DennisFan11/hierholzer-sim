shader_type canvas_item;

// 接收從外部傳入的顏色參數，在屬性面板中會顯示為顏色選擇器
uniform vec4 circle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// 控制圓形的半徑 (最大值通常為 0.5，剛好填滿 UV 空間)
uniform float radius : hint_range(0.0, 1.0) = 0.45;

// 控制邊緣平滑（羽化）的程度
uniform float smoothing : hint_range(0.0, 0.5) = 0.05;

void fragment() {
    // 1. 取得當前像素的 UV 座標，並計算到中心點 (0.5, 0.5) 的距離
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // 2. 使用 smoothstep 計算抗鋸齒的平滑遮罩
    // 當距離小於內邊界時，回傳 0；大於外邊界時，回傳 1；中間則平滑過渡。
    // 用 1.0 減去結果，讓圓形內部是不透明 (1.0)，外部是透明 (0.0)
    float mask = 1.0 - smoothstep(radius - smoothing, radius, dist);
    
    // 3. 將最終顏色與計算好的透明度遮罩相乘
    COLOR = vec4(circle_color.rgb, circle_color.a * mask);
}