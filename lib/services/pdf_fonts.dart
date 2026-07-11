import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Loads and caches Google Fonts for PDF export (Latin, Khmer, Chinese).
class PdfExportFonts {
  PdfExportFonts._();

  static pw.Font? _exo2Regular;
  static pw.Font? _exo2Bold;
  static pw.Font? _siemreap;
  static pw.Font? _notoSansSc;
  static Future<void>? _loadFuture;

  /// Fetches fonts once; safe to call multiple times.
  static Future<void> ensureLoaded() {
    return _loadFuture ??= _load();
  }

  static Future<void> _load() async {
    final results = await Future.wait([
      PdfGoogleFonts.exo2Regular(),
      PdfGoogleFonts.exo2Bold(),
      PdfGoogleFonts.siemreapRegular(),
      PdfGoogleFonts.notoSansSCRegular(),
    ]);
    _exo2Regular = results[0];
    _exo2Bold = results[1];
    _siemreap = results[2];
    _notoSansSc = results[3];
  }

  static List<pw.Font> get scriptFallbacks {
    if (_siemreap == null || _notoSansSc == null) {
      throw StateError('Call PdfExportFonts.ensureLoaded() before building PDFs');
    }
    return [_siemreap!, _notoSansSc!];
  }

  static pw.ThemeData appointmentListTheme() {
    if (_exo2Regular == null || _exo2Bold == null) {
      throw StateError('Call PdfExportFonts.ensureLoaded() before building PDFs');
    }
    return pw.ThemeData.withFont(
      base: _exo2Regular,
      bold: _exo2Bold,
      fontFallback: scriptFallbacks,
    );
  }

  static pw.TextStyle textStyle({
    double? fontSize,
    pw.FontWeight? fontWeight,
    PdfColor? color,
  }) {
    return pw.TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFallback: scriptFallbacks,
    );
  }
}
