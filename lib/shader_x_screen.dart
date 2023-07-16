import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shader/shader_x.dart';

class ShaderXScreen extends StatefulWidget {
  final String shaderName;

  const ShaderXScreen({super.key, required this.shaderName});

  @override
  State<ShaderXScreen> createState() => _ShaderXScreenState();
}

class _ShaderXScreenState extends State<ShaderXScreen> {
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
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: ShaderX(
              secondsPassed: now - start,
              shaderName: widget.shaderName,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                ),
                Text('Time passed: ${now - start}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
