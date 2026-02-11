import 'package:flutter/material.dart';

import '../config/zodiac_forecast_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import '../utils/launcher_utils.dart';
import 'glass_container.dart';

/// Returns the localized display name for a zodiac sign by id.
String _zodiacDisplayName(AppLocalizations l10n, String id) {
  switch (id) {
    case 'rat': return l10n.zodiacRat;
    case 'ox': return l10n.zodiacOx;
    case 'tiger': return l10n.zodiacTiger;
    case 'rabbit': return l10n.zodiacRabbit;
    case 'dragon': return l10n.zodiacDragon;
    case 'snake': return l10n.zodiacSnake;
    case 'horse': return l10n.zodiacHorse;
    case 'goat': return l10n.zodiacGoat;
    case 'monkey': return l10n.zodiacMonkey;
    case 'rooster': return l10n.zodiacRooster;
    case 'dog': return l10n.zodiacDog;
    case 'pig': return l10n.zodiacPig;
    default: return id;
  }
}

/// Returns 5 recent birth years for a zodiac sign.
/// Chinese zodiac cycle repeats every 12 years.
/// Reference: 2024 is Year of the Dragon
List<int> _getZodiacBirthYears(String zodiacId) {
  // Base years for each zodiac sign (2024 = Dragon)
  final baseYears = {
    'rat': 2020,
    'ox': 2021,
    'tiger': 2022,
    'rabbit': 2023,
    'dragon': 2024,
    'snake': 2025,
    'horse': 2026,
    'goat': 2027,
    'monkey': 2028,
    'rooster': 2029,
    'dog': 2030,
    'pig': 2031,
  };
  
  final baseYear = baseYears[zodiacId] ?? 2020;
  final currentYear = DateTime.now().year;
  
  // Find the most recent year for this zodiac sign (could be past, present, or future)
  int mostRecentYear = baseYear;
  while (mostRecentYear + 12 <= currentYear) {
    mostRecentYear += 12;
  }
  
  // Get 5 years: go back 4 cycles (48 years) to get 5 occurrences
  final years = <int>[];
  for (int i = 0; i < 5; i++) {
    years.add(mostRecentYear - (i * 12));
  }
  
  return years.reversed.toList(); // Return oldest to newest
}

class ForecastPopup extends StatelessWidget {
  const ForecastPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final size = MediaQuery.sizeOf(context);
    final isMobile = Breakpoints.isMobile(size.width);
    final isTablet = size.width >= Breakpoints.mobile && size.width < Breakpoints.tablet;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 24 : 40,
      ),
      child: GlassContainer(
        blurSigma: 12,
        color: AppColors.overlayDark.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: AppShadows.dialog,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useSidebarLayout = size.width >= Breakpoints.tablet;
            final maxH = size.height * (isMobile ? 0.75 : 0.8);
            final w = constraints.maxWidth.isFinite
                ? constraints.maxWidth.clamp(280.0, 1100.0)
                : 800.0;
            final h = constraints.maxHeight.isFinite
                ? constraints.maxHeight.clamp(300.0, maxH)
                : maxH;
            return SizedBox(
              width: w,
              height: h,
              child: DefaultTabController(
                length: _zodiacForecasts.length,
                child: useSidebarLayout
                    ? _DesktopLayout(l10n: l10n, textTheme: textTheme)
                    : _MobileLayout(
                        l10n: l10n,
                        textTheme: textTheme,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.l10n,
    required this.textTheme,
  });

  final AppLocalizations l10n;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar: zodiac selector (TabBar in vertical form)
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedDark.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
              border: Border(
                right: BorderSide(color: AppColors.borderDark),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                  child: _DialogHeader(
                    l10n: l10n,
                    textTheme: textTheme,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _ZodiacSidebarTabBar(l10n: l10n),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        for (final zodiac in _zodiacForecasts)
                          _ZodiacContentPane(
                            zodiac: zodiac,
                            isMobile: false,
                            l10n: l10n,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await launchUrlExternal(
                          'https://www.facebook.com/masterelf.vip',
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(l10n.readFullArticles),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.l10n,
    required this.textTheme,
    required this.isMobile,
    required this.isTablet,
  });

  final AppLocalizations l10n;
  final TextTheme textTheme;
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(isMobile ? 16 : 20, 16, 8, 0),
          child: _DialogHeader(
            l10n: l10n,
            textTheme: textTheme,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal scrollable zodiac chips
        SizedBox(
          height: isMobile ? 48 : 52,
          child: _ZodiacChipBar(l10n: l10n),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
            child: TabBarView(
              children: [
                for (final zodiac in _zodiacForecasts)
                  _ZodiacContentPane(
                    zodiac: zodiac,
                    isMobile: true,
                    l10n: l10n,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(isMobile ? 16 : 20, 12, isMobile ? 16 : 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await launchUrlExternal(
                  'https://www.facebook.com/masterelf.vip',
                );
                if (context.mounted) Navigator.of(context).pop();
              },
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l10n.readFullArticles),
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.l10n,
    required this.textTheme,
    required this.onClose,
  });

  final AppLocalizations l10n;
  final TextTheme textTheme;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.popupTitle1,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  l10n.popupTitle2,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.popupDescription,
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: 22, color: AppColors.onPrimary),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceElevatedDark.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ZodiacSidebarTabBar extends StatelessWidget {
  const _ZodiacSidebarTabBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _zodiacForecasts.length,
          itemBuilder: (context, index) {
            final zodiac = _zodiacForecasts[index];
            final isSelected = controller.index == index;
            final displayName = _zodiacDisplayName(l10n, zodiac.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => controller.animateTo(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            zodiac.chineseName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.accentLight,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            displayName,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: isSelected
                                      ? AppColors.accentLight
                                      : AppColors.onPrimary.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ZodiacChipBar extends StatelessWidget {
  const _ZodiacChipBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerHeight: 0,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.accent.withValues(alpha: 0.2),
      ),
      labelColor: AppColors.accentLight,
      unselectedLabelColor: AppColors.onPrimary.withValues(alpha: 0.7),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      overlayColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.hovered)
            ? AppColors.accent.withValues(alpha: 0.08)
            : null,
      ),
      tabs: [
        for (int index = 0; index < _zodiacForecasts.length; index++)
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final zodiac = _zodiacForecasts[index];
              final isSelected = controller.index == index;
              final textColor = isSelected
                  ? AppColors.accentLight
                  : AppColors.onPrimary.withValues(alpha: 0.7);
              return Tab(
                height: 48,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        zodiac.chineseName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _zodiacDisplayName(l10n, zodiac.id),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ZodiacContentPane extends StatelessWidget {
  const _ZodiacContentPane({
    required this.zodiac,
    required this.isMobile,
    required this.l10n,
  });

  final _ZodiacForecast zodiac;
  final bool isMobile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final content = getZodiacForecastContent(locale)[zodiac.id];
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: zodiac.hasDetailedContent
          ? _DetailedZodiacContent(
              zodiac: zodiac,
              isMobile: isMobile,
              l10n: l10n,
              locale: locale,
              content: content,
            )
          : _SimpleZodiacContent(zodiac: zodiac, l10n: l10n),
    );
  }
}

class _ZodiacForecast {
  const _ZodiacForecast({
    required this.id,
    required this.englishName,
    required this.chineseName,
    required this.assetPath,
    this.auspiciousStars,
    this.auspiciousPredictions,
    this.inauspiciousStars,
    this.inauspiciousWarnings,
  });

  final String id;
  final String englishName;
  final String chineseName;
  final String assetPath;
  final List<_StarInfo>? auspiciousStars;
  final String? auspiciousPredictions;
  final List<_StarInfo>? inauspiciousStars;
  final String? inauspiciousWarnings;
}

class _StarInfo {
  const _StarInfo({
    required this.khmerName,
    required this.chineseName,
    required this.englishTranslation,
  });

  final String khmerName;
  final String chineseName;
  final String englishTranslation;
}

const List<_ZodiacForecast> _zodiacForecasts = [
  _ZodiacForecast(
    id: 'rat',
    englishName: 'Rat',
    chineseName: '鼠',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-ebb38279-a049-45ac-bd6d-b9f475ed8a1e.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'យូកុង', chineseName: '月空', englishTranslation: 'Clear Moon'),
      _StarInfo(khmerName: 'ធានជូ', chineseName: '天厨', englishTranslation: 'Heavenly Kitchen'),
      _StarInfo(khmerName: 'ថាងហ្វូ', chineseName: '唐符', englishTranslation: 'Imperial Note'),
    ],
    auspiciousPredictions:
        'វេលាល្អសម្រាប់រៀបចំជិវិតថ្មី លំនៅឋានថ្មី\nទទួលឡានថ្មី បើកមុខរបរថ្មី!\nបោះចោលបញ្ហាចាស់\nចោលទំនាក់ទំនងToxic\nវេលាដល់ពេលគេទទួលស្គាល់\nនឹងមានសង្គមរាប់រក\nឡើងឋានៈ មានអំណាច និងល្បីល្បាញ។',
    inauspiciousStars: [
      _StarInfo(khmerName: 'ស៊ុយ ប៉', chineseName: '歲破', englishTranslation: 'Year Breaker'),
      _StarInfo(khmerName: 'តាហាវ', chineseName: '大耗', englishTranslation: 'Major Waste'),
      _StarInfo(khmerName: 'ធានគូ', chineseName: '天哭', englishTranslation: 'Heavenly Tears'),
      _StarInfo(khmerName: 'Zai Zha', chineseName: '災殺', englishTranslation: 'Accident'),
    ],
    inauspiciousWarnings:
        'ឆ្នាំនេះកណ្តុរនៅចំមុខ ថាយស៊ួយ ហត់នឿយបន្តិចហើយ ឆាប់ស្រ្តេស ឆាប់បាក់កំលាំង។\nប្រយ័ត្នប្រយែងលុយកាក់.\nមានគ្រោះថ្នាក់ ឈឺច្រើន និងងាយមានក្តីក្តាំ',
  ),
  _ZodiacForecast(
    id: 'ox',
    englishName: 'Ox',
    chineseName: '牛',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-c153ef55-42d8-4686-a191-331bb939a520.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Long De', chineseName: '龍德', englishTranslation: 'Dragon Virtue'),
      _StarInfo(khmerName: 'Zi Wei', chineseName: '紫微', englishTranslation: 'Purple Star'),
      _StarInfo(khmerName: 'Guo Ying', chineseName: '國印', englishTranslation: 'Imperial Seal'),
    ],
    auspiciousPredictions:
        'មានអំណាច ឡើងបុណ្យស័ក្តិ កិត្តិយស និងល្បីល្បាញ\nមានគេជួយជ្រោមជ្រែងទាន់ពេលវេលាល្អ\nឡើងលាភកើនលុយ និងសម្បូរកម្មវិធីសប្បាយៗ\nបុណ្យពីជាតិមុន នឹងជួយជ្រោមជ្រែងពីលើមេឃ',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Bao Bai', chineseName: '暴敗', englishTranslation: 'Sudden Decline'),
      _StarInfo(khmerName: 'Tian Er', chineseName: '天厄', englishTranslation: 'Heavenly Misfortune'),
      _StarInfo(khmerName: 'Tian Sha', chineseName: '天殺', englishTranslation: 'Heavenly Sha'),
    ],
    inauspiciousWarnings:
        'គេនិយាយមួលបង្កាច់ បង្ខូចឈ្មោះ អាចមានក្តីក្តាំផ្លូវច្បាប់ មានជំលោះ ត្រូវចេះទប់អារម្មណ៍ បាត់របស់ភ្លាមៗ ឈឺធ្ងន់ភ្លាមៗ ប្រយ័ត្នមិត្តភ័ក្តិឯងបោកប្រាស់!',
  ),
  _ZodiacForecast(
    id: 'tiger',
    englishName: 'Tiger',
    chineseName: '虎',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-b5b363d6-eb1c-4c95-86b9-5db0efb2eed0.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'San He', chineseName: '三合', englishTranslation: 'Three Harmony'),
      _StarInfo(khmerName: 'Xue Tang', chineseName: '學堂', englishTranslation: 'Study Hall'),
    ],
    auspiciousPredictions:
        'យល់ពីជីវិតនិងស្ថានការណ៍ជ្រៅជ្រះ និងគេទទួលស្កាល់ជាងមុន\nឆ្នាំនេះបើរៀនជំនាញថ្មីនឹងបានលាភ បើប្រលងនឹងជាប់\nធ្វើការនឹងបានទទួលដំណែងថ្មី រឺឡើងប្រាក់ខែ រឺលុយកាក់\nលាភច្រើនឆ្នាំនេះ បើឧស្សាហ៍នឹងចាប់បានច្រើន',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Bai Hu', chineseName: '白虎', englishTranslation: 'White Tiger'),
      _StarInfo(khmerName: 'Fei Lian', chineseName: '飛廉', englishTranslation: 'Flying Insect'),
      _StarInfo(khmerName: 'Da Sha', chineseName: '大殺', englishTranslation: 'Major Sha'),
      _StarInfo(khmerName: 'Zhi Bei', chineseName: '指背', englishTranslation: 'Back Pointing'),
    ],
    inauspiciousWarnings:
        'គេនិយាយមួលបង្កាច់ បង្ខូចឈ្មោះ អាចមានក្តីក្តាំផ្លូវច្បាប់\nមានជំលោះ ត្រូវចេះទប់អារម្មណ៍\nចេះតែចង់នៅម្នាក់ឯង មានជំងឺសល់ពីឆ្នាំចាស់\nគ្រោះផ្លូវឆ្ងាយ មិត្តជិតស្និតនឹងក្បត់អ្នក ចូរប្រយ័ត្ន',
  ),
  _ZodiacForecast(
    id: 'rabbit',
    englishName: 'Rabbit',
    chineseName: '兔',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-fb1c91fd-56dd-41c7-8756-9b679409a7b5.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Tian De', chineseName: '天德', englishTranslation: 'Heavenly Virtue'),
      _StarInfo(khmerName: 'Fu De', chineseName: '福德', englishTranslation: 'Fortune Virtue'),
      _StarInfo(khmerName: 'Fu Xing', chineseName: '福星', englishTranslation: 'Good fortune'),
      _StarInfo(khmerName: 'Tian Xi', chineseName: '天喜', englishTranslation: 'Heavenly Happiness'),
    ],
    auspiciousPredictions:
        'សុភមង្គល ស្ងប់សុខ និងទទួលពរជ័យពីឋានសួគ៌\nសុខភាពប្រសើជាឆ្នាំមុន និងមានគេជួយជ្រោមជ្រែងបើកផ្លូវ\nរីកចម្រើន ហេងថ្កុំថ្កើង និងទទួលបានលាភពីរបររកស៊ីការងារ',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Pi Ma', chineseName: '披麻', englishTranslation: 'Jute Cover'),
      _StarInfo(khmerName: 'Juan She', chineseName: '卷舌', englishTranslation: 'Twisting Tongue'),
      _StarInfo(khmerName: 'Jiao Sha', chineseName: '絞殺', englishTranslation: 'Strangling Sha'),
      _StarInfo(khmerName: 'Xian Chi', chineseName: '咸池', englishTranslation: 'Bathing Hall'),
    ],
    inauspiciousWarnings:
        'គេច្រណែន មួលបង្កាច់ក្រោយខ្នង ក្តីក្តាំអាចនឹងមានរឺមិនទាន់ចប់\nប្រយ័ត្នគូស្នេហ៍មិនស្មោះត្រង់ រឺនាំទុក្ខពីក្រៅមក\nគ្រួសារនឹងមានអ្នកឈឺ មើលមិនទាន់ឈឺធ្ងន់\nនិងប្រយ័ត្នដំណើរជិតឆ្ងាយ',
  ),
  _ZodiacForecast(
    id: 'dragon',
    englishName: 'Dragon',
    chineseName: '龙',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-1ef25318-a273-44da-9c0c-127816445c49.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Tian Jie', chineseName: '天解', englishTranslation: 'Heavenly Relief'),
      _StarInfo(khmerName: 'Jie Shen', chineseName: '解神', englishTranslation: 'Resolving God'),
      _StarInfo(khmerName: 'Ba Zuo', chineseName: '八座', englishTranslation: 'Eight Seats'),
    ],
    auspiciousPredictions:
        'ដំណោះស្រាយនឹងមាន ឋាមពលពិសេសក្នុងខ្លួននឹងកើនឡើង\nឡើងប្រាក់ខែ និយាយគេស្តាប់\nនឹងឡើងឋានៈ អស្សនៈ៨ទិស នឹងមានគេកោតក្រែង\nក្តីក្តាំឈ្នះគេ រត់ការការងាររកស៊ីនឹងបានសម្រេច',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Tian Gou', chineseName: '天狗', englishTranslation: 'Heavenly Dog'),
      _StarInfo(khmerName: 'Diao Ke', chineseName: '弔客', englishTranslation: 'Sadness Star'),
      _StarInfo(khmerName: 'Xue Ren', chineseName: '血刃', englishTranslation: 'Bloody Blade'),
      _StarInfo(khmerName: 'Fu Chen', chineseName: '浮沈', englishTranslation: 'Float and sink'),
    ],
    inauspiciousWarnings:
        'នឹងជួបគ្រោះថ្នាក់ និងជំលោះ\nជំលោះការងារ និងជំលោះដៃគូរ\nចិត្តត្រជាក់ៗ របស់បានដល់ដៃអាចរបូត កុំប្រហែស\nបញ្ហាសុខភាព និងគ្រោះថ្នាក់',
  ),
  _ZodiacForecast(
    id: 'snake',
    englishName: 'Snake',
    chineseName: '蛇',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-da8d1953-7356-4601-990f-2237bcfebf0c.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Lu Xun', chineseName: '祿勲', englishTranslation: 'Prosperity Medal'),
    ],
    auspiciousPredictions:
        'នឹងត្រូវបានគេទទួលស្គាល់ មេកើយទុកចិត្ត\nនឹងផ្តល់រង្វាន់ នឹងបានឡើងឋានៈ ឡើងលាភ\nឡើងលុយ ឡើងប្រាក់ខែ\nមានមិត្តភ័ក្តិជួយទំនុកបម្រុងជ្រោមជ្រែង។',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Mo Yue', chineseName: '驀越', englishTranslation: 'Fast Changes'),
      _StarInfo(khmerName: 'Bing Fu', chineseName: '病符', englishTranslation: 'Disease Note'),
      _StarInfo(khmerName: 'Po Sui', chineseName: '破碎', englishTranslation: 'Broken Pieces'),
      _StarInfo(khmerName: 'Wang Shen', chineseName: '亡神', englishTranslation: 'Clouded Spirit'),
    ],
    inauspiciousWarnings:
        'មានរឿងច្រើនកើតនៅផ្ទះ ត្រូវចេះបត់បែន\nនឹងមានជំងឺចាស់រើវិញ អាចលែងលះគូរស្នេហ៍\nបាត់ទ្រព្យ នៅឲ្យឆ្ងាយពីមនុស្សអវិជ្ជមាន\nនិងគ្រោះខែ',
  ),
  _ZodiacForecast(
    id: 'horse',
    englishName: 'Horse',
    chineseName: '马',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-4143623c-8082-44e3-a0b4-5eef11aba0df.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Sui Jia', chineseName: '歲駕', englishTranslation: 'Yearly Governing'),
      _StarInfo(khmerName: 'Jiang Xing', chineseName: '將星', englishTranslation: 'General Star'),
      _StarInfo(khmerName: 'Jin Gui', chineseName: '金匱', englishTranslation: 'Golden Cabinet'),
    ],
    auspiciousPredictions:
        'គ្រែស្នែងទេវតា ព្រះរាជាស្រលាញ់ពេញបេះដូង\nនឹងបានធ្វើដំណើរជោគជ័យ ប្តូរកន្លែងក៏បានលាភ\nបានតំណែង ឡើងឋានៈ ផ្លាស់ប្តូខ្សែជីវិតថ្មី\nបញ្ជាគេបាន មានអំណាច គេស្តាប់បង្គាប់\nមានគេហែហមទំនុកបំរុង\nទ្រព្យសន្សំនឹងកើនឡើង បើយកមកវិនិយាគ នឹងហេង មិនខាតបង់',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Tai Sui', chineseName: '太歲', englishTranslation: 'Yearly God'),
      _StarInfo(khmerName: 'Jian Feng', chineseName: '劍鋒', englishTranslation: 'Sword Tip'),
      _StarInfo(khmerName: 'Fu Shi', chineseName: '伏屍', englishTranslation: 'Corpse'),
      _StarInfo(khmerName: 'Sui Xing', chineseName: '歲刑', englishTranslation: 'Yearly Confinement'),
    ],
    inauspiciousWarnings:
        'ទេវតាកាន់ឆ្នាំគ្រងតំណែង ហត់នឿយ សម្ពាធច្រើន\nងាយឆេវឆាវ គិតច្រើនជ្រុល គេងមិនលក់\nអាចនឹងមានឈាមចេញពីខ្លួនច្រើនប្រយ័ត្នអស់បុណ្យ\nតែតារាលាភទាំង៣ នឹងជួយកាត់ឆុងឲ្យ\nលេខខ្មោចគេកប់ចោល\nជំងឺផ្លូវចិត្តធ្ងន់ ព្រោះទូលរែករឿងគ្រួសារតែឯង\nចាក់ច្រវ៉ាក់ចងជើងខ្លួនឯងកន្លែងដដែល',
  ),
  _ZodiacForecast(
    id: 'goat',
    englishName: 'Goat',
    chineseName: '羊',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-9ca4fe62-5061-443d-b3a0-c3de2bade4c1.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Tai Yang', chineseName: '太陽', englishTranslation: 'The Sun'),
      _StarInfo(khmerName: 'Sui He', chineseName: '歲合', englishTranslation: 'Yearly Harmony'),
      _StarInfo(khmerName: 'Ban An', chineseName: '板鞍', englishTranslation: 'Horse Saddle'),
    ],
    auspiciousPredictions:
        'ពន្លឺព្រះអាទិត្យភ្លឺត្រចះត្រចង់ នឹងមានអ្នកមានបុណ្យជួយជ្រោមជ្រែងបានលាភបានជ័យ ដំណោះស្រាយអ្វីក៏មានច្រកចេញ។ ល្អណាស់! សុខដុមរមនាឆ្នាំថ្មី ឋាមពលQiវិជ្ជមានខ្ពស់ណាស់ គ្រោះទៅជាលាភ លាភទៅជាស្តុកស្តម្ភ ជីវិតឡើងមួយថ្នាក់',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Tian Kong', chineseName: '天空', englishTranslation: 'Sky Emptiness'),
      _StarInfo(khmerName: 'Hui Chi', chineseName: '晦气', englishTranslation: 'Obstacle Star'),
      _StarInfo(khmerName: 'Drinking jiǔ sè shā', chineseName: '酒色煞', englishTranslation: 'Negative Sha'),
      _StarInfo(khmerName: 'Liu Xia', chineseName: 'Liu Xia', englishTranslation: 'Liu Xia'),
    ],
    inauspiciousWarnings:
        'ផ្លូវចិត្តធំដូចផ្ទៃមេឃ តែទទេស្អាត ងាយនឹងប្រើចិត្តខុស បំណងដែលហួសព្រំដែន នឹងមិនបានផល ឧបសគ្គនឹងកើតមានពេលចិត្តមិនស្រស់ស្រាយ មនុស្សចាំកេងចំណេញមានច្រើនឆ្នាំនេះ ត្រូវចំណាយពេលបង្រៀនចិត្ត រំសាយអារម្មណ៍ ងាយនឹងយកស្រា យកល្បែងបាំងមុខ នឹងមានឈាមចេញពីខ្លួនបើមិនប្រយ័ត្ន កំរិតវះកាត់ រឺសន្លប់ច្រើនថ្ងៃ',
  ),
  _ZodiacForecast(
    id: 'monkey',
    englishName: 'Monkey',
    chineseName: '猴',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-7935edc2-8fde-4c15-a869-7abf5456fd5d.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Sui Dian', chineseName: '歳殿', englishTranslation: 'Yearly Palace'),
      _StarInfo(khmerName: 'Wen Chang', chineseName: '文昌', englishTranslation: 'Intelligence Star'),
      _StarInfo(khmerName: 'Yi Ma', chineseName: '驛馬', englishTranslation: 'Traveling Horse'),
    ],
    auspiciousPredictions:
        'តារាបង្ហាញផ្លូវ អាចនឹងមានរៀបចំណងអាពាហ៍ពិពាហ៍ រឺចាប់ដៃគូរជីវិត តារាបញ្ញាញាណនៅរក្សា បើប្រលងជានិស្សិតរឺមន្ត្រីរាជការ នឹងបានដុចបំំណង តារានេះងាយឲ្យអ្នកប្រលងជាប់។ ចុះកុងត្រាមិនងាយចាញ់បោកគេ។ មានទំនោនឹងប្តុរកន្លែងការងារ រឺផ្ទះសម្បែក រឺចំណាកស្រុក។ ធ្វើដំណើរច្រើន។',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Sang Men', chineseName: '喪門', englishTranslation: 'Funeral Gate'),
      _StarInfo(khmerName: 'Di San', chineseName: '地喪', englishTranslation: 'Earth Funeral'),
      _StarInfo(khmerName: 'Gu Chen', chineseName: '孤辰', englishTranslation: 'Lonely Spirit'),
      _StarInfo(khmerName: 'Gu Xu', chineseName: '孤虚', englishTranslation: 'Lonely Emptiness'),
    ],
    inauspiciousWarnings:
        'សាលដំកល់សព ងាយបាត់សមាជិកគ្រួសារ រឺអ្នកធ្លាប់ស្គាល់ កើតទុក្ខក្រៀមក្រំដោយសារដៃគូរមិនបានដូចចិត្ត។ បើឈឺ គឺជំងឺកាច គួរទៅពិនិត្យព្យាបាលក្នុងឆ្នាំនេះ មានគូមិនយល់ចិត្ត ចង់នៅម្នាក់ឯង សើចនៅមុខ យំក្នុងចិត្ត គេឃើញចំនុចខ្សោយ ចូរប្រយ័ត្ន',
  ),
  _ZodiacForecast(
    id: 'rooster',
    englishName: 'Rooster',
    chineseName: '鸡',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-cf86f726-f42b-4a95-8a90-611423d81d1a.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Tai Yin', chineseName: '太陰', englishTranslation: 'The Moon'),
      _StarInfo(khmerName: 'Hong Luan', chineseName: '紅鸞', englishTranslation: 'Romance Star'),
      _StarInfo(khmerName: 'Tian Yi', chineseName: '天乙', englishTranslation: 'Noble Support'),
    ],
    auspiciousPredictions:
        'សម្រប់ផូរផង់ត្រលប់មកវិញ មានង៉ូវហេង នឹងជួបគូរ ធាតុអ៊ីនខ្លាំងគួជាទីស្រលាញ់របស់មនុស្សទាំងឡាយ មានដំណឹងល្អ គេសារភាពស្រលាញ់ នឹងមានអំណោយដោយមិនដឹងខ្លួន គូរឆ្នាំនេះបើយកគ្នាគឺត្រូវ! មយូរ៉ាជួបនាគ។ មានអ្នកធំជួយជ្រោមជ្រែង ពឹងគេបាន។ លុយមិនគ្រប់ មានគេជួបបន្ថែម។',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Gou Jiao', chineseName: '勾紋', englishTranslation: 'Entaglement'),
      _StarInfo(khmerName: 'Guan Suo', chineseName: '貫索', englishTranslation: 'Rope Tying'),
      _StarInfo(khmerName: 'Zu Bao', chineseName: '卒暴', englishTranslation: 'Sudden Disease'),
    ],
    inauspiciousWarnings:
        'ប្រយ័ត្នមានរឿងសាហាយស្មន់ លួចលាក់ គេចមិនផុត នឹងធ្លាយចេញ។ ខូចកិត្តយស។ ធ្លាយពីអ្នកជិតស្និត និងដៃគូរខាងក្រៅ។ គេនិយាយដើម នាំបញ្ហាចូលផ្ទះ បំណុលដោះមិនទាន់អស់ទេ រឿងចូលគ្រប់ច្រក ពេលមានរឿងមួយ គួរណាស់កុំបន្ថែមរឿង',
  ),
  _ZodiacForecast(
    id: 'dog',
    englishName: 'Dog',
    chineseName: '狗',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-bb8a90d2-01d2-4854-a072-f53bceed0865.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'San He', chineseName: '三合', englishTranslation: 'Three Harmony'),
      _StarInfo(khmerName: 'Di Jie', chineseName: '地解', englishTranslation: 'Earthly Resolve'),
      _StarInfo(khmerName: 'Hua Gai', chineseName: '華蓋', englishTranslation: 'Luxury Cover'),
    ],
    auspiciousPredictions:
        'មានមិនល្អជួយជ្រោមជ្រែង ចៅហ្វាយនាយជឿជាក់ រកស៊ីឈ្នះគេ។ បើចង់ជួបជុំជាមួយអ្នកណា និយាយនឹងគេបាន ដំណោះស្រាយបំណុល រឿងការងារ ក្តីក្តាំ ធ្វើឆ្នាំនេះនឹងបានចប់',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Wu Gui', chineseName: '五鬼', englishTranslation: 'Five Ghosts'),
      _StarInfo(khmerName: 'Guan Fu', chineseName: '官符', englishTranslation: 'Legal Notice'),
      _StarInfo(khmerName: 'Pi Tou', chineseName: '披頭', englishTranslation: 'Scruffy Hair'),
    ],
    inauspiciousWarnings:
        'មនុស្សល្អិតល្អោចនាំរឿងឥតបានការក្លាយជារឿងធំ តែបើចេះប្រើខ្មោចអោយបាយស៊ី នឹងបានផ្ទុះលាភ ជំលោះកន្លែងការងារ រកស៊ី អ្នកចូលហ៊ុន ប្រយ័ត្ន សោកសៅ បាត់ដំណឹង លាហើយមិនងាកក្រោយ បើបាត់របស់ពិបាករកឃើញ មនុស្សនៅនឹងមុខលាជារៀងរហូត លែងលះពិបាកយកគ្នា។',
  ),
  _ZodiacForecast(
    id: 'pig',
    englishName: 'Pig',
    chineseName: '猪',
    assetPath:
        'assets/c__Users_sothy_AppData_Roaming_Cursor_User_workspaceStorage_867b90d3f467249f0f4d0b1da278e5de_images_image-364ac169-f1bb-4ed0-84a9-ec5d58dd6dec.png',
    auspiciousStars: [
      _StarInfo(khmerName: 'Yue De', chineseName: '月德', englishTranslation: 'Monthly Virtue'),
      _StarInfo(khmerName: 'Yu Tang', chineseName: '玉堂', englishTranslation: 'Jade Hall'),
    ],
    auspiciousPredictions:
        'កិច្ចខំប្រឹងប្រែងជាច្រើនឆ្នាំនឹងបានគេទទួលស្គាល់ ដល់ពេលអោបយកលាភ និងសមិទ្ធិផល។ លុយកាក់នឹងមានបានច្រើនឡើងវិញឆ្នាំនេះ បើប្រលងនឹងជាប់ នឹងបានតាំងស៊ប់ អ្នកធំ អ្នកស្រលាញ់ នឹងជ្រោមជ្រែង',
    inauspiciousStars: [
      _StarInfo(khmerName: 'Xiao Hao', chineseName: '小耗', englishTranslation: 'Small Waste'),
      _StarInfo(khmerName: 'Si Fu', chineseName: '死符', englishTranslation: 'Death Note'),
      _StarInfo(khmerName: 'You Yi', chineseName: '遊奕', englishTranslation: 'Aimless Wander'),
    ],
    inauspiciousWarnings:
        'បាត់របស់លុយកាក់ ចាញ់បោកគេ បាត់មនុស្សចាស់ក្នុងផ្ទះ បាត់សមាជិកដែលធ្លាប់ស្រលាញ់ ជំងឺបៀតបៀនខ្លួន រឺនឹងឆ្លង ពិបាកព្យាបាល អ្នកក្លាហានឯកោ នឹងប្តូរការងារ ពិបាកមុនស្រណុកក្រោយ',
  ),
];

extension _ZodiacForecastExtension on _ZodiacForecast {
  bool get hasDetailedContent =>
      (auspiciousStars != null && auspiciousStars!.isNotEmpty) ||
      (inauspiciousStars != null && inauspiciousStars!.isNotEmpty);
}

class _SimpleZodiacContent extends StatelessWidget {
  const _SimpleZodiacContent({
    required this.zodiac,
    required this.l10n,
  });

  final _ZodiacForecast zodiac;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${_zodiacDisplayName(l10n, zodiac.id)} • ${zodiac.chineseName}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.accentLight,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _DetailedZodiacContent extends StatelessWidget {
  const _DetailedZodiacContent({
    required this.zodiac,
    required this.isMobile,
    required this.l10n,
    required this.locale,
    required this.content,
  });

  final _ZodiacForecast zodiac;
  final bool isMobile;
  final AppLocalizations l10n;
  final String locale;
  final ZodiacForecastContent? content;

  @override
  Widget build(BuildContext context) {
    final hasAuspicious =
        zodiac.auspiciousStars != null && zodiac.auspiciousStars!.isNotEmpty;
    final hasInauspicious =
        zodiac.inauspiciousStars != null && zodiac.inauspiciousStars!.isNotEmpty;
    final predictions = content?.auspiciousPredictions ?? zodiac.auspiciousPredictions;
    final warnings = content?.inauspiciousWarnings ?? zodiac.inauspiciousWarnings;
    final displayName = _zodiacDisplayName(l10n, zodiac.id);

    final birthYears = _getZodiacBirthYears(zodiac.id);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    zodiac.chineseName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.accentLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.accentLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final year in birthYears)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                year.toString(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.accentLight,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
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
          ],
        ),
        const SizedBox(height: 28),
        // Zodiac chips outside containers
        Row(
          children: [
            if (hasAuspicious)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accentLight.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    l10n.forecastYearBingWu,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.accentLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            if (hasAuspicious && hasInauspicious) const SizedBox(width: 16),
            if (hasInauspicious)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57373).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE57373).withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    l10n.forecastYearSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFE57373),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 24,
          alignment: Alignment.center,
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  AppColors.accent.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.6),
                  AppColors.accent.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Auspicious & Inauspicious sections
        if (isMobile) ...[
          if (hasAuspicious)
            _StarsSection(
              title: l10n.forecastAuspiciousStars,
              stars: zodiac.auspiciousStars!,
              predictions: predictions,
              isAuspicious: true,
              locale: locale,
            ),
          if (hasAuspicious && hasInauspicious) const SizedBox(height: 16),
          if (hasInauspicious)
            _StarsSection(
              title: l10n.forecastInauspiciousStars,
              stars: zodiac.inauspiciousStars!,
              warnings: warnings,
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
                      predictions: predictions,
                      isAuspicious: true,
                      locale: locale,
                    ),
                  ),
                if (hasAuspicious && hasInauspicious) const SizedBox(width: 16),
                if (hasInauspicious)
                  Expanded(
                    child: _StarsSection(
                      title: l10n.forecastInauspiciousStars,
                      stars: zodiac.inauspiciousStars!,
                      warnings: warnings,
                      isAuspicious: false,
                      locale: locale,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

String _starDisplayPrimary(_StarInfo star, String locale) {
  switch (locale) {
    case 'zh':
      return star.chineseName;
    case 'km':
      return star.khmerName;
    default:
      return star.englishTranslation;
  }
}

String _starDisplaySecondary(_StarInfo star, String locale) {
  switch (locale) {
    case 'zh':
      return star.englishTranslation;
    case 'km':
      return '${star.chineseName} · ${star.englishTranslation}';
    default:
      return star.chineseName;
  }
}

class _StarsSection extends StatelessWidget {
  const _StarsSection({
    required this.title,
    required this.stars,
    this.predictions,
    this.warnings,
    required this.isAuspicious,
    required this.locale,
  });

  final String title;
  final List<_StarInfo> stars;
  final String? predictions;
  final String? warnings;
  final bool isAuspicious;
  final String locale;

  static const _auspiciousColor = AppColors.accentLight;
  static const _inauspiciousColor = Color(0xFFE57373);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleColor = isAuspicious ? _auspiciousColor : _inauspiciousColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAuspicious
              ? AppColors.accent.withValues(alpha: 0.35)
              : _inauspiciousColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAuspicious ? Icons.auto_awesome : Icons.warning_amber_rounded,
                size: 20,
                color: titleColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final star in stars)
                SizedBox(
                  width: 150,
                  height: 64,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: titleColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: titleColor.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _starDisplayPrimary(star, locale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _starDisplaySecondary(star, locale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if ((predictions != null && predictions!.isNotEmpty) ||
              (warnings != null && warnings!.isNotEmpty)) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.overlayDark.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                predictions ?? warnings ?? '',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                  height: 1.65,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
