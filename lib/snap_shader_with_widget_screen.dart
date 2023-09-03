import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class SnapShaderWithWidgetScreen extends StatefulWidget {
  const SnapShaderWithWidgetScreen({
    super.key,
  });

  @override
  State<SnapShaderWithWidgetScreen> createState() => _SnapShaderWithWidgetScreenState();
}

class _SnapShaderWithWidgetScreenState extends State<SnapShaderWithWidgetScreen> {
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
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
              assetKey: 'shaders/snap_effect_shader.glsl',
              (context, shader, child) => AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setFloat(0, size.width)
                    ..setFloat(1, size.height)
                    ..setFloat(2, now - start)
                    ..setImageSampler(0, image);

                  final paint = Paint()..shader = shader;
                  canvas.drawRect(
                    Rect.fromLTWH(0, 0, size.width, size.height),
                    paint,
                  );
                },
                child: child!,
              ),
              child: Center(
                child: Text(
                  'Your name here...',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                      ),
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
      ),
    );
  }
}
