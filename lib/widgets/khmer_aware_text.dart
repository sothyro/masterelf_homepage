import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/khmer_script.dart';

/// Renders [data] with Siem Reap for Khmer script when the app locale is not Khmer.
///
/// [fontFamilyFallback] is unreliable with Google Fonts on web, so Khmer runes get
/// an explicit [GoogleFonts.siemreap] style while Latin/other text keeps [style].
class KhmerAwareText extends StatelessWidget {
  const KhmerAwareText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyMedium!;

    if (!containsKhmerScript(data)) {
      return Text(
        data,
        style: base,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'km') {
      return Text(
        data,
        style: base,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    final khmerStyle = siemreapTextStyle(base);
    final spans = buildMixedScriptSpans(
      data,
      latinStyle: base,
      khmerStyle: khmerStyle,
    );

    if (spans.length == 1) {
      return Text(
        data,
        style: spans.first.style ?? khmerStyle,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: textAlign,
    );
  }
}

/// Siem Reap style mirroring [base] size/weight/color.
TextStyle siemreapTextStyle(TextStyle base) {
  return GoogleFonts.siemreap(
    fontSize: base.fontSize,
    fontWeight: base.fontWeight,
    color: base.color,
    height: base.height,
    letterSpacing: 0,
    decoration: base.decoration,
    decorationColor: base.decorationColor,
  );
}
