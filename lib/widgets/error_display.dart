import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../services/error_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

/// Displays an error message with optional retry action.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final AppError error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.alertCircle, size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error.userMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
          if (error.retryable && onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppLocalizations.of(context)?.retry ?? 'Retry',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return GlassContainer(
      blurSigma: 8,
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.error.withValues(alpha: 0.4),
        width: 1,
      ),
      boxShadow: AppShadows.card,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isMobile ? 56 : 64,
            height: isMobile ? 56 : 64,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getErrorIcon(),
              size: isMobile ? 28 : 32,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            _getErrorTitle(l10n),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            error.userMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          if (error.retryable && onRetry != null) ...[
            SizedBox(height: isMobile ? 20 : 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: 20),
                label: Text(l10n.retry),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 12 : 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getErrorIcon() {
    switch (error.category) {
      case ErrorCategory.network:
        return LucideIcons.wifiOff;
      case ErrorCategory.authentication:
        return LucideIcons.lock;
      case ErrorCategory.permission:
        return LucideIcons.shieldAlert;
      case ErrorCategory.validation:
        return LucideIcons.alertCircle;
      case ErrorCategory.notFound:
        return LucideIcons.searchX;
      case ErrorCategory.rateLimit:
        return LucideIcons.clock;
      default:
        return LucideIcons.alertCircle;
    }
  }

  String _getErrorTitle(AppLocalizations l10n) {
    switch (error.category) {
      case ErrorCategory.network:
        return l10n.errorNetworkTitle;
      case ErrorCategory.authentication:
        return l10n.errorAuthTitle;
      case ErrorCategory.permission:
        return l10n.errorPermissionTitle;
      case ErrorCategory.validation:
        return l10n.errorValidationTitle;
      case ErrorCategory.notFound:
        return l10n.errorNotFoundTitle;
      case ErrorCategory.rateLimit:
        return l10n.errorRateLimitTitle;
      default:
        return l10n.errorTitle;
    }
  }
}

/// Snackbar-style error display for inline errors.
class ErrorSnackbar extends StatelessWidget {
  const ErrorSnackbar({
    super.key,
    required this.error,
    this.onRetry,
  });

  final AppError error;
  final VoidCallback? onRetry;

  static void show(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ErrorSnackbar(error: error, onRetry: onRetry),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: error.retryable && onRetry != null
            ? const Duration(seconds: 5)
            : const Duration(seconds: 4),
        action: error.retryable && onRetry != null
            ? SnackBarAction(
                label: AppLocalizations.of(context)?.retry ?? 'Retry',
                textColor: AppColors.onPrimary,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(LucideIcons.alertCircle, color: AppColors.onPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            error.userMessage,
            style: const TextStyle(color: AppColors.onPrimary),
          ),
        ),
      ],
    );
  }
}
