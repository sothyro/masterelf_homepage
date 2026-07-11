import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Rich text with a highlighted phrase (store pages).
class DescriptionWithHighlight extends StatelessWidget {
  const DescriptionWithHighlight({
    super.key,
    required this.description,
    required this.highlightPhrase,
    this.textAlign = TextAlign.center,
    this.baseColor,
  });

  final String description;
  final String highlightPhrase;
  final TextAlign textAlign;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = (Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: baseColor ?? AppColors.onSurfaceVariantDark,
              height: 1.5,
            ) ??
        TextStyle(
          fontSize: 16,
          color: baseColor ?? AppColors.onSurfaceVariantDark,
          height: 1.5,
        ));
    final highlightStyle = highlightStyleForLocale(
      context,
      color: baseColor != null ? AppColors.accentLight : AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: (bodyStyle.fontSize ?? 16) * 1.45,
    );
    final span = textSpanWithHighlight(
      description,
      highlightPhrase,
      bodyStyle,
      highlightStyle,
    );
    return RichText(text: span, textAlign: textAlign);
  }
}

InlineSpan textSpanWithHighlight(
  String text,
  String highlight,
  TextStyle base,
  TextStyle highlightStyle,
) {
  if (highlight.isEmpty) return TextSpan(text: text, style: base);
  final i = text.toLowerCase().indexOf(highlight.toLowerCase());
  if (i < 0) return TextSpan(text: text, style: base);
  return TextSpan(
    children: [
      if (i > 0) TextSpan(text: text.substring(0, i), style: base),
      TextSpan(text: text.substring(i, i + highlight.length), style: highlightStyle),
      if (i + highlight.length < text.length)
        TextSpan(text: text.substring(i + highlight.length), style: base),
    ],
  );
}
