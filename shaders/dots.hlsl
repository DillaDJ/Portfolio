// Author: Dylan Jansen
// Title: Complex Polkadots

#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 u_resolution;
uniform float u_time;


const vec3 bg_color1 = vec3(0.040, 0.040, 0.040);
const vec3 bg_color2 = vec3(0.1,0.1,0.1);

const float bg_weight1 = 0.0;
const float bg_weight2 = 0.4;

const int bg_gradient_rotates_with_dots = 0;


const vec3 dot_color1 = vec3(0.151,0.274,0.680);
const vec3 dot_color2 = vec3(0.680,0.098,0.169);

const float dot_color_weight1 = 1.25;
const float dot_color_weight2 = -0.25;


const int number_of_dots = 20;

const float dot_size = 0.9;
const int dot_size_fades = 1;

const float dot_size_weight1 = 0.1;
const float dot_size_weight2 = 1.78;

const int dots_hide_behind_gradient = 1; // 0 = off; 1 and 2 = hides behind gradient1 and gradient2 respectively 
const int dots_gradient_rotates_with_dots = 0;


const float dot_rotation = -60.0;
const float dot_scroll = 0.006;
const int dot_scroll_alternates = 1; // 0 = off; 1 = alternating

float sq_size;
float sq_inset;

const float min_dot_size = 0.11;


vec2 rotateUV(vec2 in_uv, float rotation, vec2 pivot) {
	float angle = radians(rotation);
		
	in_uv -= pivot;
	
	mat2 rotation_matrix = mat2(vec2(sin(angle), cos(angle)), 
								vec2(cos(angle), -sin(angle)));
	in_uv *= rotation_matrix;
	in_uv += pivot;
	
    return in_uv;
}


void main() {
	sq_size = 1.0 / float(number_of_dots);
	sq_inset = 1.0 - dot_size;
	
	// UV and Mask creation
    vec2 UV = gl_FragCoord.xy/u_resolution.yy;
	vec2 uv = rotateUV(UV, dot_rotation, vec2(0.5));
	
	vec2 scrolling_mask = step(sq_size, mod(uv, 2.0 * sq_size));
	scrolling_mask.r = dot_scroll_alternates == 1 ? scrolling_mask.r - (1.0 - scrolling_mask.r) : 1.0;
	
	vec2 scrolling_uv = vec2(uv.r, uv.g + u_time * dot_scroll * scrolling_mask.r);
	
	// Shape construction
	float new_dot_size = dot_size_fades == 1 ? 1.0 - dot_size * smoothstep(dot_size_weight1, dot_size_weight2, uv.g) : dot_size;
	sq_inset = new_dot_size > min_dot_size ? 1.0 - new_dot_size : 1.0;
	
	vec2 sq = (1.0 / sq_size) * mod(scrolling_uv, sq_size);
	float dots = 1.0 - 2.0 * distance(sq, vec2(0.5));
	float dot_scaled = smoothstep(sq_inset - 0.05, sq_inset + 0.05, dots);
	
	// Mask creation and final coloring
	float gradient_mask = bg_gradient_rotates_with_dots == 1 
							? smoothstep(bg_weight1, bg_weight2, uv.g) 
							: smoothstep(bg_weight1, bg_weight2, UV.g);
	
	float dot_mask = dots_gradient_rotates_with_dots == 1 
							? smoothstep(dot_color_weight1, dot_color_weight2, uv.g) 
							: smoothstep(dot_color_weight1, dot_color_weight2, UV.g);
	
	float dot_hide_mask = smoothstep(dot_color_weight1, dot_color_weight2, UV.g);
	
	if (dots_hide_behind_gradient == 1) {
	 	dot_hide_mask = gradient_mask * dot_scaled;
	} else if (dots_hide_behind_gradient == 2) {
	 	dot_hide_mask = (1.0 - gradient_mask) * dot_scaled;
	}
	else {
	 	dot_hide_mask = dot_scaled;
	}
	
	vec3 colored_bg = mix(bg_color1, bg_color2 , gradient_mask);
	vec3 colored_dots = mix(dot_color1, dot_color2, dot_mask) * dot_hide_mask;
	
	
	vec3 final_color = (colored_bg * (1.0 - dot_hide_mask)) + colored_dots;
	
	gl_FragColor = vec4(final_color, 1.0);
}
