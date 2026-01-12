import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aqua_scan/core/theme/app_theme.dart';
import 'package:aqua_scan/features/measurement/services/area_calculator.dart';
import 'package:geolocator/geolocator.dart';

class SatelliteMeasureScreen extends StatefulWidget {
  const SatelliteMeasureScreen({super.key});

  @override
  State<SatelliteMeasureScreen> createState() => _SatelliteMeasureScreenState();
}

class _SatelliteMeasureScreenState extends State<SatelliteMeasureScreen> {
  GoogleMapController? _mapController;
  final List<LatLng> _polygonPoints = [];
  final Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  double _calculatedArea = 0.0;
  bool _isLoading = true;

  // Default to a known location (e.g., Trivandrum, Kerala) if GPS fails
  static const CameraPosition _kDefaultLocation = CameraPosition(
    target: LatLng(8.5241, 76.9366),
    zoom: 18,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() => _isLoading = false);
    
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        ),
      ),
    );
  }

  void _onMapTap(LatLng point) {
    setState(() {
      _polygonPoints.add(point);
      _markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
      _updatePolygon();
    });
  }

  void _undoLastPoint() {
    if (_polygonPoints.isNotEmpty) {
      setState(() {
        LatLng last = _polygonPoints.removeLast();
        _markers.removeWhere((m) => m.position == last);
        _updatePolygon();
      });
    }
  }

  void _updatePolygon() {
    if (_polygonPoints.isEmpty) {
      _polygons = {};
      _calculatedArea = 0;
      return;
    }

    _polygons = {
      Polygon(
        polygonId: const PolygonId('roof'),
        points: _polygonPoints,
        strokeWidth: 2,
        strokeColor: AppTheme.accentColor,
        fillColor: AppTheme.accentColor.withValues(alpha: 0.3),
      ),
    };
    
    if (_polygonPoints.length >= 3) {
      _calculatedArea = AreaCalculator.calculateArea(_polygonPoints);
    } else {
      _calculatedArea = 0;
    }
  }

  void _reset() {
    setState(() {
      _polygonPoints.clear();
      _markers.clear();
      _polygons.clear();
      _calculatedArea = 0;
    });
  }

  void _confirmArea() {
    if (_calculatedArea <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please draw a valid closed shape first.')),
      );
      return;
    }
    // Navigate to AR Validation, passing the satellite area
    Navigator.pushNamed(
      context, 
      '/ar_measure',
      arguments: _calculatedArea,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1: Satellite Measure'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reset),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kDefaultLocation,
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTap,
            markers: _markers,
            polygons: _polygons,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          
          // HUD for Area
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white.withValues(alpha: 0.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Roof Area:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      AreaCalculator.formatArea(_calculatedArea),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_polygonPoints.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FloatingActionButton(
                        onPressed: _undoLastPoint,
                        mini: true,
                        backgroundColor: Colors.grey[700],
                        child: const Icon(Icons.undo, color: Colors.white),
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _polygonPoints.length >= 3 ? _confirmArea : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('CONFIRM AREA & PROCEED TO AR', style: TextStyle(fontSize: 16)),
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
