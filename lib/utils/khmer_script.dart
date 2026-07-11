import 'package:flutter/material.dart';

/// Khmer Unicode block (U+1780–U+17FF) and Khmer symbols (U+19E0–U+19FF).
bool isKhmerRune(int codePoint) {
  return (codePoint >= 0x1780 && codePoint <= 0x17FF) ||
      (codePoint >= 0x19E0 && codePoint <= 0x19FF);
}
/// Khmer Unicode block (U+1780–U+17FF) and Khmer symbols (U+19E0–U+19FF).
bool containsKhmerScript(String text) {
  for (final codePoint in text.runes) {
    if (isKhmerRune(codePoint)) return true;
  }
  return false;
}

/// Splits [text] into spans so Khmer runes use [khmerStyle] and other text uses [latinStyle].
List<InlineSpan> buildMixedScriptSpans(
  String text, {
  required TextStyle latinStyle,
  required TextStyle khmerStyle,
}) {
  if (text.isEmpty) {
    return [TextSpan(text: '', style: latinStyle)];
  }

  final spans = <InlineSpan>[];
  final buffer = StringBuffer();
  bool? isKhmer;

  void flush() {
    if (buffer.isEmpty) return;
    spans.add(TextSpan(
      text: buffer.toString(),
      style: isKhmer == true ? khmerStyle : latinStyle,
    ));
    buffer.clear();
  }

  for (final rune in text.runes) {
    final kh = isKhmerRune(rune);
    if (isKhmer != null && kh != isKhmer) flush();
    isKhmer = kh;
    buffer.writeCharCode(rune);
  }
  flush();
  return spans;
}
