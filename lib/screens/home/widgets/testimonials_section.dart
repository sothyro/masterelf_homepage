import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

/// Placeholder testimonial (from INFORMATION_NEEDED §8.5).
class TestimonialItem {
  const TestimonialItem({
    required this.quote,
    required this.name,
    required this.location,
  });

  final String quote;
  final String name;
  final String location;
}

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  static const _placeholders = [
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'Chong Sarachan',
      location: 'Phnom Penh',
    ),
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'Lana',
      location: 'Phnom Penh',
    ),
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'kenway',
      location: 'Phnom Penh',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sectionTestimonialsHeading,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.sectionTestimonialsSub1,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.sectionTestimonialsSub2,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _placeholders.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      final t = _placeholders[index];
                      return _TestimonialCard(
                        quote: t.quote,
                        name: t.name,
                        location: t.location,
                        imageIndex: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({
    required this.quote,
    required this.name,
    required this.location,
    this.imageIndex = 0,
  });

  final String quote;
  final String name;
  final String location;
  final int imageIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 360,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imageIndex.isEven ? AppContent.assetTestimonialProfile : AppContent.assetTestimonialParticipant,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(LucideIcons.play, color: AppColors.accent, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.watch,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '"$quote"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontStyle: FontStyle.italic),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                location,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
