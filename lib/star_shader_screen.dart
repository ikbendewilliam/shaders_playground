import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class StarShaderScreen extends StatefulWidget {
  const StarShaderScreen({super.key});

  @override
  State<StarShaderScreen> createState() => _StarShaderScreenState();
}

class _StarShaderScreenState extends State<StarShaderScreen> {
  final _rotation = <double>[0, 0];
  final start = DateTime.now().millisecondsSinceEpoch / 1000;
  var now = DateTime.now().millisecondsSinceEpoch / 1000;
  late final Timer _timer;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 8),
      (timer) => setState(() {
        now = DateTime.now().millisecondsSinceEpoch / 1000;
      }),
    );
    _initSensors();
  }

  @override
  void dispose() {
    _timer.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _initSensors() async {
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.GYROSCOPE,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    _subscription = stream.listen((sensorEvent) {
      _rotation[0] += sensorEvent.data[0];
      _rotation[1] += sensorEvent.data[1];
      // No setstate, we update based on the timer
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/star_shader.glsl',
      (context, shader, child) => CustomPaint(
        size: MediaQuery.sizeOf(context),
        painter: ShaderPainter(
          shader: shader,
          rotation: _rotation,
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
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final List<double> rotation;
  final double secondsPassed;
  var index = 0;

  ShaderPainter({
    required this.shader,
    required this.rotation,
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
    _sendVec2ToShader(-Offset(rotation[1] * size.width, rotation[0] * size.height) / 1280);
    shader.setFloat(index++, secondsPassed);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
