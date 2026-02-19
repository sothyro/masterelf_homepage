import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../screens/legal/legal_content.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'glass_container.dart';

/// Shows a modal dialog with the given legal page content (scrollable text).
void showLegalPopup(BuildContext context, LegalPage page) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => LegalPopup(page: page),
  );
}

class LegalPopup extends StatelessWidget {
  const LegalPopup({super.key, required this.page});

  final LegalPage page;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = LegalContent.title(context, page);
    final body = LegalContent.body(context, page);
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final padding = MediaQuery.paddingOf(context);
    final insetPadding = EdgeInsets.fromLTRB(
      isMobile ? 12 : 24,
      24 + padding.top,
      isMobile ? 12 : 24,
      24 + padding.bottom,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: GlassContainer(
        blurSigma: 10,
        color: AppColors.overlayDark.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: AppShadows.dialog,
        padding: EdgeInsets.zero,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 22, color: AppColors.onPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderDark),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SelectableText(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary,
                          height: 1.6,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
