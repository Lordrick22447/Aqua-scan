
import 'package:flutter/material.dart';
import 'package:aqua_scan/core/theme/app_theme.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart'; // Uncomment for real AR
// import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARMeasureScreen extends StatefulWidget {
  final double satelliteArea;

  const ARMeasureScreen({super.key, required this.satelliteArea});

  @override
  State<ARMeasureScreen> createState() => _ARMeasureScreenState();
}

class _ARMeasureScreenState extends State<ARMeasureScreen> {
  // Mocking AR state for development stability
  final List<vector.Vector3> _points = [];
  double _calculatedArea = 0.0;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    // Simulate AR plane detection delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    });
  }

  // Simplified polygon area for 3D points projected to 2D (XZ plane for floor/roof)
  void _calculateArea() {
    if (_points.length < 3) {
      _calculatedArea = 0;
      return;
    }

    // Shoelace formula on XZ plane
    double area = 0.0;
    for (int i = 0; i < _points.length; i++) {
        int j = (i + 1) % _points.length;
        area += _points[i].x * _points[j].z;
        area -= _points[j].x * _points[i].z;
    }
    _calculatedArea = (area.abs() / 2.0);
  }

  void _addMockPoint() {
    // Adds a point in a roughly square shape for testing logic
    setState(() {
      if (_points.isEmpty) {
        _points.add(vector.Vector3(0, 0, 0));
      } else if (_points.length == 1) {
        _points.add(vector.Vector3(10, 0, 0)); // 10m
      } else if (_points.length == 2) {
        _points.add(vector.Vector3(10, 0, 10)); // 10x10
      } else if (_points.length == 3) {
        _points.add(vector.Vector3(0, 0, 10)); // Square
      }
      _calculateArea();
    });
  }

  void _finishMeasurement() {
    if (_calculatedArea <= 0) {
      // If user skipped AR or failed, maybe we just trust satellite or ask to retry
      // For this flow, let's assume valid mock if empty
      if (_points.isEmpty) {
        // Mock a value close to satellite for happy path demonstration
        _calculatedArea = widget.satelliteArea * 1.05; // 5% diff
      }
    }

    Navigator.pushNamed(
      context,
      '/measurement_result',
      arguments: {
        'satellite': widget.satelliteArea,
        'ar': _calculatedArea,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 2: AR Validation')),
      body: Stack(
        children: [
          // Camera View Placeholder
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, color: Colors.white54, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    _isScanning ? 'Detecting Surfaces...' : 'Tap to place corner points',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  if (!_isScanning)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: _addMockPoint,
                        child: const Text('SIMULATE PLACING POINT (+Point)'),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // HUD
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Satellite Area:'),
                          Text('${widget.satelliteArea.toStringAsFixed(2)} m²',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('AR Area:'),
                          Text('${_calculatedArea.toStringAsFixed(2)} m²',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentColor,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _finishMeasurement,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('FINISH & VERIFY'),
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
