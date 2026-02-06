import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/launcher_utils.dart';
import '../../widgets/glass_container.dart';

/// Contact page: hero banner + two-column layout (contact info left, form right).
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  int _selectedSubjectIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _getSubjectLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.contactSubjectDestiny;
      case 1:
        return l10n.contactSubjectBusiness;
      case 2:
        return l10n.contactSubjectFengShui;
      case 3:
        return l10n.contactSubjectDateSelection;
      case 4:
        return l10n.contactSubjectUnsure;
      default:
        return l10n.contactSubjectDestiny;
    }
  }

  void _onSubmit() {
    // Placeholder: could send to API or mailto
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();
    if (name.isEmpty || email.isEmpty || message.isEmpty) return;
    launchEmail();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 800;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Clear space for the overlaid app header
          const SizedBox(height: 120),
          // Hero: "Contact Us" with background image
          _ContactHero(title: l10n.contactUs),
          // Main: two columns
          Padding(
            padding: EdgeInsets.only(
              top: 48,
              bottom: 64,
              left: isNarrow ? 20 : 40,
              right: isNarrow ? 20 : 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: isNarrow
                    ? _buildSingleColumn(l10n)
                    : _buildTwoColumns(l10n),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleColumn(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLeftColumnContent(l10n),
        const SizedBox(height: 40),
        _buildFormCard(l10n),
      ],
    );
  }

  Widget _buildTwoColumns(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: _buildLeftColumnContent(l10n),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 6,
          child: _buildFormCard(l10n),
        ),
      ],
    );
  }

  Widget _buildLeftColumnContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.contactLetsConnect,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.contactIntro,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 48),
        _OfficeBlock(
          title: AppContent.office1Label,
          company: AppContent.office1Company,
          address: AppContent.office1Address,
          phone: AppContent.office1Phone,
          phone2: AppContent.office1PhoneSecondary,
          email: AppContent.email,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            IconButton.filled(
              onPressed: () => launchWhatsApp(),
              icon: const Icon(LucideIcons.messageCircle, size: 22),
              tooltip: 'WhatsApp',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
              ),
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              onPressed: () => launchEmail(),
              icon: const Icon(LucideIcons.mail, size: 22),
              tooltip: 'Email',
              style: IconButton.styleFrom(
                foregroundColor: AppColors.onPrimary,
                side: const BorderSide(color: AppColors.borderLight),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormCard(AppLocalizations l10n) {
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _formLabel(l10n.contactFormName, required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: _inputDecoration(l10n.yourName),
            style: const TextStyle(color: AppColors.onPrimary),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          _formLabel(l10n.contactFormEmail, required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(l10n.contactFormEmail),
            style: const TextStyle(color: AppColors.onPrimary),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          _formLabel(l10n.contactFormPhone, required: false),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(l10n.contactFormPhone),
            style: const TextStyle(color: AppColors.onPrimary),
          ),
          const SizedBox(height: 24),
          _formLabel(l10n.contactFormSubject, required: false),
          const SizedBox(height: 12),
          ...List.generate(5, (i) {
            final selected = _selectedSubjectIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => setState(() => _selectedSubjectIndex = i),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Radio<int>(
                      value: i,
                      groupValue: _selectedSubjectIndex,
                      onChanged: (v) => setState(() => _selectedSubjectIndex = v ?? 0),
                      activeColor: AppColors.accent,
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) return AppColors.accent;
                        return AppColors.onSurfaceVariantDark;
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getSubjectLabel(l10n, i),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          _formLabel(l10n.contactFormMessage, required: true),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: _inputDecoration(l10n.contactFormMessage).copyWith(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              alignLabelWithHint: true,
            ),
            style: const TextStyle(color: AppColors.onPrimary),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canSubmit() ? _onSubmit : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l10n.submit),
            ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _messageController.text.trim().isNotEmpty;
  }

  Widget _formLabel(String text, {required bool required}) {
    return Text(
      required ? '$text *' : text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.7)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 2),
      ),
      filled: true,
      fillColor: AppColors.backgroundDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

/// Hero section: full-width background image with overlay and "Contact Us" title.
class _ContactHero extends StatelessWidget {
  const _ContactHero({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = width < 600 ? 220.0 : (width < 900 ? 280.0 : 340.0);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            AppContent.assetAboutHero,
            fit: BoxFit.cover,
          ),
          // Dark gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.backgroundDark.withValues(alpha: 0.75),
                  AppColors.backgroundDark.withValues(alpha: 0.4),
                  AppColors.backgroundDark.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width < 600 ? 20 : 40,
                vertical: 24,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          company,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(LucideIcons.mapPin, size: 18, color: AppColors.onPrimary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                address,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(LucideIcons.phone, size: 18, color: AppColors.onPrimary),
            const SizedBox(width: 10),
            Text(
              phone,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                  ),
            ),
          ],
        ),
        if (phone2 != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.phone, size: 18, color: AppColors.onPrimary),
              const SizedBox(width: 10),
              Text(
                phone2!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
              ),
            ],
          ),
        ],
        if (email != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.mail, size: 18, color: AppColors.onPrimary),
              const SizedBox(width: 10),
              Text(
                email!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
