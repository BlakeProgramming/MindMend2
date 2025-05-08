import 'package:flutter/material.dart';

class ArtStudioApp extends StatelessWidget {
  const ArtStudioApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindMend - Art Studio',
      theme: ThemeData.dark(),
      home: const ArtCanvas(),
    );
  }
}


class ColoredPoint {
  final Offset? point;
  final Color color;
  final double strokeWidth;


  ColoredPoint(this.point, this.color, [this.strokeWidth = 5.0]);
}


class ArtCanvas extends StatefulWidget {
  const ArtCanvas({super.key});


  @override
  State<ArtCanvas> createState() => _ArtCanvasState();
}


class _ArtCanvasState extends State<ArtCanvas> {
  final GlobalKey _canvasKey = GlobalKey();


  // ignore: prefer_final_fields
  List<List<ColoredPoint>> _layers = [
    <ColoredPoint>[]
  ];
  int _currentLayerIndex = 0;
  List<ColoredPoint> get _points => _layers[_currentLayerIndex];


  // ignore: prefer_final_fields
  List<List<ColoredPoint>> _history = [];
  // ignore: prefer_final_fields
  List<List<ColoredPoint>> _redoStack = [];


  bool _isEraserEnabled = false;
  bool _isEyedropperEnabled = false;
  Offset? _eraserPosition;
  Offset? _hoverPosition;
  Color _hoverSampleColor = Colors.transparent;
  Color _currentColor = Colors.black;


  double _sliderValue1 = 0.20; // eraser size
  double _sliderValue2 = 0.10; // brush size
  bool _areSlidersVisible = true;


  double get brushSize => _sliderValue2 * 99 + 1;
  double get eraserSize => _sliderValue1 * 99 + 1;


  void _startNewStroke() {
    _redoStack.clear();
    _history.add(List.from(_points));
    _points.add(ColoredPoint(null, _currentColor, brushSize));
  }


  void _undo() {
    if (_history.isNotEmpty) {
      _redoStack.add(List.from(_points));
      setState(() => _layers[_currentLayerIndex] = _history.removeLast());
    }
  }


  void _redo() {
    if (_redoStack.isNotEmpty) {
      _history.add(List.from(_points));
      setState(() => _layers[_currentLayerIndex] = _redoStack.removeLast());
    }
  }
void _showLayersPopup() {
  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) {
        return AlertDialog(
          title: const Text('Layers'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show the layers with Move Up and Move Down functionality
                for (int i = 0; i < _layers.length; i++)
                  InkWell(
                    onTap: () {
                      setState(() => _currentLayerIndex = i);
                      setDialogState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(4),
                      color: i == _currentLayerIndex
                          ? Colors.blueGrey
                          : Colors.black54,
                      child: Row(
                        children: [
                          // Layer preview (assuming CustomPaint)
                         // Container(
                           // width: 50,
                            //height: 50,
                           // color: Colors.white,
                           // child: CustomPaint(
                             // painter: DrawingPainter(_layers[i]),
                             // size: Size.infinite,
                           // ),
                          //),
                          //const SizedBox(width: 8),
                          Text(
                            'Layer ${i + 1}', // Keeping the name unchanged
                            style: const TextStyle(color: Colors.white),
                          ),
                          if (i == _currentLayerIndex)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.check, color: Colors.green),
                            ),
                          // Move up button
                          IconButton(
                            icon: const Icon(Icons.arrow_upward),
                            onPressed: i > 0
                                ? () {
                                    setState(() {
                                      // Move the layer up in the list
                                      final layer = _layers.removeAt(i);
                                      _layers.insert(i - 1, layer);
                                      _currentLayerIndex = i - 1; // Update current layer index
                                    });
                                    setDialogState(() {});
                                  }
                                : null,
                          ),
                          // Move down button
                          IconButton(
                            icon: const Icon(Icons.arrow_downward),
                            onPressed: i < _layers.length - 1
                                ? () {
                                    setState(() {
                                      // Move the layer down in the list
                                      final layer = _layers.removeAt(i);
                                      _layers.insert(i + 1, layer);
                                      _currentLayerIndex = i + 1; // Update current layer index
                                    });
                                    setDialogState(() {});
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Add and Remove Layer buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Add a new empty layer
                          _layers.add(<ColoredPoint>[]);
                          _currentLayerIndex = _layers.length - 1;
                        });
                        setDialogState(() {});
                      },
                      child: const Text('Add Layer'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_layers.length > 1) {
                          setState(() {
                            _layers.removeLast();
                            _currentLayerIndex =
                                (_currentLayerIndex).clamp(0, _layers.length - 1);
                          });
                          setDialogState(() {});
                        }
                      },
                      child: const Text('Remove Layer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    ),
  );
}




  void _showEraserSettings() {
    showDialog(
      context: context,
      builder: (ctx) {
        bool tmp = _isEraserEnabled;
        return AlertDialog(
          title: const Text('Brush Settings'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Eraser:'),
              StatefulBuilder(builder: (c, setLocal) {
                return Switch(
                  value: tmp,
                  onChanged: (v) {
                    setLocal(() => tmp = v);
                    setState(() => _isEraserEnabled = v);
                  },
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Brush Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.orange,
                  Colors.purple,
                  Colors.pink,
                  Colors.brown,
                  Colors.grey,
                ].map((col) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentColor = col);
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      ),
    );
  }
  void _toggleEyedropper() {
    setState(() {
      _isEyedropperEnabled = !_isEyedropperEnabled;
      _hoverPosition = null;
    });
  }


  Color _getColorAtPosition(Offset pos) {
    for (var pt in _points.reversed) {
      if (pt.point != null && (pt.point! - pos).distance < brushSize) {
        return pt.color;
      }
    }
    return _currentColor;
  }


  void _eraseAt(Offset pos) {
    final radius = eraserSize / 2;
    List<ColoredPoint> updated = [];
    for (int i = 0; i < _points.length; i++) {
      final cp = _points[i];
      if (cp.point == null) {
        updated.add(cp);
      } else if ((cp.point! - pos).distance <= radius) {
        if (updated.isNotEmpty && updated.last.point != null) {
          updated.add(ColoredPoint(null, cp.color, cp.strokeWidth));
        }
        if (i + 1 < _points.length && _points[i + 1].point != null) {
          updated.add(ColoredPoint(null, cp.color, cp.strokeWidth));
        }
      } else {
        updated.add(cp);
      }
    }
    setState(() => _layers[_currentLayerIndex] = updated);
  }




  Widget _buildIconButton(
      IconData icon, String label, VoidCallback onTap) {
    return Column(
       mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(icon), iconSize: 20, onPressed: onTap),
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top bar
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("MindMend - Art Studio",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.settings,
                              color: Colors.white),
                          SizedBox(width: 16),
                          Icon(Icons.close,
                              color: Colors.white),
                        ],
                      )
                    ],
                  ),
                ),


                // Subtitle
                Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  child: const Text("Username - New Artwork",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey)),
                ),


                // Canvas with all layers painted in order
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1.75,
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        color: Colors.white,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            return MouseRegion(
                              cursor:
                                  _isEyedropperEnabled
                                      ? SystemMouseCursors.precise
                                      : MouseCursor.defer,
                              onHover: _isEyedropperEnabled
                                  ? (event) {
                                      final box = _canvasKey
                                          .currentContext!
                                          .findRenderObject()
                                      as RenderBox;
                                      final local = box.globalToLocal(
                                          event.position);
                                      if (local.dx >= 0 &&
                                          local.dy >= 0 &&
                                          local.dx <= constraints
                                              .maxWidth &&
                                          local.dy <= constraints
                                              .maxHeight) {
                                        setState(() {
                                          _hoverPosition = local;
                                          _hoverSampleColor =
                                              _getColorAtPosition(
                                                  local);
                                        });
                                      }
                                    }
                                  : null,
                              onExit: (_) {
                                if (_isEyedropperEnabled) {
                                  setState(
                                      () => _hoverPosition = null);
                                }
                              },
                              child: GestureDetector(
                                onPanStart: (d) {
                                  final box = _canvasKey
                                      .currentContext!
                                      .findRenderObject()
                                  as RenderBox;
                                  final local = box.globalToLocal(
                                      d.globalPosition);


                                  if (_isEyedropperEnabled) {
                                    setState(() {
                                      _currentColor =
                                          _getColorAtPosition(
                                              local);
                                      _isEyedropperEnabled =
                                          false;
                                      _hoverPosition = null;
                                    });
                                    return;
                                  }


                                  _startNewStroke();
                                  if (_isEraserEnabled) {
                                    _eraserPosition = local;
                                    _eraseAt(local);
                                  } else {
                                    _points.add(ColoredPoint(
                                        local,
                                        _currentColor,
                                        brushSize));
                                  }
                                  if (d.globalPosition.dy >
                                      h - 170) {
                                    _areSlidersVisible = false;
                                  }
                                  setState(() {});
                                },
                                onPanUpdate: (d) {
                                  final box = _canvasKey
                                      .currentContext!
                                      .findRenderObject()
                                  as RenderBox;
                                  final local = box.globalToLocal(
                                      d.globalPosition);
                                  if (local.dx < 0 ||
                                      local.dy < 0 ||
                                      local.dx >
                                          constraints.maxWidth ||
                                      local.dy >
                                          constraints.maxHeight) {
                                    return;
                                  }
                                  if (_isEraserEnabled) {
                                    _eraserPosition = local;
                                    _eraseAt(local);
                                  } else {
                                    _points.add(ColoredPoint(
                                        local,
                                        _currentColor,
                                        brushSize));
                                  }
                                  if (d.globalPosition.dy >
                                      h - 170) {
                                    _areSlidersVisible = false;
                                  }
                                  setState(() {});
                                },
                                onPanEnd: (_) {
                                  _points.add(ColoredPoint(
                                      null,
                                      _currentColor,
                                      brushSize));
                                  _eraserPosition = null;
                                  _areSlidersVisible = true;
                                  setState(() {});
                                },
                                child: Stack(
                                  key: _canvasKey,
                                  children: [
                                    // paint each layer in order
                                    for (var layer in _layers)
                                      CustomPaint(
                                        painter:
                                            DrawingPainter(layer),
                                        size: Size.infinite,
                                      ),


                                    // eraser preview
                                    if (_isEraserEnabled &&
                                        _eraserPosition != null)
                                      Positioned(
                                        left:
                                            _eraserPosition!.dx - 10,
                                        top:
                                            _eraserPosition!.dy - 10,
                                        child: Container(
                                          width: eraserSize,
                                          height: eraserSize,
                                          decoration:
                                              BoxDecoration(
                                            color: Colors.white,
                                            shape:
                                                BoxShape.circle,
                                            border: Border.all(
                                                color: Colors
                                                    .black,
                                                width: 2),
                                          ),
                                        ),
                                      ),


                                    // eyedropper preview
                                    if (_isEyedropperEnabled &&
                                        _hoverPosition != null)
                                      Positioned(
                                        left: _hoverPosition!
                                                .dx -
                                            12,
                                        top: _hoverPosition!
                                                .dy -
                                            12,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration:
                                              BoxDecoration(
                                            color:
                                                _hoverSampleColor,
                                            shape:
                                                BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),


                // Toolbar (unchanged)
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconButton(Icons.layers,
                          "Layers", _showLayersPopup),
                     // _buildIconButton(Icons.title,
                        //  "Title", () {}),
                     // _buildIconButton(Icons.download,
                         // "Download", () {}),
                      _buildIconButton(Icons.brush,
                          "Brush/Eraser",
                          _showEraserSettings),
                      _buildIconButton(Icons.palette,
                          "Palette",
                          _showColorPicker),
                      _buildIconButton(Icons.colorize,
                          "Colorize",
                          _toggleEyedropper),
                      _buildIconButton(Icons.undo,
                          "Undo", _undo),
                      _buildIconButton(Icons.redo,
                          "Redo", _redo),
                    ],
                  ),
                ),
              ],
            ),


            // Sliders overlay (unchanged)
            if (_areSlidersVisible)
              Positioned(
                top: MediaQuery.of(context)
                        .size
                        .height -
                    150,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                              'Eraser ${eraserSize.toInt()} px',
                              style: const TextStyle(
                                  color: Colors.deepPurple)),
                          const SizedBox(width: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor:
                                  Colors.deepPurple,
                              inactiveTrackColor:
                                  Colors.deepPurple,
                              thumbColor:
                                  Colors.deepPurple,
                              overlayColor:
                                  Colors.transparent,
                              trackHeight: 2,
                            ),
                            child: Slider(
                              value: _sliderValue1,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (v) =>
                                  setState(() =>
                                      _sliderValue1 = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          Text(
                              'Brush ${brushSize.toInt()} px',
                              style: const TextStyle(
                                  color: Colors.deepPurple)),
                          const SizedBox(width: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor:
                                  Colors.deepPurple,
                              inactiveTrackColor:
                                  Colors.deepPurple,
                              thumbColor:
                                  Colors.deepPurple,
                              overlayColor:
                                  Colors.transparent,
                              trackHeight: 2,
                            ),
                            child: Slider(
                              value: _sliderValue2,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (v) =>
                                  setState(() =>
                                      _sliderValue2 = v),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class DrawingPainter extends CustomPainter {
  final List<ColoredPoint> points;


  DrawingPainter(this.points);


  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].point != null &&
          points[i + 1].point != null) {
        final paint = Paint()
          ..color = points[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i].strokeWidth;
        canvas.drawLine(
            points[i].point!, points[i + 1].point!, paint);
      }
    }
  }


  @override
  bool shouldRepaint(DrawingPainter old) =>
      old.points != points;
}

