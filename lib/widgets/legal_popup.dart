import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../screens/legal/legal_content.dart';
import '../theme/app_theme.dart';

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
    final title = LegalContent.title(page);
    final body = LegalContent.body(page);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: SelectableText(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurface,
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
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
