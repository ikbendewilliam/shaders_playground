import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class NeonShaderScreen extends StatefulWidget {
  const NeonShaderScreen({super.key});

  @override
  State<NeonShaderScreen> createState() => _NeonShaderScreenState();
}

class _NeonShaderScreenState extends State<NeonShaderScreen> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    getImage('images/test.png').then(
      (value) => setState(() {
        _image = value;
      }),
    );
  }

  Future<ui.Image> getImage(String path) async {
    var completer = Completer<ImageInfo>();
    var img = AssetImage(path);
    img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ShaderBuilder(
      assetKey: 'shaders/neon_shader.glsl',
      (context, shader, child) => CustomPaint(
        size: MediaQuery.sizeOf(context),
        painter: ShaderPainter(
          shader: shader,
          image: _image!,
        ),
        child: child,
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go back'),
            ),
          ),
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final ui.Image image;
  var index = 0;

  ShaderPainter({
    required this.shader,
    required this.image,
  });

  void _sendVec2ToShader(Offset vector) {
    shader.setFloat(index++, vector.dx);
    shader.setFloat(index++, vector.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    index = 0;
    _sendVec2ToShader(Offset(size.width, size.height));
    shader.setImageSampler(0, image);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
