import 'package:flutter/material.dart';

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

/// Number of below-the-fold sections (Events, Academies, ..., CTA).
const int _kBelowFoldSectionCount = 6;

/// Builds the hero immediately, then reveals one section per frame so no single
/// frame does all the work and the UI stays responsive (no freeze).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// How many below-the-fold sections to show (0..6). Revealed one per frame.
  int _visibleSectionCount = 0;

  void _scheduleNextSection() {
    if (_visibleSectionCount >= _kBelowFoldSectionCount || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visibleSectionCount++);
      _scheduleNextSection();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _visibleSectionCount = 1);
        _scheduleNextSection();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HeroSection(),
        _visibleSectionCount > 0
            ? const EventsSection()
            : const SizedBox(height: _placeholderEvents),
        _visibleSectionCount > 1
            ? const AcademiesSection()
            : const SizedBox(height: _placeholderAcademies),
        _visibleSectionCount > 2
            ? const ConsultationsSection()
            : const SizedBox(height: _placeholderConsultations),
        _visibleSectionCount > 3
            ? const StorySection()
            : const SizedBox(height: _placeholderStory),
        _visibleSectionCount > 4
            ? const TestimonialsSection()
            : const SizedBox(height: _placeholderTestimonials),
        _visibleSectionCount > 5
            ? const CtaSection()
            : const SizedBox(height: _placeholderCta),
      ],
    );
  }
}
