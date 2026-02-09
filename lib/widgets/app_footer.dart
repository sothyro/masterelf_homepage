import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../screens/legal/legal_content.dart';
import '../utils/launcher_utils.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'legal_popup.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final year = DateTime.now().year;
    final company = AppContent.legalEntity;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: isNarrow
                ? _footerBlocksColumn(context, l10n, company)
                : _footerBlocksRow(context, l10n, company),
          ),
          const SizedBox(height: 28),
          Divider(height: 1, color: AppColors.onPrimary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            l10n.copyright(year, company),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.75),
                  fontSize: 13,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: () => showLegalPopup(context, LegalPage.terms),
                child: Text(
                  l10n.termsOfService,
                  style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.8), fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: () => showLegalPopup(context, LegalPage.disclaimer),
                child: Text(
                  l10n.disclaimer,
                  style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.8), fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: () => showLegalPopup(context, LegalPage.privacy),
                child: Text(
                  l10n.privacyPolicy,
                  style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.8), fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Powered by Stonechat Communications',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.55),
                  fontSize: 12,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _footerBlocksRow(BuildContext context, AppLocalizations l10n, String company) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _OfficeBlock(
            title: AppContent.office1Label,
            company: company,
            address: AppContent.office1Address,
            phone: AppContent.office1Phone,
            compact: false,
            centerContent: false,
          ),
        ),
        Expanded(
          child: _LinkColumn(
            title: l10n.quickLinks,
            links: [
              _LinkItem(l10n.home, '/'),
              _LinkItem(l10n.journey, '/journey'),
              _LinkItem(l10n.events, '/events'),
              _LinkItem(l10n.consultations, '/appointments'),
            ],
            compact: false,
            centerContent: true,
          ),
        ),
        Expanded(
          child: _LinkColumn(
            title: l10n.appsAndStore,
            links: [
              _LinkItem(l10n.masterElfSystem, '/apps#master-elf'),
              _LinkItem(l10n.period9MobileApp, '/apps#period9'),
              _LinkItem(l10n.talismanStore, '/apps#talisman'),
              _LinkItem('Academy', '/academy'),
            ],
            compact: false,
            centerContent: true,
          ),
        ),
        Expanded(
          child: Center(
            child: _ChatAndSocial(l10n: l10n, compact: false, centerContent: true),
          ),
        ),
      ],
    );
  }

  Widget _footerBlocksColumn(BuildContext context, AppLocalizations l10n, String company) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _OfficeBlock(
          title: AppContent.office1Label,
          company: company,
          address: AppContent.office1Address,
          phone: AppContent.office1Phone,
          compact: false,
          centerContent: true,
        ),
        const SizedBox(height: 28),
        _LinkColumn(
          title: l10n.quickLinks,
          links: [
            _LinkItem(l10n.home, '/'),
            _LinkItem(l10n.journey, '/journey'),
            _LinkItem(l10n.events, '/events'),
            _LinkItem(l10n.consultations, '/appointments'),
          ],
          compact: false,
          centerContent: true,
        ),
        const SizedBox(height: 24),
        _LinkColumn(
          title: l10n.appsAndStore,
          links: [
            _LinkItem(l10n.masterElfSystem, '/apps#master-elf'),
            _LinkItem(l10n.period9MobileApp, '/apps#period9'),
            _LinkItem(l10n.talismanStore, '/apps#talisman'),
            _LinkItem('Academy', '/academy'),
          ],
          compact: false,
          centerContent: true,
        ),
        const SizedBox(height: 24),
        _ChatAndSocial(l10n: l10n, compact: false, centerContent: true),
      ],
    );
  }

}

class _OfficeBlock extends StatelessWidget {
  const _OfficeBlock({
    required this.title,
    required this.company,
    required this.address,
    required this.phone,
    this.compact = false,
    this.centerContent = false,
  });

  final String title;
  final String company;
  final String address;
  final String phone;
  final bool compact;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final f = compact ? 11.0 : 14.0;
    final gap = compact ? 4.0 : 10.0;
    final crossAlign = centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centerContent ? TextAlign.center : TextAlign.left;
    return Column(
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 12 : 16,
              ),
          textAlign: textAlign,
        ),
        SizedBox(height: gap),
        Text(company, style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.75), fontSize: f), textAlign: textAlign),
        SizedBox(height: gap / 2),
        Text(address, style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.75), fontSize: f), textAlign: textAlign),
        SizedBox(height: gap / 2),
        Text(phone, style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.75), fontSize: f), textAlign: textAlign),
      ],
    );
  }
}

class _ChatAndSocial extends StatelessWidget {
  const _ChatAndSocial({required this.l10n, this.compact = false, this.centerContent = false});

  final AppLocalizations l10n;
  final bool compact;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.chatWithUs,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 12 : 16,
              ),
        ),
        SizedBox(height: compact ? 4 : 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: centerContent ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(LucideIcons.messageCircle, color: AppColors.onPrimary, size: compact ? 20 : 26),
              onPressed: () => launchWhatsApp(),
              tooltip: 'WhatsApp',
              style: IconButton.styleFrom(padding: compact ? const EdgeInsets.all(6) : const EdgeInsets.all(8)),
            ),
            if (AppContent.facebookUrl != null)
              IconButton(
                icon: Icon(LucideIcons.facebook, color: AppColors.onPrimary, size: compact ? 18 : 22),
                onPressed: () => launchUrlExternal(AppContent.facebookUrl!),
                tooltip: 'Facebook',
                style: IconButton.styleFrom(padding: compact ? const EdgeInsets.all(6) : const EdgeInsets.all(8)),
              ),
            if (AppContent.instagramUrl != null)
              IconButton(
                icon: Icon(LucideIcons.instagram, color: AppColors.onPrimary, size: compact ? 18 : 22),
                onPressed: () => launchUrlExternal(AppContent.instagramUrl!),
                tooltip: 'Instagram',
                style: IconButton.styleFrom(padding: compact ? const EdgeInsets.all(6) : const EdgeInsets.all(8)),
              ),
            if (AppContent.tiktokUrl != null)
              IconButton(
                icon: Icon(LucideIcons.video, color: AppColors.onPrimary, size: compact ? 18 : 22),
                onPressed: () => launchUrlExternal(AppContent.tiktokUrl!),
                tooltip: 'TikTok',
                style: IconButton.styleFrom(padding: compact ? const EdgeInsets.all(6) : const EdgeInsets.all(8)),
              ),
            if (AppContent.telegramUrl != null)
              IconButton(
                icon: Icon(LucideIcons.send, color: AppColors.onPrimary, size: compact ? 18 : 22),
                onPressed: () => launchUrlExternal(AppContent.telegramUrl!),
                tooltip: 'Telegram',
                style: IconButton.styleFrom(padding: compact ? const EdgeInsets.all(6) : const EdgeInsets.all(8)),
              ),
          ],
        ),
      ],
    );
  }
}

class _LinkItem {
  const _LinkItem(this.label, this.path);
  final String label;
  final String path;
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, required this.links, this.compact = false, this.centerContent = false});

  final String title;
  final List<_LinkItem> links;
  final bool compact;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final crossAlign = centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 12 : 16,
              ),
        ),
        SizedBox(height: compact ? 4 : 12),
        ...links.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: compact ? 0 : 8),
            child: InkWell(
              onTap: () => context.go(e.path),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  e.label,
                  style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.75), fontSize: compact ? 11 : 14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
