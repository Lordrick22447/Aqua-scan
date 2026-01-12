import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfGenerator {
  static Future<pw.Document> generateReport({
    required double area,
    required double rainfall,
    required double potential,
    required int tankSize,
    required double cycles,
  }) async {
    final pdf = pw.Document();
    final date = DateFormat.yMMMd().format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(date),
              pw.SizedBox(height: 32),
              _buildSummaryCard(area, rainfall, potential),
              pw.SizedBox(height: 24),
              _buildTankSection(tankSize, cycles),
              pw.SizedBox(height: 32),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('AQUA-SCAN', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
            pw.Text('Report Date: $date', style: const pw.TextStyle(color: PdfColors.grey)),
          ],
        ),
        pw.Divider(color: PdfColors.teal),
        pw.Text('Rainwater Harvesting Assessment', style: pw.TextStyle(fontSize: 18)),
      ],
    );
  }

  static pw.Widget _buildSummaryCard(double area, double rainfall, double potential) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Site Assessment Summary', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          _buildRow('Verified Roof Area', '${area.toStringAsFixed(1)} m²'),
          _buildRow('Annual Rainfall', '${rainfall.toInt()} mm'),
          pw.Divider(),
          _buildRow('Annual Water Potential', '${potential.toInt()} Liters', isBold: true),
        ],
      ),
    );
  }

  static pw.Widget _buildTankSection(int tankSize, double cycles) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Storage & Usage Analysis', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        pw.Text(
          'Based on the selected tank size of $tankSize Liters, your system will cycle approximately ${cycles.toInt()} times per year.',
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: PdfColors.teal50,
          child: pw.Text('Recommendation: Ensure a first-flush diverter is installed for water quality.'),
        ),
      ],
    );
  }

  static pw.Widget _buildRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(
            value,
            style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Verified by AQUA-SCAN Hybrid Technology', style: const pw.TextStyle(color: PdfColors.grey, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}
