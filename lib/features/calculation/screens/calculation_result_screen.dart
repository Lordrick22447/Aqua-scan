import 'package:flutter/material.dart';
import 'package:aqua_scan/core/theme/app_theme.dart';
import 'package:aqua_scan/features/calculation/services/rainfall_service.dart';
import 'package:aqua_scan/features/calculation/services/water_calculator.dart';

class CalculationResultScreen extends StatefulWidget {
  const CalculationResultScreen({super.key});

  @override
  State<CalculationResultScreen> createState() => _CalculationResultScreenState();
}

class _CalculationResultScreenState extends State<CalculationResultScreen> {
  final _rainfallService = RainfallService();
  
  double _roofArea = 0.0;
  double _rainfall = 0.0;
  double _potential = 0.0;
  bool _isLoading = true;
  int _selectedTankSize = 2000;
  int _recommendedTank = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_roofArea == 0.0) {
      _roofArea = ModalRoute.of(context)!.settings.arguments as double;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    // In real app, pass lat/long. Here we mock/default.
    _rainfall = await _rainfallService.getAnnualRainfall(8.5, 76.9); 
    _potential = WaterCalculator.calculatePotential(_roofArea, _rainfall);
    _recommendedTank = WaterCalculator.recommendTankSize(_potential);
    
    // Auto-select recommended if reasonably close? Or just default
    // Let's set selected to recommended for better UX
    if (WaterCalculator.standardTankSizes.contains(_recommendedTank)) {
      _selectedTankSize = _recommendedTank;
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    double cycles = WaterCalculator.calculateCycles(_potential, _selectedTankSize);

    return Scaffold(
      appBar: AppBar(title: const Text('Water Potential')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                      context, 'Roof Area', '${_roofArea.toStringAsFixed(1)} m²', Icons.roofing),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                      context, 'Rainfall', '${_rainfall.toInt()} mm', Icons.cloud),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: AppTheme.secondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Annual Harvest Potential', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(
                      '${_potential.toInt()} Liters',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            Text('Tank Configuration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            
            // Tank Selector
            DropdownButtonFormField<int>(
              // ignore: deprecated_member_use
              value: _selectedTankSize,
              decoration: const InputDecoration(
                labelText: 'Select Tank Size',
                border: OutlineInputBorder(),
              ),
              items: WaterCalculator.standardTankSizes.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text('$size Liters'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTankSize = val);
              },
            ),

            const SizedBox(height: 24),
            
            // Insight Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50], // Light blue
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: AppTheme.secondaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your roof can fill a $_selectedTankSize L tank approximately ${cycles.toInt()} times per year.',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  if (_recommendedTank > 0 && _selectedTankSize != _recommendedTank)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        '💡 Recommended: $_recommendedTank L for optimal efficiency.',
                        style: TextStyle(color: Colors.grey[800], fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/report',
                  arguments: {
                    'area': _roofArea,
                    'rainfall': _rainfall,
                    'potential': _potential,
                    'tankSize': _selectedTankSize,
                    'cycles': cycles,
                  },
                );
              },
              child: const Text('GENERATE REPORT'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
