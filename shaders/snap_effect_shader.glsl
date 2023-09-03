#version 460 core

#include<flutter/runtime_effect.glsl>
#define duration 10.

uniform vec2 resolution;
uniform float iTime;
uniform sampler2D imageTexture;

out vec4 fragColor;

float hash(float x,float y){
    return fract(sin(dot(vec2(x,y),vec2(12.4139,53.1237)))*52381.1341);
}
float hash2(float x,float y){
    return fract(sin(dot(vec2(x,y),vec2(14.523,127.485)))*2578.316);
}

void main()
{
    vec2 uv=FlutterFragCoord().xy/resolution.xy;
    vec4 texColor=texture(imageTexture,uv);
    float deltaTime=iTime/duration;
    float x=int(uv.x*100)/100.;
    float y=int(uv.y*100)/100.;
    float border=x+y-deltaTime+hash(x,y)*.1+.2;
    float opacity=step(.5,border);
    float colorDarkness=smoothstep(.6,.35,border);
    fragColor=vec4((texColor.rgb-vec3(colorDarkness))*opacity,texColor.a*opacity);
}
