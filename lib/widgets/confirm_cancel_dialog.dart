import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Shows a confirmation dialog before cancelling a booking. Returns true if confirmed.
Future<bool> showCancelBookingConfirm(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceElevatedDark,
      title: Text(
        l10n.cancelBookingButton,
        style: const TextStyle(color: AppColors.onPrimary),
      ),
      content: Text(
        l10n.cancelBookingConfirm,
        style: const TextStyle(color: AppColors.onSurfaceVariantDark),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.close, style: const TextStyle(color: AppColors.accent)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.cancelBookingButton, style: const TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
  return result ?? false;
}
