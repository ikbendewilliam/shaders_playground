import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_path_morph/flutter_path_morph.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:shader/paths.dart';

class AnimatedTextNeonShaderScreen extends StatefulWidget {
  const AnimatedTextNeonShaderScreen({super.key});

  @override
  State<AnimatedTextNeonShaderScreen> createState() => _AnimatedTextNeonShaderScreenState();
}

class _AnimatedTextNeonShaderScreenState extends State<AnimatedTextNeonShaderScreen> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  late final _williamPath = SvgPaths.william;
  late final _flutterPath = SvgPaths.flutter;
  late final _williamBounds = _williamPath.getBounds();
  late final _flutterBounds = _flutterPath.getBounds();
  late final _maxWidth = max(_williamBounds.width, _flutterBounds.width);
  late final _maxHeight = max(_williamBounds.height, _flutterBounds.height);
  final colorsWilliam = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.amber,
    Colors.pinkAccent,
    Colors.lime,
    Colors.indigo,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];
  var colorWilliam = 0;
  final colorFlutter = Colors.blue;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onControllerStatusChanged);
    _controller.forward();
  }

  void _onControllerStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      colorWilliam = (colorWilliam + 1) % colorsWilliam.length;
      await Future<void>.delayed(const Duration(seconds: 3));
      await _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      await Future<void>.delayed(const Duration(seconds: 3));
      await _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleW = constraints.maxWidth / _maxWidth / 1.5;
        final scaleH = constraints.maxHeight / _maxHeight / 2;
        final scale = min(scaleW, scaleH);
        final williamMatrix = Matrix4.identity()
          ..scale(scale, scale, scale)
          ..translate(-_williamBounds.width / 2, _williamBounds.height, 0);
        final flutterMatrix = Matrix4.identity()
          ..scale(scale, scale, scale)
          ..translate(-_flutterBounds.width / 2, _flutterBounds.height, 0);
        final williamPath = Path.from(_williamPath).transform(williamMatrix.storage);
        final flutterPath = Path.from(_flutterPath).transform(flutterMatrix.storage);
        return Stack(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: ShaderBuilder(
                assetKey: 'shaders/animated_neon_shader.glsl',
                (context, shader, child) => AnimatedSampler(
                  (image, size, canvas) {
                    shader
                      ..setFloat(0, size.width)
                      ..setFloat(1, size.height)
                      ..setImageSampler(0, image);

                    final paint = Paint()..shader = shader;
                    canvas.drawRect(
                      Rect.fromLTWH(0, 0, size.width, size.height),
                      paint,
                    );
                  },
                  child: child!,
                ),
                child: MorphWidget(
                  controller: _controller,
                  path1: williamPath,
                  path2: flutterPath,
                  painter: (p0) => MorphPainter(
                    p0,
                    Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Color.lerp(colorsWilliam[colorWilliam], colorFlutter, _controller.value) ?? Colors.white,
                  ),
                ),
              ),
            ),
            SafeArea(
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
          ],
        );
      },
    );
  }
}

class MorphPainter extends CustomPainter {
  final Path _path;
  final Paint _paint;

  MorphPainter(this._path, this._paint);

  @override
  void paint(Canvas canvas, Size size) => canvas
    ..translate(size.width / 2, size.height / 3)
    ..drawPath(_path, _paint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
