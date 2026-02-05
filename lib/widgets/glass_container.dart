import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Frosted glass panel: blur + semi-transparent fill + optional border and shadow.
/// Use for header, drawer, dialogs, sticky CTA, and dropdowns.
///
/// On narrow viewports (< 600px), blur is reduced (sigma 6) for better performance
/// on low-end devices; override [blurSigma] if a different fallback is needed.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blurSigma = 10,
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final double blurSigma;
  final Color? color;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  static const double _reducedBlurSigma = 6.0;
  static const double _narrowViewportWidth = 600.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final effectiveSigma = width < _narrowViewportWidth ? _reducedBlurSigma : blurSigma;
    final effectiveColor = color ??
        AppColors.overlayDark.withValues(alpha: 0.85);
    final effectiveBorder = border ??
        Border.all(color: AppColors.borderLight, width: 1);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    return ClipRRect(
      borderRadius: effectiveRadius,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveSigma, sigmaY: effectiveSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: effectiveRadius,
            border: effectiveBorder,
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
