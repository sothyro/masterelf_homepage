import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Breadcrumb trail for inner pages (e.g. Home > About).
class Breadcrumb extends StatelessWidget {
  const Breadcrumb({super.key, required this.items});

  /// Pairs of (label, route or null for current page).
  final List<({String label, String? route})> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '›',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                    ),
              ),
            ),
          if (items[i].route != null)
            InkWell(
              onTap: () => context.go(items[i].route!),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  items[i].label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.accent,
                      ),
                ),
              ),
            )
          else
            Text(
              items[i].label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    fontWeight: FontWeight.w500,
                  ),
            ),
        ],
      ],
    );
  }
}
