import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

/// Row of primary CTA, optional price label, and secondary button for marketplace hero.
class AppsMarketplaceCtaRow extends StatelessWidget {
  const AppsMarketplaceCtaRow({
    super.key,
    required this.primaryButton,
    this.secondaryLabel,
    this.secondaryButton,
  });

  final Widget primaryButton;
  final String? secondaryLabel;
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    if (secondaryButton == null) return primaryButton;
    return isNarrow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              if (secondaryLabel != null) ...[
                const SizedBox(height: 12),
                Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              secondaryButton!,
            ],
          )
        : Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              primaryButton,
              if (secondaryLabel != null)
                Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
              secondaryButton!,
            ],
          );
  }
}
