import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/appointment.dart';
import 'pdf_fonts.dart';

/// Column headers and title for the appointments list PDF.
class AppointmentListPdfLabels {
  const AppointmentListPdfLabels({
    required this.title,
    required this.ref,
    required this.name,
    required this.phone,
    required this.service,
    required this.dateTime,
    required this.status,
    required this.generatedOn,
  });

  final String title;
  final String ref;
  final String name;
  final String phone;
  final String service;
  final String dateTime;
  final String status;
  final String generatedOn;
}

/// Generates a PDF table of [appointments].
Future<Uint8List> generateAppointmentsListPdf({
  required List<AdminAppointmentRecord> appointments,
  required AppointmentListPdfLabels labels,
  required String Function(AdminAppointmentRecord record) statusLabel,
  required String Function(String serviceName) displayServiceName,
}) async {
  await PdfExportFonts.ensureLoaded();
  final theme = PdfExportFonts.appointmentListTheme();

  pw.Widget cell(String text, {bool header = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: pw.Text(
        text,
        style: PdfExportFonts.textStyle(
          fontSize: header ? 8 : 7,
          fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        maxLines: 3,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }

  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(24),
      theme: theme,
      build: (context) => [
        pw.Text(
          labels.title,
          style: PdfExportFonts.textStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          labels.generatedOn,
          style: PdfExportFonts.textStyle(
            fontSize: 9,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.4),
          columnWidths: const {
            0: pw.FlexColumnWidth(1.1),
            1: pw.FlexColumnWidth(1.4),
            2: pw.FlexColumnWidth(1.2),
            3: pw.FlexColumnWidth(2),
            4: pw.FlexColumnWidth(1.3),
            5: pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                cell(labels.ref, header: true),
                cell(labels.name, header: true),
                cell(labels.phone, header: true),
                cell(labels.service, header: true),
                cell(labels.dateTime, header: true),
                cell(labels.status, header: true),
              ],
            ),
            ...appointments.map(
              (a) => pw.TableRow(
                children: [
                  cell(a.bookingReference),
                  cell(a.name),
                  cell(a.phone),
                  cell(displayServiceName(a.serviceName)),
                  cell('${a.date} ${a.time}'),
                  cell(statusLabel(a)),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return pdf.save();
}

/// Saves the PDF and triggers download (web) or share (mobile).
Future<bool> saveAppointmentsListPdf(Uint8List bytes, String filename) {
  return Printing.sharePdf(bytes: bytes, filename: filename);
}
