import 'package:flutter/material.dart';
import 'package:aqua_scan/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading or check auth status
    Future.delayed(const Duration(seconds: 3), () {
      // TODO: Check auth status and navigate accordingly
      Navigator.of(context).pushReplacementNamed('/language');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.water_drop,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'AQUA-SCAN',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Engineering Grade Rainwater Assessment',
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}
