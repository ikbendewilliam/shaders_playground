import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderX extends StatelessWidget {
  final double secondsPassed;
  final String shaderName;

  const ShaderX({
    required this.secondsPassed,
    required this.shaderName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        ShaderBuilder(
          assetKey: 'shaders/$shaderName.glsl',
          (context, shader, child) => CustomPaint(
            size: MediaQuery.sizeOf(context),
            painter: ShaderPainter(
              shader: shader,
              iTime: secondsPassed,
            ),
          ),
        ),
      ],
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double iTime;
  var index = 0;

  ShaderPainter({
    required this.shader,
    required this.iTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    index = 0;
    shader.setFloat(index++, size.width);
    shader.setFloat(index++, size.height);
    shader.setFloat(index++, iTime);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
