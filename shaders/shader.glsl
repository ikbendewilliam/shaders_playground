#version 460 core

#include<flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 resolution;
uniform vec2 translation;
uniform vec3 rotation;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform vec3 color4;
uniform float imageWeight;
uniform sampler2D image;

out vec4 fragColor;

mat4 rotationMatrix(vec3 axis,float angle)
{
    axis=normalize(axis);
    float s=sin(angle);
    float c=cos(angle);
    float oc=1.-c;
    
    return mat4(oc*axis.x*axis.x+c,oc*axis.x*axis.y-axis.z*s,oc*axis.z*axis.x+axis.y*s,0.,
        oc*axis.x*axis.y+axis.z*s,oc*axis.y*axis.y+c,oc*axis.y*axis.z-axis.x*s,0.,
        oc*axis.z*axis.x-axis.y*s,oc*axis.y*axis.z+axis.x*s,oc*axis.z*axis.z+c,0.,
    0.,0.,0.,1.);
}

void main(){
    vec2 st=FlutterFragCoord().xy/resolution.xy;
    
    st.x+=translation.x/10;
    st.y+=translation.y/10;
    
    vec4 str=rotationMatrix(rotation, 1)*vec4(st,0,1);
    
    vec3 percent=vec3((str.x+str.y)/2);
    vec3 percent2=vec3((1-str.x+str.y)/2);
    
    vec4 color=vec4(
        mix(
            mix(color1,color2,percent),
            mix(color3,color4,percent2),
            percent2
        ),
        1
    );
    if(imageWeight==0){
        fragColor=color;
        return;
    }
    fragColor=mix(color,texture(image,st)*color,imageWeight);
}

