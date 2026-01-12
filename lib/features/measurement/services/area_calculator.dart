import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class AreaCalculator {
  static double calculateArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    final List<mp.LatLng> mpPoints = points
        .map((p) => mp.LatLng(p.latitude, p.longitude))
        .toList();

    // Calculate area in square meters
    return mp.SphericalUtil.computeArea(mpPoints).toDouble();
  }

  static String formatArea(double area) {
    return '${area.toStringAsFixed(2)} m²';
  }
}
