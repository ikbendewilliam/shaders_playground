#version 460 core

#define BLUR_RADIUS 8.

#include<flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform sampler2D imageTexture;

out vec4 fragColor;

void main()
{
    vec2 uv=FlutterFragCoord().xy/resolution.xy;
    vec4 texColor=texture(imageTexture,uv);
    
    vec3 glowColor=vec3(0.);
    for(float x=-BLUR_RADIUS;x<=BLUR_RADIUS;x++){
        for(float y=-BLUR_RADIUS;y<=BLUR_RADIUS;y++){
            vec2 offsetScaled=vec2(x,y);
            vec2 offset=offsetScaled/BLUR_RADIUS;
            offsetScaled/=resolution.xy;
            vec2 rs=uv+offsetScaled;
            vec4 sampleColor=texture(imageTexture,rs);
            
            float isBright=step(.5,(sampleColor.r+sampleColor.g+sampleColor.b)/3.);
            glowColor+=sampleColor.rgb*isBright*(1.-length(offset))/BLUR_RADIUS/BLUR_RADIUS*4.;
        }
    }
    fragColor=vec4(texColor.rgb+glowColor,1.);
}
