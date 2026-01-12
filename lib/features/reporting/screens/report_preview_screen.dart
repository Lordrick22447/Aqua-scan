import 'package:flutter/material.dart';
import 'package:aqua_scan/features/reporting/services/pdf_generator.dart';
import 'package:printing/printing.dart';

class ReportPreviewScreen extends StatelessWidget {
  const ReportPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Assessment Report')),
      body: PdfPreview(
        build: (format) => PdfGenerator.generateReport(
          area: args['area'],
          rainfall: args['rainfall'],
          potential: args['potential'],
          tankSize: args['tankSize'],
          cycles: args['cycles'],
        ).then((doc) => doc.save()),
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }
}
