import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shader/shader1.dart';

class Shader1Screen extends StatefulWidget {
  const Shader1Screen({super.key});

  @override
  State<Shader1Screen> createState() => _Shader1ScreenState();
}

class _Shader1ScreenState extends State<Shader1Screen> {
  final _translation = <double>[0, 0];
  final _rotation = <double>[1, 0, 0];
  final _random = Random();
  double _noiseWeight = 0.5;
  late int _colorIndex1;
  late int _colorIndex2;
  late int _colorIndex3;
  late int _colorIndex4;
  ui.Image? _selectedImage;
  ui.Image? _image0;
  ui.Image? _image1;
  ui.Image? _image2;

  @override
  void initState() {
    super.initState();
    _randomizeColors();
    getImage('images/noise0.png').then(
      (value) => setState(() {
        _image0 = value;
        _selectedImage = _image0;
      }),
    );
    getImage('images/noise1.png').then(
      (value) => setState(() {
        _image1 = value;
      }),
    );
    getImage('images/noise2.png').then(
      (value) => setState(() {
        _image2 = value;
      }),
    );
  }

  void _randomizeColors() {
    _colorIndex1 = _random.nextInt(Colors.primaries.length);
    _colorIndex2 = _random.nextInt(Colors.primaries.length);
    _colorIndex3 = _random.nextInt(Colors.primaries.length);
    _colorIndex4 = _random.nextInt(Colors.primaries.length);
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
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: _selectedImage == null
                ? const Center(child: CircularProgressIndicator())
                : Shader1(
                    translation: _translation,
                    rotation: _rotation,
                    colorIndex1: _colorIndex1,
                    colorIndex2: _colorIndex2,
                    colorIndex3: _colorIndex3,
                    colorIndex4: _colorIndex4,
                    noiseWeight: _noiseWeight,
                    noiseMap: _selectedImage!,
                  ),
          ),
          Expanded(
            child: ListView(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back'),
                ),
                const Text('Translate X'),
                Slider(
                  onChanged: (value) => setState(() {
                    _translation[0] = value;
                  }),
                  value: _translation[0],
                  min: -1,
                ),
                const Text('Translate Y'),
                Slider(
                  onChanged: (value) => setState(() {
                    _translation[1] = value;
                  }),
                  value: _translation[1],
                  min: -1,
                ),
                const Text('Rotation Y'),
                Slider(
                  onChanged: (value) => setState(() {
                    _rotation[1] = value;
                  }),
                  value: _rotation[1],
                  min: -1,
                ),
                const Text('Rotation Z'),
                Slider(
                  onChanged: (value) => setState(() {
                    _rotation[2] = value;
                  }),
                  value: _rotation[2],
                  min: -1,
                ),
                const Text('Noise weight'),
                Slider(
                  onChanged: (value) => setState(() {
                    _noiseWeight = value;
                  }),
                  value: _noiseWeight,
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _randomizeColors();
                  }),
                  child: const Text('Randomize colors'),
                ),
                if (_image0 != null)
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _selectedImage = _image0;
                    }),
                    child: RawImage(
                      image: _image0,
                    ),
                  ),
                if (_image1 != null)
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _selectedImage = _image1;
                    }),
                    child: RawImage(
                      image: _image1,
                    ),
                  ),
                if (_image2 != null)
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _selectedImage = _image2;
                    }),
                    child: RawImage(
                      image: _image2,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
