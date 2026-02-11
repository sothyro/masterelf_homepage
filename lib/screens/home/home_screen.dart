import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/app_theme.dart';
import 'widgets/hero_section.dart';
import 'widgets/events_section.dart';
import 'widgets/academies_section.dart';
import 'widgets/consultations_section.dart';
import 'widgets/story_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/cta_section.dart';

/// Placeholder heights so scroll extent is correct before below-the-fold sections build.
const double _placeholderEvents = 520;
const double _placeholderAcademies = 820;
const double _placeholderConsultations = 520;
const double _placeholderStory = 580;
const double _placeholderTestimonials = 480;
const double _placeholderCta = 360;

/// Number of below-the-fold sections (Events, Academies, …, CTA).
const int _kBelowFoldSectionCount = 6;

/// Delay between revealing each section so the main thread can paint and the hero
/// video keeps playing smoothly instead of freezing.
const Duration _sectionRevealDelay = Duration(milliseconds: 220);

/// Builds the hero immediately, then reveals sections one at a time with a short
/// delay between each so the UI stays responsive. Shows a popup progress overlay
/// (same style as initial loading) while sections load so the site doesn’t feel frozen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _visibleSectionCount = 0;
  OverlayEntry? _overlayEntry;

  void _scheduleNextSection() {
    if (_visibleSectionCount >= _kBelowFoldSectionCount || !mounted) return;
    Future<void>.delayed(_sectionRevealDelay, () {
      if (!mounted) return;
      // Run setState at the start of the next frame to avoid freezing mid-frame.
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (!mounted) return;
        setState(() => _visibleSectionCount++);
        _overlayEntry?.markNeedsBuild();
        if (_visibleSectionCount >= _kBelowFoldSectionCount) {
          _removeOverlay();
        }
        _scheduleNextSection();
      });
    });
  }

  void _insertOverlay() {
    if (_overlayEntry != null || !mounted) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => _SectionLoadingOverlay(
        sectionIndex: _visibleSectionCount,
        totalSections: _kBelowFoldSectionCount,
      ),
    );
    // Use root overlay so the popup appears above header and all content.
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    // Show overlay first so the user sees it before any section building starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _insertOverlay();
      _overlayEntry?.markNeedsBuild();
      // Start building sections after a short delay so the overlay is visible first.
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        setState(() => _visibleSectionCount = 1);
        _overlayEntry?.markNeedsBuild();
        _scheduleNextSection();
      });
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RepaintBoundary(child: HeroSection()),
        RepaintBoundary(
          child: _visibleSectionCount > 0
              ? const EventsSection()
              : const SizedBox(height: _placeholderEvents),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 1
              ? const AcademiesSection()
              : const SizedBox(height: _placeholderAcademies),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 2
              ? const ConsultationsSection()
              : const SizedBox(height: _placeholderConsultations),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 3
              ? const StorySection()
              : const SizedBox(height: _placeholderStory),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 4
              ? const TestimonialsSection()
              : const SizedBox(height: _placeholderTestimonials),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 5
              ? const CtaSection()
              : const SizedBox(height: _placeholderCta),
        ),
      ],
    );
  }
}

/// Popup overlay shown while below-the-fold sections load; matches initial loading screen style.
/// Uses an indeterminate (spinning) progress so it's always clearly visible.
class _SectionLoadingOverlay extends StatelessWidget {
  const _SectionLoadingOverlay({
    required this.sectionIndex,
    required this.totalSections,
  });

  final int sectionIndex;
  final int totalSections;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withValues(alpha: 0.5),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.dialog,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                      backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Preparing content…',
                    style: TextStyle(
                      color: AppColors.accent.withValues(alpha: 0.95),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$sectionIndex / $totalSections sections',
                    style: TextStyle(
                      color: AppColors.accent.withValues(alpha: 0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
