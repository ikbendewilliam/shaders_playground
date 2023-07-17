#version 460 core
#define BLUR_RADIUS 16.
#include<flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform sampler2D imageTexture;
out vec4 fragColor;

void main(){
    vec2 uv=FlutterFragCoord().xy/resolution.xy;
    vec4 texColor=texture(imageTexture,uv);
    if(uv.x>.5){
        fragColor=vec4(texColor.rgb,1.);
        return;
    }
    vec3 glowColor=vec3(0.);
    for(float x=-1;x<=1;x+=1./BLUR_RADIUS){
        for(float y=-1;y<=1;y+=1./BLUR_RADIUS){
            vec2 offset=vec2(x,y);
            vec2 offsetScaled=offset*BLUR_RADIUS/resolution.xy;
            vec2 rs=uv+offsetScaled;
            vec4 sampleColor=texture(imageTexture,rs);
            glowColor+=sampleColor.rgb*exp(-length(offset)*4.)/32.;
        }
    }
    fragColor=vec4(texColor.rgb*4.+glowColor,1.);
}

