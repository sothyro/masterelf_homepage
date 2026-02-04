import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/launcher_utils.dart';
import '../../widgets/breadcrumb.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Breadcrumb(items: [
              (label: 'Home', route: '/'),
              (label: l10n.contactUs, route: null),
            ]),
            const SizedBox(height: 16),
            Text(
              l10n.contactUs,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 32),
            _OfficeBlock(
              title: AppContent.office1Label,
              company: AppContent.office1Company,
              address: AppContent.office1Address,
              phone: AppContent.office1Phone,
              phone2: AppContent.office1PhoneSecondary,
              email: AppContent.email,
            ),
            const SizedBox(height: 32),
            Text(
              l10n.chatWithUs,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton.filled(
                  onPressed: () => launchWhatsApp(),
                  icon: const Icon(LucideIcons.messageCircle),
                  tooltip: 'WhatsApp',
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  onPressed: () => launchEmail(),
                  icon: const Icon(LucideIcons.mail),
                  tooltip: 'Email',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Map placeholder',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfficeBlock extends StatelessWidget {
  const _OfficeBlock({
    required this.title,
    required this.company,
    required this.address,
    required this.phone,
    this.phone2,
    this.email,
  });

  final String title;
  final String company;
  final String address;
  final String phone;
  final String? phone2;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(company, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(LucideIcons.mapPin, size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(child: Text(address, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(LucideIcons.phone, size: 16, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(phone, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        if (phone2 != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.phone, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(phone2!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
        if (email != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.mail, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(email!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ],
    );
  }
}
