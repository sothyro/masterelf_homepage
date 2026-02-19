import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../services/contact_form_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
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
  bool _submitting = false;
  String? _submitError;
  bool _submitSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Subject options match Consultations services (Bazi Reading, Feng Shui Services, etc.).
  static const int _subjectOptionCount = 6;

  String _getSubjectLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.consult1Category;
      case 1:
        return l10n.consult2Category;
      case 2:
        return l10n.consult3Category;
      case 3:
        return l10n.consult4Category;
      case 4:
        return l10n.consult5Category;
      case 5:
        return l10n.consult6Category;
      default:
        return l10n.consult1Category;
    }
  }

  Future<void> _onSubmit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();
    if (name.isEmpty || email.isEmpty || message.isEmpty) return;
    if (_submitting) return;

    setState(() {
      _submitting = true;
      _submitError = null;
      _submitSuccess = false;
    });

    final l10n = AppLocalizations.of(context)!;
    final subjectLabel = _getSubjectLabel(l10n, _selectedSubjectIndex);

    final result = await submitContactForm(
      name: name,
      email: email,
      message: message,
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      subjectIndex: _selectedSubjectIndex,
      subjectLabel: subjectLabel,
    );

    if (!mounted) return;
    setState(() {
      _submitting = false;
      if (result.success) {
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
        _selectedSubjectIndex = 0;
      }
    });
    if (!mounted) return;
    _showResultDialog(success: result.success, errorMessage: result.errorMessage);
  }

  void _showResultDialog({required bool success, String? errorMessage}) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ContactResultDialog(
        success: success,
        errorMessage: errorMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hero: same structure as Consultations page — full-bleed image + gradient, content on top
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppContent.assetContactHero,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundDark.withValues(alpha: 0.72),
                        AppColors.backgroundDark.withValues(alpha: 0.88),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: isNarrow ? 100 : 120,
                  bottom: (isNarrow ? 32 : 48) + MediaQuery.paddingOf(context).bottom,
                  left: isNarrow ? 16 : 24,
                  right: isNarrow ? 16 : 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.contactUs,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isNarrow ? 20 : 48,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 560),
                              child: Text(
                                l10n.contactIntro,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.onSurfaceVariantDark,
                                      height: 1.5,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        isNarrow
                            ? _buildSingleColumn(l10n)
                            : _buildTwoColumns(l10n),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      border: Border.all(color: AppColors.borderDark, width: 1),
      boxShadow: AppShadows.card,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
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
          RadioGroup<int>(
            groupValue: _selectedSubjectIndex,
            onChanged: (v) => setState(() => _selectedSubjectIndex = v ?? 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_subjectOptionCount, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => setState(() => _selectedSubjectIndex = i),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: i,
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
            ),
          ),
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
              onPressed: (_canSubmit() && !_submitting) ? _onSubmit : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.onAccent),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(l10n.contactSending),
                      ],
                    )
                  : Text(l10n.submit),
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
      fillColor: AppColors.backgroundDark.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

/// Themed dialog for contact form result (success or error).
class _ContactResultDialog extends StatelessWidget {
  const _ContactResultDialog({
    required this.success,
    this.errorMessage,
  });

  final bool success;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = success ? l10n.contactSuccessTitle : l10n.contactErrorTitle;
    final message = success ? l10n.contactSuccess : l10n.contactError;
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    final horizontalPadding = isMobile ? 16.0 : 24.0;
    final verticalPadding = isMobile ? 24.0 : 48.0;
    final innerPadding = isMobile ? 20.0 : 32.0;
    final iconSize = isMobile ? 56.0 : 72.0;
    final iconIconSize = isMobile ? 32.0 : 40.0;
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w700,
      fontSize: isMobile ? 20 : null,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: GlassContainer(
        blurSigma: 10,
        color: AppColors.surfaceElevatedDark.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: success
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.error.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: AppShadows.dialog,
        padding: EdgeInsets.fromLTRB(innerPadding, innerPadding, innerPadding, innerPadding - 4),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: success
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? LucideIcons.checkCircle : LucideIcons.alertCircle,
                  size: iconIconSize,
                  color: success ? AppColors.accent : AppColors.error,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),
              Text(
                title,
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                      height: 1.5,
                      fontSize: isMobile ? 15 : null,
                    ),
                textAlign: TextAlign.center,
              ),
              if (!success && errorMessage != null && errorMessage!.isNotEmpty) ...[
                SizedBox(height: isMobile ? 8 : 12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 10 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Text(
                    errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariantDark,
                          fontSize: 11,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              SizedBox(height: isMobile ? 20 : 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(l10n.close),
                ),
              ),
            ],
          ),
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
