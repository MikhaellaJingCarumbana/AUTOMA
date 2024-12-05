shader_type canvas_item;

uniform float height = 4.0;
uniform float frequency = 25.0;
uniform float speed = 5.0;

void vertex() {
 VERTEX.y += height * sin((frequency * UV.x) + (speed * TIME));
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
