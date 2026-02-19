import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'forecast_popup.dart';
import 'glass_container.dart';

/// Floating vertical bar on the right side for the Free 12 Animal Forecast CTA.
class StickyCtaBar extends StatefulWidget {
  const StickyCtaBar({super.key});

  @override
  State<StickyCtaBar> createState() => _StickyCtaBarState();
}

class _StickyCtaBarState extends State<StickyCtaBar> {
  bool _dismissed = false;

  void _openPopup() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ForecastPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: AppColors.onAccent,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    const radius = BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );
    return GlassContainer(
      blurSigma: 10,
      color: AppColors.accent.withValues(alpha: 0.9),
      borderRadius: radius,
      border: const Border(
        left: BorderSide(color: AppColors.borderLight, width: 1.5),
        top: BorderSide(color: AppColors.borderLight, width: 1.5),
        bottom: BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
      boxShadow: AppShadows.stickyCta,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, color: AppColors.onAccent, size: 18),
                  onPressed: () => setState(() => _dismissed = true),
                  tooltip: 'Dismiss',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: kMinTouchTargetSize,
                    minHeight: kMinTouchTargetSize,
                  ),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _openPopup,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.megaphone, color: AppColors.onAccent, size: 22),
                        const SizedBox(height: 12),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            l10n.stickyCtaText,
                            style: textStyle,
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
