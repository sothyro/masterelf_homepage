import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/breakpoints.dart';
import 'apps_yuk9_brand.dart';

/// Marketing lead-in below the hero — YUK9 art lockup + prominent tagline.
class AppsMasterElfSystemIntro extends StatelessWidget {
  const AppsMasterElfSystemIntro({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 680),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 12),
          child: MasterElfYuk9ProBrandTitle(
            isNarrow: isMobile,
            compact: true,
            artText: 'THE RISE OF THE PHOENIX',
            tagline: l10n.appsIntroTagline,
          ),
        ),
      ),
    );
  }
}
