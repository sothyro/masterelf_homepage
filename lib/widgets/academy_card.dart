import 'package:flutter/material.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Academy/learning card: image on top, title, description, and "Explore →" CTA.
/// Same design as the three cards on the main page (BaZi Harmony, Feng Shui Charter, QiMen Dunjia).
class AcademyCard extends StatefulWidget {
  const AcademyCard({
    super.key,
    required this.title,
    required this.description,
    required this.onExplore,
    this.imageAsset,
    this.icon,
  });

  final String title;
  final String description;
  final VoidCallback onExplore;
  /// If null, uses [AppContent.assetAcademy].
  final String? imageAsset;
  /// Fallback icon when image fails to load.
  final IconData? icon;

  @override
  State<AcademyCard> createState() => _AcademyCardState();
}

class _AcademyCardState extends State<AcademyCard> {
  bool _isHovered = false;

  static const Color _textLight = Color(0xFFE8E8E8);
  static const Color _textMuted = Color(0xFFB0B0B0);
  static const double _imageAspectRatio = 1.0;
  static const double _descriptionHeight = 45.0;

  @override
  Widget build(BuildContext context) {
    final l10n = _getExploreLabel(context);
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.titleLarge?.copyWith(
      color: _textLight,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
    final descriptionStyle = textTheme.bodyMedium?.copyWith(
      color: _textMuted,
      fontSize: 15,
      height: 1.5,
    );
    final ctaStyle = textTheme.labelLarge?.copyWith(
      color: AppColors.accent,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _isHovered
        ? AppColors.borderLight.withValues(alpha: 0.5)
        : AppColors.borderDark;
    final scale = _isHovered ? 1.02 : 1.0;
    final imageAsset = widget.imageAsset ?? AppContent.assetAcademy;
    final fallbackIcon = widget.icon ?? Icons.school;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onExplore,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: _imageAspectRatio,
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        child: Icon(fallbackIcon, size: 56, color: AppColors.accent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: _descriptionHeight,
                          child: Text(
                            widget.description,
                            style: descriptionStyle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n,
                              style: ctaStyle,
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, size: 18, color: AppColors.accent),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getExploreLabel(BuildContext context) {
    try {
      final l10n = AppLocalizations.of(context);
      return l10n?.exploreCourses ?? 'Explore';
    } catch (_) {
      return 'Explore';
    }
  }
}
