import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/breadcrumb.dart';

enum LegalPage { terms, disclaimer, privacy }

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.page});

  final LegalPage page;

  String get _title {
    switch (page) {
      case LegalPage.terms:
        return 'Terms of Service';
      case LegalPage.disclaimer:
        return 'Disclaimer';
      case LegalPage.privacy:
        return 'Privacy Policy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(items: [
              (label: 'Home', route: '/'),
              (label: _title, route: null),
            ]),
            const SizedBox(height: 16),
            Text(
              _title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Content to be provided. Please contact us for details.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
