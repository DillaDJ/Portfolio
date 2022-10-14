// Author: Dylan Jansen

#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


#define uv gl_FragCoord.xy / u_resolution.xy


void main() {
    vec3 color = vec3(u_mouse.x / u_resolution.x, 1.0 - u_mouse.x / u_resolution.x, 1.0 - u_mouse.x / u_resolution.x);

    gl_FragColor = vec4(color, 1.0);
}