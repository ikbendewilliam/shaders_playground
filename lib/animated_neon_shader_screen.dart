import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatedNeonShaderScreen extends StatefulWidget {
  const AnimatedNeonShaderScreen({super.key});

  @override
  State<AnimatedNeonShaderScreen> createState() => _AnimatedNeonShaderScreenState();
}

class _AnimatedNeonShaderScreenState extends State<AnimatedNeonShaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderBuilder(
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
          child: const AnimatedContainerApp(),
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
  }
}

class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);
  double _borderWidth = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedContainer(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: _borderRadius,
            border: Border.all(
              color: _color,
              width: _borderWidth,
            ),
          ),
          // Define how long the animation should take.
          duration: const Duration(seconds: 1),
          // Provide an optional curve to make the animation feel smoother.
          curve: Curves.fastOutSlowIn,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user taps the button
        onPressed: () {
          // Use setState to rebuild the widget with new values.
          setState(() {
            // Create a random number generator.
            final random = Random();

            // Generate a random width and height.
            _width = (random.nextInt(300) + 50).toDouble();
            _height = (random.nextInt(300) + 50).toDouble();
            _borderWidth = (random.nextInt(32) + 4).toDouble();

            // Generate a random color.
            _color = Color.fromRGBO(
              random.nextInt(256),
              random.nextInt(256),
              random.nextInt(256),
              1,
            );

            // Generate a random border radius.
            _borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
