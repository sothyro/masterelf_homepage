import 'package:flutter/material.dart';

import '../../../widgets/majestic_orbital_card_frame.dart';
import '../../../utils/mobile_web_performance.dart';

/// Events-page spotlight uses wider satellite orbits than the homepage default.
const double kEventsUpcomingOrbitExtentScale = 1.24;

/// Event-page wrapper around the shared [MajesticOrbitalCardFrame].
class EventsUpcoming3DFrame extends StatefulWidget {
  const EventsUpcoming3DFrame({
    super.key,
    required this.imageAsset,
    required this.aspectRatio,
    this.topLeft,
    this.topRight,
    this.hovered,
    this.cardBodyScale = 1.0,
    this.orbitExtentScale = kEventsUpcomingOrbitExtentScale,
  });

  final String imageAsset;
  final double aspectRatio;
  final Widget? topLeft;
  final Widget? topRight;
  final bool? hovered;
  final double cardBodyScale;
  final double orbitExtentScale;

  @override
  State<EventsUpcoming3DFrame> createState() => _EventsUpcoming3DFrameState();
}

class _EventsUpcoming3DFrameState extends State<EventsUpcoming3DFrame> {
  bool _orbitAnimationEnabled = false;
  bool _orbitAnimationScheduled = false;

  bool _permanentlyStatic(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    return mq != null && mq.disableAnimations;
  }

  bool _showStaticOrbit(BuildContext context) {
    if (_permanentlyStatic(context)) return true;
    if (MobileWebPerformance.prefersReducedMotion(context)) return true;
    return MobileWebPerformance.isMobileWeb(context) && !_orbitAnimationEnabled;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_permanentlyStatic(context) ||
        MobileWebPerformance.prefersReducedMotion(context)) {
      return;
    }

    if (!MobileWebPerformance.isMobileWeb(context)) {
      if (!_orbitAnimationEnabled) {
        setState(() => _orbitAnimationEnabled = true);
      }
      return;
    }

    if (_orbitAnimationScheduled || _orbitAnimationEnabled) return;
    _orbitAnimationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(MobileWebPerformance.heroMedallionAnimationDefer(), () {
        if (!mounted || _orbitAnimationEnabled) return;
        setState(() => _orbitAnimationEnabled = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final staticOrbit = _showStaticOrbit(context);
    final reducedMotion = MobileWebPerformance.prefersReducedMotion(context);

    return MajesticOrbitalCardFrame(
      imageAsset: widget.imageAsset,
      aspectRatio: widget.aspectRatio,
      topLeft: widget.topLeft,
      topRight: widget.topRight,
      hovered: reducedMotion ? false : widget.hovered,
      enableHoverTiltWobble: !reducedMotion,
      showSatelliteOrbits: !staticOrbit,
      cardBodyScale: widget.cardBodyScale,
      orbitExtentScale: widget.orbitExtentScale,
    );
  }
}
