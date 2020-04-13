shader_type canvas_item;

uniform float offset = 5.0;

float snap(float val, float snap){
	return snap * round(val / snap);
}

float rand(vec2 vert){
	return fract(sin(dot(vert.xy, vec2(12.9083, 34.3234))) * 23432.23432);
}

vec2 rand2(vec2 vert){
	return vec2(rand(vert), rand(vert + vec2(324.2334, 563.2234)));
}

void vertex(){
	VERTEX += rand2(VERTEX + vec2(snap(TIME, 0.2), 0)) * offset;
}