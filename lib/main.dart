import 'package:flutter/material.dart';
import 'package:shader/animated_neon_shader_screen.dart';
import 'package:shader/animated_text_neon_shader_screen.dart';
import 'package:shader/neon_shader_screen.dart';
import 'package:shader/shader1_screen.dart';
import 'package:shader/shader_x_screen.dart';
import 'package:shader/snap_shader_screen.dart';
import 'package:shader/star_shader_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shaderz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Shader1Screen())),
                child: const Text('Shader 1'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShaderXScreen(shaderName: 'shader2'))),
                child: const Text('Shader 2'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShaderXScreen(shaderName: 'shader3'))),
                child: const Text('Shader 3'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StarShaderScreen())),
                child: const Text('STARS!'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NeonShaderScreen())),
                child: const Text('Neon?'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AnimatedNeonShaderScreen())),
                child: const Text('NeonWidget'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AnimatedTextNeonShaderScreen())),
                child: const Text('NeonWidgetText'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SnapShaderScreen())),
                child: const Text('Snap Effect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
