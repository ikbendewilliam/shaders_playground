import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class Shader1 extends StatelessWidget {
  final List<double> rotation;
  final List<double> translation;
  final int colorIndex1;
  final int colorIndex2;
  final int colorIndex3;
  final int colorIndex4;
  final double noiseWeight;
  final ui.Image noiseMap;

  const Shader1({
    required this.rotation,
    required this.translation,
    required this.colorIndex1,
    required this.colorIndex2,
    required this.colorIndex3,
    required this.colorIndex4,
    required this.noiseWeight,
    required this.noiseMap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/shader.glsl',
      (context, shader, child) => CustomPaint(
        size: MediaQuery.sizeOf(context),
        painter: ShaderPainter(
          shader: shader,
          translation: translation,
          rotation: rotation,
          colorIndex1: colorIndex1,
          colorIndex2: colorIndex2,
          colorIndex3: colorIndex3,
          colorIndex4: colorIndex4,
          noiseWeight: noiseWeight,
          noiseMap: noiseMap,
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final List<double> translation;
  final List<double> rotation;
  final int colorIndex1;
  final int colorIndex2;
  final int colorIndex3;
  final int colorIndex4;
  final double noiseWeight;
  final ui.Image noiseMap;
  var index = 0;

  ShaderPainter({
    required this.shader,
    required this.translation,
    required this.rotation,
    required this.colorIndex1,
    required this.colorIndex2,
    required this.colorIndex3,
    required this.colorIndex4,
    required this.noiseWeight,
    required this.noiseMap,
  });

  void _sendVec2ToShader(Offset vector) {
    shader.setFloat(index++, vector.dx);
    shader.setFloat(index++, vector.dy);
  }

  void _sendVec3ToShader(List<double> list) {
    shader.setFloat(index++, list[0]);
    shader.setFloat(index++, list[1]);
    shader.setFloat(index++, list[2]);
  }

  void _sendColorToShader(Color color, {bool withOpacity = false}) {
    shader.setFloat(index++, color.red / 255 * color.opacity); // uColor r
    shader.setFloat(index++, color.green / 255 * color.opacity); // uColor g
    shader.setFloat(index++, color.blue / 255 * color.opacity); // uColor b
    if (withOpacity) shader.setFloat(index++, color.opacity); // uColor a
  }

  void _sendImageToShader(ui.Image image) {
    shader.setImageSampler(0, image);
  }

  @override
  void paint(Canvas canvas, Size size) {
    index = 0;
    _sendVec2ToShader(Offset(size.width, size.height));
    _sendVec2ToShader(Offset(translation[0], translation[1]));
    _sendVec3ToShader(rotation);
    _sendColorToShader(Colors.primaries[colorIndex1]);
    _sendColorToShader(Colors.primaries[colorIndex2]);
    _sendColorToShader(Colors.primaries[colorIndex3]);
    _sendColorToShader(Colors.primaries[colorIndex4]);
    shader.setFloat(index++, noiseWeight);
    _sendImageToShader(noiseMap);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
