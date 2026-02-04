import 'package:flutter/material.dart';

import '../../widgets/forecast_popup.dart';
import 'widgets/hero_section.dart';
import 'widgets/events_section.dart';
import 'widgets/academies_section.dart';
import 'widgets/consultations_section.dart';
import 'widgets/story_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/cta_section.dart';

/// Tracks whether the forecast popup has been shown this session (optional first-visit popup).
bool _forecastPopupShownThisSession = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowForecastPopup());
  }

  void _maybeShowForecastPopup() {
    if (_forecastPopupShownThisSession) return;
    if (!mounted) return;
    _forecastPopupShownThisSession = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => const ForecastPopup(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroSection(),
        EventsSection(),
        AcademiesSection(),
        ConsultationsSection(),
        StorySection(),
        TestimonialsSection(),
        CtaSection(),
      ],
    );
  }
}
