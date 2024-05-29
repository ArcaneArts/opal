#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 resolution;
uniform float time;
out vec4 fragColor;

void main() {
    vec2 pos = FlutterFragCoord().xy / resolution.xy;
    vec3 color = vec3(pos.x, pos.y, 0);
    fragColor = vec4(color ,1);
}