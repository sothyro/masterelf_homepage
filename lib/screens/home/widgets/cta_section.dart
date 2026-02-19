import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class CtaSection extends StatefulWidget {
  const CtaSection({super.key});

  @override
  State<CtaSection> createState() => _CtaSectionState();
}

class _CtaSectionState extends State<CtaSection> with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 1100);
  static const _curve = Curves.easeOutCubic;
  static const _slideOffset = 24.0;

  late final AnimationController _controller;
  late final Animation<double> _headingOpacity;
  late final Animation<double> _headingSlide;
  late final Animation<double> _bodyOpacity;
  late final Animation<double> _bodySlide;
  late final Animation<double> _buttonOpacity;
  late final Animation<double> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _headingOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.35, curve: _curve),
      ),
    );
    _headingSlide = Tween<double>(begin: _slideOffset, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.35, curve: _curve),
      ),
    );
    _bodyOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.52, curve: _curve),
      ),
    );
    _bodySlide = Tween<double>(begin: _slideOffset, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.52, curve: _curve),
      ),
    );
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.72, curve: _curve),
      ),
    );
    _buttonSlide = Tween<double>(begin: _slideOffset, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.72, curve: _curve),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final paddingV = isMobile ? 40.0 : 56.0;
    final paddingH = isMobile ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundDark,
            AppColors.primary,
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _headingOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _headingSlide.value),
                    child: child,
                  ),
                );
              },
              child: Text(
                l10n.finalCtaHeading,
                style: (textTheme.headlineMedium ?? textTheme.headlineSmall)?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 24 : 32,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _bodyOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _bodySlide.value),
                    child: child,
                  ),
                );
              },
              child: Text(
                l10n.finalCtaBody,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                  height: 1.5,
                  fontSize: isMobile ? 16 : 19,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _buttonOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _buttonSlide.value),
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: AppShadows.accentButton,
                ),
                child: FilledButton(
                  onPressed: () => context.push('/contact'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(l10n.contactUs),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
