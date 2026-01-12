import 'package:flutter/material.dart';

import 'package:aqua_scan/core/theme/app_theme.dart';
import 'package:aqua_scan/features/splash/splash_screen.dart';
import 'package:aqua_scan/features/onboarding/language_selection_screen.dart';
import 'package:aqua_scan/features/auth/login_screen.dart';
import 'package:aqua_scan/features/dashboard/home_screen.dart';
import 'package:aqua_scan/features/measurement/screens/satellite_measure_screen.dart';
import 'package:aqua_scan/features/measurement/screens/ar_measure_screen.dart';
import 'package:aqua_scan/features/measurement/screens/measurement_result_screen.dart';
import 'package:aqua_scan/features/calculation/screens/calculation_result_screen.dart';
import 'package:aqua_scan/features/reporting/screens/report_preview_screen.dart';
import 'package:aqua_scan/features/extras/vendors_faq_screen.dart';
// import 'firebase_options.dart'; // User needs this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // Commented out Firebase init until user provides options
  
  runApp(const AquaScanApp());
}

class AquaScanApp extends StatelessWidget {
  const AquaScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQUA-SCAN',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/language': (context) => const LanguageSelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/satellite_measure': (context) => const SatelliteMeasureScreen(),
        '/ar_measure': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as double;
          return ARMeasureScreen(satelliteArea: args);
        },
        '/measurement_result': (context) => const MeasurementResultScreen(),
        '/calculation': (context) => const CalculationResultScreen(),
        '/report': (context) => const ReportPreviewScreen(),
        '/resources': (context) => const VendorsFaqScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
