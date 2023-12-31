{
  "sksl": "// This SkSL shader is autogenerated by spirv-cross.\n\nfloat4 flutter_FragCoord;\n\nuniform vec2 iResolution;\nuniform vec2 iMouse;\nuniform float iTime;\n\nvec4 fragColor;\n\nvec2 FLT_flutter_local_FlutterFragCoord()\n{\n    return flutter_FragCoord.xy;\n}\n\nmat2 FLT_flutter_local_rotationMatrix(float r)\n{\n    float s = sin(r);\n    float c = cos(r);\n    return mat2(vec2(c, s), vec2(-s, c));\n}\n\nfloat FLT_flutter_local_hash21(inout vec2 vector)\n{\n    vector = fract(vector * vec2(123.339996337890625, 456.209991455078125));\n    vector += vec2(dot(vector, vector + vec2(45.31999969482421875)));\n    return fract(vector.x * vector.y);\n}\n\nfloat FLT_flutter_local_createStar(inout vec2 coordinates, float flare)\n{\n    float distanceToCenter = length(coordinates);\n    float brightness = 0.0500000007450580596923828125 / distanceToCenter;\n    float rays = max(0.0, 1.0 - abs((coordinates.x * coordinates.y) * 1000.0));\n    float result = brightness + (rays * flare);\n    float param = 0.78537499904632568359375;\n    coordinates *= FLT_flutter_local_rotationMatrix(param);\n    rays = max(0.0, 1.0 - abs((coordinates.x * coordinates.y) * 1000.0));\n    result += ((rays * 0.300000011920928955078125) * flare);\n    result *= smoothstep(1.0, 0.20000000298023223876953125, distanceToCenter);\n    return result;\n}\n\nvec3 FLT_flutter_local_createStarLayer(vec2 coordinates)\n{\n    vec3 result = vec3(0.0);\n    vec2 coordinatesFraction = fract(coordinates) - vec2(0.5);\n    vec2 section = floor(coordinates);\n    for (int y = -1; y <= 1; y++)\n    {\n        for (int x = -1; x <= 1; x++)\n        {\n            vec2 offset = vec2(float(x), float(y));\n            vec2 param = section + offset;\n            float _182 = FLT_flutter_local_hash21(param);\n            float randomBaseNumber = _182;\n            float size = fract(randomBaseNumber * 345.32000732421875);\n            vec2 param_1 = ((coordinatesFraction - offset) - vec2(randomBaseNumber, fract(randomBaseNumber * 34.0))) + vec2(0.5);\n            float param_2 = smoothstep(0.89999997615814208984375, 1.0, size);\n            float _206 = FLT_flutter_local_createStar(param_1, param_2);\n            float star = _206;\n            vec3 color = (sin((vec3(0.20000000298023223876953125, 0.300000011920928955078125, 0.89999997615814208984375) * fract(randomBaseNumber * 2345.199951171875)) * 123.1999969482421875) * 0.5) + vec3(0.5);\n            color *= vec3(1.0, 0.25, 1.0 + size);\n            star *= ((sin((iTime * 3.0) + (randomBaseNumber * 6.283100128173828125)) * 0.5) + 1.0);\n            result += (color * (star * size));\n        }\n    }\n    return result;\n}\n\nvoid FLT_main()\n{\n    vec2 coordinates_1 = (FLT_flutter_local_FlutterFragCoord() - (iResolution * 0.5)) / vec2(iResolution.y);\n    vec2 viewPosition = (iMouse - (iResolution * 0.5)) / vec2(iResolution.y);\n    float progressedTime = iTime * 0.004999999888241291046142578125;\n    coordinates_1 += (viewPosition * 4.0);\n    float param_3 = progressedTime;\n    coordinates_1 *= FLT_flutter_local_rotationMatrix(param_3);\n    vec3 result_1 = vec3(0.0);\n    for (float layerOffset = 0.0; layerOffset < 1.0; layerOffset += 0.125)\n    {\n        float depth = fract(layerOffset + progressedTime);\n        float scale = mix(20.0, 0.5, depth);\n        float fade = depth * smoothstep(1.0, 0.89999997615814208984375, depth);\n        vec2 param_4 = ((coordinates_1 * scale) + vec2(layerOffset * 453.12298583984375)) - viewPosition;\n        result_1 += (FLT_flutter_local_createStarLayer(param_4) * fade);\n    }\n    fragColor = vec4(result_1, 1.0);\n}\n\nhalf4 main(float2 iFragCoord)\n{\n      flutter_FragCoord = float4(iFragCoord, 0, 0);\n      FLT_main();\n      return fragColor;\n}\n",
  "stage": 1,
  "target_platform": 2,
  "uniforms": [
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 0,
      "name": "iResolution",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 1,
      "name": "iMouse",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 2,
      "name": "iTime",
      "rows": 1,
      "type": 10
    }
  ]
}