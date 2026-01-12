import 'package:flutter/material.dart';


class MeasurementResultScreen extends StatelessWidget {
  const MeasurementResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final double satelliteArea = args['satellite'];
    final double arArea = args['ar'];

    // Error Correction Logic
    final double difference = (satelliteArea - arArea).abs();
    final double averageArea = (satelliteArea + arArea) / 2;
    final double diffPercentage = (difference / averageArea) * 100;
    final bool isVerified = diffPercentage <= 10.0;
    
    // If verified, use average. If not, maybe stick to average but warn?
    // Prompt says: "If diff <= 10%, final = avg. Else: Warn."
    final double finalArea = averageArea;

    return Scaffold(
      appBar: AppBar(title: const Text('Measurement Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildComparisonCard(context, satelliteArea, arArea, diffPercentage),
            const SizedBox(height: 24),
            
            if (isVerified)
              _buildVerifiedStatus(context, finalArea)
            else
              _buildWarningStatus(context, diffPercentage),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to Water Calculation
                Navigator.pushNamed(
                  context, 
                  '/calculation',
                  arguments: finalArea,
                );
              },
              child: const Text('PROCEED TO WATER CALCULATION'),
            ),
            if (!isVerified)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextButton.icon(
                  onPressed: () {
                    // Go back to start
                    Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('RE-MEASURE'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(BuildContext context, double sat, double ar, double diff) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Dual Verification Result', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildValueCol(context, 'Satellite', sat),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                _buildValueCol(context, 'AR Scan', ar),
              ],
            ),
            const Divider(height: 32),
            Text(
              'Difference: ${diff.toStringAsFixed(1)}%',
              style: TextStyle(
                color: diff <= 10 ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCol(BuildContext context, String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)} m²',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedStatus(BuildContext context, double finalArea) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text(
            'Verified Accurate',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('Measurements are within acceptable tolerance.'),
          const SizedBox(height: 24),
          const Text('FINAL TRUSTED AREA', style: TextStyle(color: Colors.green)),
          Text(
            '${finalArea.toStringAsFixed(1)} m²',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningStatus(BuildContext context, double diff) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            'High Variance Detected',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.orange[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The measurements differ significantly (>10%).\nWe recommend re-measuring for engineering-grade accuracy.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
