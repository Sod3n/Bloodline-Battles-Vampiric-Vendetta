shader_type canvas_item;


uniform sampler2D texture : hint_default_white;

void fragment() {
    vec2 flipped_uv = vec2(1.0 - UV.x, UV.y); // Отражаем по X
    vec4 tex_color = texture(texture, flipped_uv);
    COLOR = tex_color;
}
