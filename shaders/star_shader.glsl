// This is created by following the tutorial at https://www.youtube.com/watch?v=rvDo9LvfoVE
#version 460 core
#define PI 3.1415
#define TAU 6.2831
#define NUM_LAYERS 8.

#include<flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;
out vec4 fragColor;

mat2 rotationMatrix(float r){
    float s=sin(r),c=cos(r);
    return mat2(c,s,-s,c);
}

float hash21(vec2 vector){
    vector=fract(vector*vec2(123.34,456.21));
    vector+=dot(vector,vector+45.32);
    return fract(vector.x*vector.y);
}

float createStar(vec2 coordinates,float flare){
    float distanceToCenter=length(coordinates);
    float brightness=.05/distanceToCenter;
    
    float rays=max(0.,1.-abs(coordinates.x*coordinates.y*1000.));
    float result=brightness+rays*flare;
    
    coordinates*=rotationMatrix(PI/4.);
    rays=max(0.,1.-abs(coordinates.x*coordinates.y*1000.));
    
    result+=rays*.3*flare;
    result*=smoothstep(1.,.2,distanceToCenter);
    return result;
}

vec3 createStarLayer(vec2 coordinates){
    vec3 result=vec3(0);
    vec2 coordinatesFraction=fract(coordinates)-.5;
    vec2 section=floor(coordinates);
    
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            vec2 offset=vec2(x,y);
            float randomBaseNumber=hash21(section+offset);
            float size=fract(randomBaseNumber*345.32);
            float star=createStar(coordinatesFraction-offset-vec2(randomBaseNumber,fract(randomBaseNumber*34.))+.5,smoothstep(.9,1.,size));
            vec3 color=sin(vec3(.2,.3,.9)*fract(randomBaseNumber*2345.2)*123.2)*.5+.5;
            color=color*vec3(1,.25,1.+size);
            star*=sin(iTime*3.+randomBaseNumber*TAU)*.5+1.;
            result+=star*size*color;
        }
    }
    return result;
}

void main(){
    vec2 coordinates=(FlutterFragCoord().xy-.5*iResolution.xy)/iResolution.y;
    vec2 viewPosition=(iMouse.xy-.5*iResolution.xy)/iResolution.y;
    float progressedTime=iTime*.005;
    
    coordinates+=viewPosition*4.;
    coordinates*=rotationMatrix(progressedTime);
    
    vec3 result=vec3(0);
    for(float layerOffset=0.;layerOffset<1.;layerOffset+=1./NUM_LAYERS){
        float depth=fract(layerOffset+progressedTime);
        float scale=mix(20.,.5,depth);
        float fade=depth*smoothstep(1.,.9,depth);
        result+=createStarLayer(coordinates*scale+layerOffset*453.123-viewPosition)*fade;
    }
    
    fragColor=vec4(result,1.);
}
