shader_type canvas_item;

void fragment() {
    COLOR = texture(TEXTURE, UV) * COLOR;
    COLOR.rgb *= 2.0;  // Increase brightness for the glow
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
