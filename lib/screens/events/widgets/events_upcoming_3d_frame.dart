import 'package:flutter/material.dart';

import '../../../widgets/majestic_orbital_card_frame.dart';

/// Events-page spotlight uses wider satellite orbits than the homepage default.
const double kEventsUpcomingOrbitExtentScale = 1.24;

/// Event-page wrapper around the shared [MajesticOrbitalCardFrame].
class EventsUpcoming3DFrame extends StatelessWidget {
  const EventsUpcoming3DFrame({
    super.key,
    required this.imageAsset,
    required this.aspectRatio,
    this.topLeft,
    this.topRight,
    this.hovered,
  });

  final String imageAsset;
  final double aspectRatio;
  final Widget? topLeft;
  final Widget? topRight;
  final bool? hovered;

  @override
  Widget build(BuildContext context) {
    return MajesticOrbitalCardFrame(
      imageAsset: imageAsset,
      aspectRatio: aspectRatio,
      topLeft: topLeft,
      topRight: topRight,
      hovered: hovered,
      enableHoverTiltWobble: true,
      orbitExtentScale: kEventsUpcomingOrbitExtentScale,
    );
  }
}
