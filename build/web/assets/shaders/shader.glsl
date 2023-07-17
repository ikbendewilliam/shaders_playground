{
  "sksl": "// This SkSL shader is autogenerated by spirv-cross.\n\nfloat4 flutter_FragCoord;\n\nuniform vec2 resolution;\nuniform vec2 translation;\nuniform vec3 rotation;\nuniform vec3 color1;\nuniform vec3 color2;\nuniform vec3 color3;\nuniform vec3 color4;\nuniform float imageWeight;\nuniform shader image;\nuniform half2 image_size;\n\nvec4 fragColor;\n\nvec2 FLT_flutter_local_FlutterFragCoord()\n{\n    return flutter_FragCoord.xy;\n}\n\nmat4 FLT_flutter_local_rotationMatrix(inout vec3 axis, float angle)\n{\n    axis = normalize(axis);\n    float s = sin(angle);\n    float c = cos(angle);\n    float oc = 1.0 - c;\n    return mat4(vec4(((oc * axis.x) * axis.x) + c, ((oc * axis.x) * axis.y) - (axis.z * s), ((oc * axis.z) * axis.x) + (axis.y * s), 0.0), vec4(((oc * axis.x) * axis.y) + (axis.z * s), ((oc * axis.y) * axis.y) + c, ((oc * axis.y) * axis.z) - (axis.x * s), 0.0), vec4(((oc * axis.z) * axis.x) - (axis.y * s), ((oc * axis.y) * axis.z) + (axis.x * s), ((oc * axis.z) * axis.z) + c, 0.0), vec4(0.0, 0.0, 0.0, 1.0));\n}\n\nvoid FLT_main()\n{\n    vec2 st = FLT_flutter_local_FlutterFragCoord() / resolution;\n    st.x += (translation.x / 10.0);\n    st.y += (translation.y / 10.0);\n    vec3 param = rotation;\n    float param_1 = 1.0;\n    mat4 _183 = FLT_flutter_local_rotationMatrix(param, param_1);\n    vec4 str = _183 * vec4(st, 0.0, 1.0);\n    vec3 percent = vec3((str.x + str.y) / 2.0);\n    vec3 percent2 = vec3(((1.0 - str.x) + str.y) / 2.0);\n    vec4 color = vec4(mix(mix(color1, color2, percent), mix(color3, color4, percent2), percent2), 1.0);\n    if (imageWeight == 0.0)\n    {\n        fragColor = color;\n        return;\n    }\n    fragColor = mix(color, image.eval(image_size *  st) * color, vec4(imageWeight));\n}\n\nhalf4 main(float2 iFragCoord)\n{\n      flutter_FragCoord = float4(iFragCoord, 0, 0);\n      FLT_main();\n      return fragColor;\n}\n",
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
      "name": "translation",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 2,
      "name": "rotation",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 3,
      "name": "color1",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 4,
      "name": "color2",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 5,
      "name": "color3",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 6,
      "name": "color4",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 7,
      "name": "imageWeight",
      "rows": 1,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 0,
      "columns": 1,
      "location": 8,
      "name": "image",
      "rows": 1,
      "type": 12
    }
  ]
}