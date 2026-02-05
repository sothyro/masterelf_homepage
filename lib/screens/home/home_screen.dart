import 'package:flutter/material.dart';

import 'widgets/hero_section.dart';
import 'widgets/events_section.dart';
import 'widgets/academies_section.dart';
import 'widgets/consultations_section.dart';
import 'widgets/story_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/cta_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
