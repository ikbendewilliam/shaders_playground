import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class SnapShaderScreen extends StatefulWidget {
  final bool pixelated;

  const SnapShaderScreen({
    required this.pixelated,
    super.key,
  });

  @override
  State<SnapShaderScreen> createState() => _SnapShaderScreenState();
}

class _SnapShaderScreenState extends State<SnapShaderScreen> {
  ui.Image? _image;
  final start = DateTime.now().millisecondsSinceEpoch / 1000;
  var now = DateTime.now().millisecondsSinceEpoch / 1000;

  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) => setState(() {
        now = DateTime.now().millisecondsSinceEpoch / 1000;
      }),
    );
    getImage('images/mario.png').then(
      (value) => setState(() {
        _image = value;
      }),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade200,
              Colors.blueGrey.shade500,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ShaderBuilder(
          assetKey: widget.pixelated ? 'shaders/snap_effect_shader_pixelated.glsl' : 'shaders/snap_effect_shader.glsl',
          (context, shader, child) => CustomPaint(
            size: MediaQuery.sizeOf(context),
            painter: ShaderPainter(
              shader: shader,
              image: _image!,
              secondsPassed: now - start,
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
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final ui.Image image;
  var index = 0;
  final double secondsPassed;

  ShaderPainter({
    required this.shader,
    required this.image,
    required this.secondsPassed,
  });

  void _sendVec2ToShader(Offset vector) {
    shader.setFloat(index++, vector.dx);
    shader.setFloat(index++, vector.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    index = 0;
    _sendVec2ToShader(Offset(size.width, size.height));
    shader.setFloat(index++, secondsPassed);
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
