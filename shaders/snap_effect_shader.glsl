#version 460 core

#include<flutter/runtime_effect.glsl>

#define pixels 100.// The number of pixels
#define delay 2.// Depends on the opacity of your image, if the corner is transparent,you can set it to 2., otherwise increase it
#define duration 10.// The duration of the animation, the larger the value,the slower the animation
#define border_size .1// The size of the randomness in the border, the larger the value, the more random and wider the border
#define particles_amount .3// The amount of floating particles [0-1], the larger the value, the more particles

#define border_position 0.5 // The position of the border
#define darkness_start_position 0.7 // The position of the darkness [border_position-1] where the darkness starts to appear, the larger the value, the sooner the darkness appears
#define darkness_color 0.5 // The color of the darkness, the smaller the value, the darker the darkness

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
    vec3 darkness=vec3(darkness_color);
    float original_alpha=texColor.a;
    float deltaTime=(iTime-delay)/duration;
    float x=int(uv.x*pixels)/pixels;
    float y=int(uv.y*pixels)/pixels;
    float border=x+y-deltaTime+hash(x,y)*border_size;
    float opacity=step(border_position,border)*original_alpha;
    float darkness_level=smoothstep(darkness_start_position,border_position,border);
    
    float opacity_particals_effect=smoothstep(.3,border_position,border)*(1-opacity)*original_alpha*step(1-particles_amount,hash2(x,y));
    vec4 particals_effect_color=vec4(darkness*opacity_particals_effect,opacity_particals_effect);
    
    fragColor=particals_effect_color+vec4(mix(texColor.rgb,darkness,darkness_level)*opacity,opacity);
}
