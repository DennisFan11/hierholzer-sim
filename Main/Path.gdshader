shader_type canvas_item;

// 餘弦調色盤演算法：能產生比普通 mix() 漂亮無數倍的過渡色
// 這裡預設調配了一組帶有賽博龐克感 (紫、藍、青) 的鮮豔漸變
vec3 get_vibrant_color(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    // 利用 cos 函數繪製出完美的色彩曲線
    return a + b * cos(6.28318 * (c * t + d));
}

void fragment() {
    float fill_level = UV.x;
    
    // 1. 使用 TIME 控制進度
    // fract() 會擷取小數部分，所以 (TIME * 0.5) 會不斷地從 0.0 跑到 1.0 然後歸零
    // 數字 0.5 控制填充速度，數字越大跑越快
    float progress = fract(TIME * 0.5);
    
    // 2. 產生高級漸變色
    // 除了根據水平位置 (fill_level) 給色，我還加上了 "- TIME * 0.2"
    // 這會讓整個漸變色像「流光」一樣自動往右流動，動態感更強
    vec3 beautiful_color = get_vibrant_color(fill_level - TIME * 0.2);
    
    // 3. 判斷是否超過進度 (超過則透明)
    float alpha_mask = step(fill_level, progress);
    
    // 讀取原本圖片資訊
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 4. 輸出最終顏色
    COLOR = vec4(beautiful_color, alpha_mask * tex_color.a);
}