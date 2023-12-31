{
  "sksl": "// This SkSL shader is autogenerated by spirv-cross.\n\nfloat4 flutter_FragCoord;\n\nuniform vec2 resolution;\nuniform float iTime;\n\nvec4 fragColor;\n\nvec2 FLT_flutter_local_FlutterFragCoord()\n{\n    return flutter_FragCoord.xy;\n}\n\nvec3 FLT_flutter_local_palette(float t)\n{\n    vec3 a = vec3(0.5);\n    vec3 b = vec3(0.5);\n    vec3 c = vec3(1.0);\n    vec3 d = vec3(0.263000011444091796875, 0.41600000858306884765625, 0.556999981403350830078125);\n    return a + (b * cos(((c * t) + d) * 6.28318023681640625));\n}\n\nvoid FLT_flutter_local_mainImage(inout vec4 fragColor_1, vec2 fragCoord)\n{\n    vec2 uv = ((fragCoord * 2.0) - resolution) / vec2(resolution.y);\n    vec2 uv0 = uv;\n    vec3 finalColor = vec3(0.0);\n    for (float i = 0.0; i < 4.0; i += 1.0)\n    {\n        uv = fract(uv * 1.5) - vec2(0.5);\n        float d = length(uv) * exp(-length(uv0));\n        float param = (length(uv0) + (i * 0.4000000059604644775390625)) + (iTime * 0.4000000059604644775390625);\n        vec3 col = FLT_flutter_local_palette(param);\n        d = sin((d * 8.0) + iTime) / 8.0;\n        d = abs(d);\n        d = pow(0.00999999977648258209228515625 / d, 1.2000000476837158203125);\n        finalColor += (col * d);\n    }\n    fragColor_1 = vec4(finalColor, 1.0);\n}\n\nvoid FLT_main()\n{\n    vec2 param_2 = FLT_flutter_local_FlutterFragCoord();\n    vec4 param_1;\n    FLT_flutter_local_mainImage(param_1, param_2);\n    fragColor = param_1;\n}\n\nhalf4 main(float2 iFragCoord)\n{\n      flutter_FragCoord = float4(iFragCoord, 0, 0);\n      FLT_main();\n      return fragColor;\n}\n",
  "stage": 1,
  "target_platform": 2,
  "uniforms": [
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 0,
      "name": "resolution",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 1,
      "name": "iTime",
      "rows": 1,
      "type": 10
    }
  ]
}