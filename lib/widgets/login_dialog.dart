import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

/// A pair of (label, route) for post-login navigation buttons.
typedef LoginSuccessAction = ({String label, String route});

/// Shows a login dialog. On success, displays two buttons for navigation.
void showLoginDialog(
  BuildContext context, {
  required List<LoginSuccessAction> successActions,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => LoginDialog(successActions: successActions),
  );
}

class LoginDialog extends StatefulWidget {
  const LoginDialog({
    super.key,
    required this.successActions,
  });

  final List<LoginSuccessAction> successActions;

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  bool _success = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(AuthProvider auth) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await auth.signIn(email, password);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = null;
        _success = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)!.loginError;
      });
    }
  }

  void _navigateAndClose(String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5), width: 1),
            boxShadow: AppShadows.dialog,
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: _success ? _buildSuccessContent(l10n) : _buildLoginForm(l10n, auth),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 64, color: AppColors.accent),
        const SizedBox(height: 24),
        Text(
          l10n.loginSuccess,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...widget.successActions.asMap().entries.map((e) {
          final isPrimary = e.key == 0;
          final action = e.value;
          return Padding(
            padding: EdgeInsets.only(bottom: e.key < widget.successActions.length - 1 ? 12 : 0),
            child: SizedBox(
              width: double.infinity,
              child: isPrimary
                  ? FilledButton.icon(
                      onPressed: () => _navigateAndClose(action.route),
                      icon: const Icon(LucideIcons.arrowRight, size: 18),
                      label: Text(action.label),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: () => _navigateAndClose(action.route),
                      icon: const Icon(LucideIcons.layoutDashboard, size: 18),
                      label: Text(action.label),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                    ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLoginForm(AppLocalizations l10n, AuthProvider auth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.loginSectionTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.x, size: 22, color: AppColors.onSurfaceVariantDark),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: l10n.close,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.loginSectionIntro,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.4,
              ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: l10n.loginEmail,
            prefixIcon: const Icon(LucideIcons.mail, size: 20, color: AppColors.accent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
            filled: true,
            fillColor: AppColors.backgroundDark,
          ),
          style: const TextStyle(color: AppColors.onPrimary),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: l10n.loginPassword,
            prefixIcon: const Icon(LucideIcons.lock, size: 20, color: AppColors.accent),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 20,
                color: AppColors.onSurfaceVariantDark,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
            filled: true,
            fillColor: AppColors.backgroundDark,
          ),
          style: const TextStyle(color: AppColors.onPrimary),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _loading ? null : () => _signIn(auth),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: _loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                )
              : Text(l10n.loginButton),
        ),
      ],
    );
  }
}
