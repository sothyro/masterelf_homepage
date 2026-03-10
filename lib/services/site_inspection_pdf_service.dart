import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Maps form field keys to display labels for PDF export.
const Map<String, String> _fieldLabels = {
  'inspectorName': 'Inspector Name',
  'inspectionDate': 'Date of Inspection',
  'timeOfArrival': 'Time of Arrival',
  'weatherConditions': 'Weather Conditions',
  'projectName': 'Project Name',
  'address': 'Address',
  'districtSangkat': 'District/Sangkat',
  'googleMapsLink': 'Google Maps Link',
  'projectType': 'Project Type',
  'projectTypeOther': 'Other (Project Type)',
  'constructionStatus': 'Construction Status',
  'estimatedCompletionYear': 'Estimated Completion Year',
  'numberOfFloors': 'Number of Floors',
  'numberOfUnits': 'Number of Units',
  'renovationDates': 'Previous renovation date(s)',
  'structuralChanges': 'Structural changes made',
  'renovationDetails': 'Renovation details',
  'constructionPhase': 'Current Construction Phase',
  'phaseDetails': 'Phase details',
  'frontageWidth': 'Frontage Width (m)',
  'depthLength': 'Depth/Length (m)',
  'totalSiteArea': 'Total Site Area (m²)',
  'unitWidth': 'Unit Width (m)',
  'unitDepth': 'Unit Depth (m)',
  'unitArea': 'Unit Area (m²)',
  'floorToCeilingHeight': 'Floor-to-ceiling Height (m)',
  'equipmentUsed': 'Equipment Used',
  'equipmentOther': 'Other equipment',
  'facingReading1': 'Facing Reading 1 (degrees)',
  'facingReading2': 'Facing Reading 2 (degrees)',
  'facingReading3': 'Facing Reading 3 (degrees)',
  'averageFacing': 'Average Facing (degrees)',
  'converted24Mountains': 'Converted to 24 Mountains',
  'facingCardinal': 'Facing Direction (Cardinal)',
  'sittingDirection': 'Sitting Direction',
  'magneticInterferenceNotes': 'Magnetic Interference Notes',
  'inspectorEmail': 'Inspector Email',
};

String _formatValue(dynamic value) {
  if (value == null) return '—';
  if (value is List) return value.join(', ');
  return value.toString().trim();
}

String _getLabel(String key) {
  final label = _fieldLabels[key];
  if (label != null) return label;
  return key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}').trim();
}

/// Generates a PDF document from site inspection form data.
Future<Uint8List> generateSiteInspectionPdf(Map<String, dynamic> formData) async {
  final pdf = pw.Document();
  final filledEntries = formData.entries
      .where((e) => e.key != 'createdAt' && e.key != 'updatedAt' && e.value != null && _formatValue(e.value).isNotEmpty)
      .toList();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'FENG SHUI GEOMANCY SITE INSPECTION FORM',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Commercial Housing Complex Assessment',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.Divider(thickness: 2, color: PdfColors.amber),
            ],
          ),
        ),
        pw.SizedBox(height: 16),
        ...filledEntries.map((e) {
          final label = _getLabel(e.key);
          final value = _formatValue(e.value);
          if (value.isEmpty) return pw.SizedBox.shrink();
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 180,
                  child: pw.Text(
                    label,
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    value,
                    style: const pw.TextStyle(fontSize: 10),
                    maxLines: 5,
                    overflow: pw.TextOverflow.clip,
                  ),
                ),
              ],
            ),
          );
        }),
        pw.SizedBox(height: 24),
        pw.Divider(color: PdfColors.grey400),
        pw.Center(
          child: pw.Text(
            '— End of Inspection Form —',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}

/// Saves the PDF and triggers download (web) or share (mobile).
Future<bool> saveSiteInspectionPdf(Uint8List bytes, String filename) async {
  return Printing.sharePdf(
    bytes: bytes,
    filename: filename,
  );
}
