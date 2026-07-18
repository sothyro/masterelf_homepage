import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/zodiac_forecast_content.dart';
import '../config/zodiac_forecast_models.dart';
import '../l10n/app_localizations.dart';
import '../screens/home/widgets/field_work_chinese_design.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import '../utils/launcher_utils.dart';

const _kArticlesUrl = 'https://www.facebook.com/masterelf.vip';
const _kInauspicious = Color(0xFFE57373);

/// Free 12 Animal Forecast dialog — modern Chinese master–detail layout.
class ForecastPopup extends StatefulWidget {
  const ForecastPopup({super.key});

  @override
  State<ForecastPopup> createState() => _ForecastPopupState();
}

class _ForecastPopupState extends State<ForecastPopup> {
  late String _selectedId;
  /// Mobile-only: false = list, true = detail of [_selectedId].
  bool _mobileShowDetail = false;

  @override
  void initState() {
    super.initState();
    _selectedId = zodiacForecasts.first.id;
  }

  void _selectAnimal(String id, {required bool isMobile}) {
    setState(() {
      _selectedId = id;
      if (isMobile) _mobileShowDetail = true;
    });
  }

  void _mobileBackToList() {
    setState(() => _mobileShowDetail = false);
  }

  Future<void> _openArticles() async {
    await launchUrlExternal(_kArticlesUrl);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final selected = zodiacForecastById(_selectedId) ?? zodiacForecasts.first;

    final isViewportMobile = size.width < Breakpoints.mobile;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isViewportMobile ? 12 : 24,
        vertical: isViewportMobile ? 20 : 36,
      ),
      child: ChineseDialogFrame(
        isMobile: isViewportMobile,
        child: ColoredBox(
          color: FieldWorkChinesePalette.ink,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final dialogWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : size.width.clamp(280.0, 960.0);
              final isMobile = dialogWidth < Breakpoints.mobile;
              // Leave room for the frame bezel so the shell fits the viewport.
              final frameChrome = isViewportMobile ? 12.0 : 16.0;
              final dialogHeight =
                  (size.height * (isMobile ? 0.82 : 0.78) - frameChrome)
                      .clamp(320.0, size.height);

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ChineseLatticePainter(
                        color: AppColors.accent,
                        opacity: 0.05,
                        cellSize: isMobile ? 44 : 56,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            FieldWorkChinesePalette.inkWash
                                .withValues(alpha: 0.9),
                            FieldWorkChinesePalette.ink
                                .withValues(alpha: 0.98),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: dialogWidth.clamp(280.0, 960.0),
                    height: dialogHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ForecastHeader(
                          l10n: l10n,
                          isMobile: isMobile,
                          showBack: isMobile && _mobileShowDetail,
                          onBack: _mobileBackToList,
                          onClose: () => Navigator.of(context).pop(),
                        ),
                        const ChineseMountingBar(),
                        Expanded(
                          child: isMobile
                              ? (_mobileShowDetail
                                  ? _ForecastDetail(
                                      zodiac: selected,
                                      l10n: l10n,
                                      isMobile: true,
                                      onReadArticles: _openArticles,
                                    )
                                  : _AnimalList(
                                      l10n: l10n,
                                      selectedId: _selectedId,
                                      onSelect: (id) =>
                                          _selectAnimal(id, isMobile: true),
                                      showPrompt: true,
                                    ))
                              : Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      width: 220,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: FieldWorkChinesePalette
                                              .inkWash
                                              .withValues(alpha: 0.65),
                                          border: Border(
                                            right: BorderSide(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.22),
                                            ),
                                          ),
                                        ),
                                        child: _AnimalList(
                                          l10n: l10n,
                                          selectedId: _selectedId,
                                          onSelect: (id) => _selectAnimal(
                                            id,
                                            isMobile: false,
                                          ),
                                          showPrompt: true,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _ForecastDetail(
                                        zodiac: selected,
                                        l10n: l10n,
                                        isMobile: false,
                                        onReadArticles: _openArticles,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ForecastHeader extends StatelessWidget {
  const _ForecastHeader({
    required this.l10n,
    required this.isMobile,
    required this.showBack,
    required this.onBack,
    required this.onClose,
  });

  final AppLocalizations l10n;
  final bool isMobile;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 12 : 20,
        isMobile ? 12 : 16,
        8,
        isMobile ? 10 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            IconButton(
              tooltip: l10n.back,
              onPressed: onBack,
              icon: const Icon(LucideIcons.arrowLeft, size: 20),
              color: AppColors.accentLight,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '运',
                      style: GoogleFonts.notoSerifSc(
                        color: AppColors.accent.withValues(alpha: 0.85),
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${l10n.popupTitle1} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.onPrimary
                                        .withValues(alpha: 0.75),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            TextSpan(
                              text: l10n.popupTitle2,
                              style: GoogleFonts.notoSerifSc(
                                color: AppColors.accentLight,
                                fontSize: isMobile ? 15 : 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.popupDescription} · ${l10n.forecastYearBingWu}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FieldWorkChinesePalette.ricePaper
                            .withValues(alpha: 0.55),
                        height: 1.3,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.dismiss,
            onPressed: onClose,
            icon: const Icon(LucideIcons.x, size: 20),
            color: AppColors.onPrimary.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}

class _AnimalList extends StatelessWidget {
  const _AnimalList({
    required this.l10n,
    required this.selectedId,
    required this.onSelect,
    required this.showPrompt,
  });

  final AppLocalizations l10n;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final bool showPrompt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showPrompt)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(
              l10n.forecastChooseAnimal,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.accentLight.withValues(alpha: 0.85),
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
            itemCount: zodiacForecasts.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.accent.withValues(alpha: 0.12),
              indent: 12,
              endIndent: 12,
            ),
            itemBuilder: (context, index) {
              final zodiac = zodiacForecasts[index];
              final selected = zodiac.id == selectedId;
              final years = zodiacBirthYears(zodiac.id);
              final yearHint = years.isNotEmpty ? '${years.last}' : '';
              return _AnimalListTile(
                zodiac: zodiac,
                label: zodiacDisplayName(l10n, zodiac.id),
                yearHint: yearHint,
                selected: selected,
                onTap: () => onSelect(zodiac.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AnimalListTile extends StatelessWidget {
  const _AnimalListTile({
    required this.zodiac,
    required this.label,
    required this.yearHint,
    required this.selected,
    required this.onTap,
  });

  final ZodiacForecast zodiac;
  final String label;
  final String yearHint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.accent.withValues(alpha: 0.12)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: selected ? AppColors.accent : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  zodiac.chineseName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifSc(
                    color: selected
                        ? AppColors.accentLight
                        : FieldWorkChinesePalette.ricePaper
                            .withValues(alpha: 0.8),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: selected
                            ? AppColors.accentLight
                            : AppColors.onPrimary.withValues(alpha: 0.9),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                ),
              ),
              if (yearHint.isNotEmpty)
                Text(
                  yearHint,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: FieldWorkChinesePalette.ricePaper
                            .withValues(alpha: 0.4),
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForecastDetail extends StatelessWidget {
  const _ForecastDetail({
    required this.zodiac,
    required this.l10n,
    required this.isMobile,
    required this.onReadArticles,
  });

  final ZodiacForecast zodiac;
  final AppLocalizations l10n;
  final bool isMobile;
  final VoidCallback onReadArticles;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final content = getZodiacForecastContent(locale)[zodiac.id];
    final predictions =
        content?.auspiciousPredictions ?? zodiac.auspiciousPredictions;
    final warnings =
        content?.inauspiciousWarnings ?? zodiac.inauspiciousWarnings;
    final displayName = zodiacDisplayName(l10n, zodiac.id);
    final birthYears = zodiacBirthYears(zodiac.id);
    final hasAuspicious =
        zodiac.auspiciousStars != null && zodiac.auspiciousStars!.isNotEmpty;
    final hasInauspicious = zodiac.inauspiciousStars != null &&
        zodiac.inauspiciousStars!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 24,
              16,
              isMobile ? 16 : 24,
              8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isMobile ? 52 : 58,
                      height: isMobile ? 52 : 58,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Text(
                        zodiac.chineseName,
                        style: GoogleFonts.notoSerifSc(
                          color: AppColors.accentLight,
                          fontSize: isMobile ? 26 : 30,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$displayName · ${zodiac.chineseName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.accentLight,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              for (final year in birthYears)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.accent
                                          .withValues(alpha: 0.22),
                                    ),
                                  ),
                                  child: Text(
                                    '$year',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: FieldWorkChinesePalette
                                              .ricePaper
                                              .withValues(alpha: 0.65),
                                          fontSize: 10,
                                          height: 1.2,
                                          letterSpacing: 0.2,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (isMobile) ...[
                  if (hasAuspicious)
                    _StarsSection(
                      title: l10n.forecastAuspiciousStars,
                      stars: zodiac.auspiciousStars!,
                      body: predictions,
                      isAuspicious: true,
                      locale: locale,
                    ),
                  if (hasAuspicious && hasInauspicious)
                    const SizedBox(height: 12),
                  if (hasInauspicious)
                    _StarsSection(
                      title: l10n.forecastInauspiciousStars,
                      stars: zodiac.inauspiciousStars!,
                      body: warnings,
                      isAuspicious: false,
                      locale: locale,
                    ),
                ] else
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (hasAuspicious)
                          Expanded(
                            child: _StarsSection(
                              title: l10n.forecastAuspiciousStars,
                              stars: zodiac.auspiciousStars!,
                              body: predictions,
                              isAuspicious: true,
                              locale: locale,
                            ),
                          ),
                        if (hasAuspicious && hasInauspicious)
                          const SizedBox(width: 12),
                        if (hasInauspicious)
                          Expanded(
                            child: _StarsSection(
                              title: l10n.forecastInauspiciousStars,
                              stars: zodiac.inauspiciousStars!,
                              body: warnings,
                              isAuspicious: false,
                              locale: locale,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 16 : 24,
            8,
            isMobile ? 16 : 24,
            isMobile ? 16 : 20,
          ),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onReadArticles,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const RoundedRectangleBorder(),
              ),
              child: Text(
                l10n.readFullArticles,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StarsSection extends StatelessWidget {
  const _StarsSection({
    required this.title,
    required this.stars,
    required this.body,
    required this.isAuspicious,
    required this.locale,
  });

  final String title;
  final List<StarInfo> stars;
  final String? body;
  final bool isAuspicious;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final accent = isAuspicious ? AppColors.accentLight : _kInauspicious;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.7),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final star in stars)
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: accent.withValues(alpha: 0.35)),
                    color: accent.withValues(alpha: 0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        star.chineseName,
                        style: GoogleFonts.notoSerifSc(
                          color: accent,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        starDisplaySecondary(star, locale),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: FieldWorkChinesePalette.ricePaper
                                  .withValues(alpha: 0.65),
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (body != null && body!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              body!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.85),
                    height: 1.45,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
