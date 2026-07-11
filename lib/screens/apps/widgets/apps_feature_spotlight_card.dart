import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/chinese_device_showcase.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import 'apps_fullscreen_image.dart';

/// Single feature presented inside its preferred device frame.
class AppsFeatureSpotlightCard extends StatelessWidget {
  const AppsFeatureSpotlightCard({
    super.key,
    required this.title,
    required this.benefit,
    required this.asset,
    required this.deviceType,
  });

  final String title;
  final String benefit;
  final String asset;
  final ChineseDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.95),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          benefit,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.onSurfaceVariantDark,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final deviceWidth = (constraints.maxWidth * 0.94)
                .clamp(240, 580)
                .toDouble();
            return Center(
              child: ChineseDeviceFrame(
                asset: asset,
                type: deviceType,
                width: deviceWidth,
                onTap: () => showAppsFullscreenImage(context, asset),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const ChineseMountingBar(),
      ],
    );
  }
}
