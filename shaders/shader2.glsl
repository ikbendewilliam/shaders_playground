// This is not my shader, all credit goes to kishimisu 
// Watch his video tutorial here: https://youtu.be/f4s1h2YETNY
// Original: https://www.shadertoy.com/view/mtyGWy
#version 460 core

#include<flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform float iTime;
out vec4 fragColor;

/* This animation is the material of my first youtube tutorial about creative
coding, which is a video in which I try to introduce programmers to GLSL
and to the wonderful world of shaders, while also trying to share my recent
passion for this community.
Video URL: https://youtu.be/f4s1h2YETNY
*/

//https://iquilezles.org/articles/palettes/
vec3 palette(float t){
    vec3 a=vec3(.5,.5,.5);
    vec3 b=vec3(.5,.5,.5);
    vec3 c=vec3(1.,1.,1.);
    vec3 d=vec3(.263,.416,.557);
    
    return a+b*cos(6.28318*(c*t+d));
}

void mainImage(out vec4 fragColor,in vec2 fragCoord){
    vec2 uv=(fragCoord*2.-resolution.xy)/resolution.y;
    vec2 uv0=uv;
    vec3 finalColor=vec3(0.);
    
    for(float i=0.;i<4.;i++){
        uv=fract(uv*1.5)-.5;
        
        float d=length(uv)*exp(-length(uv0));
        
        vec3 col=palette(length(uv0)+i*.4+iTime*.4);
        
        d=sin(d*8.+iTime)/8.;
        d=abs(d);
        
        d=pow(.01/d,1.2);
        
        finalColor+=col*d;
    }
    
    fragColor=vec4(finalColor,1.);
}

void main(){
    mainImage(fragColor,FlutterFragCoord().xy);
}
