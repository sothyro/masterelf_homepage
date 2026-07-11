import '../l10n/app_localizations.dart';
import '../widgets/chinese_device_showcase.dart';
import 'app_content.dart';

/// Layout pattern for a feature group on the Apps page.
enum AppsGroupLayout {
  /// Cross-platform desktop, tablet, and browser hero (main menu).
  ecosystem,

  /// Horizontal scroll filmstrip (BaZi).
  strip,

  /// Three-up fit-width row (Marriage, Business) — no horizontal scroll.
  triptych,

  /// Single spotlight card.
  single,
}

/// A group of app screenshots with shared marketing copy.
class AppsFeatureGroup {
  const AppsFeatureGroup({
    required this.id,
    required this.title,
    required this.benefit,
    required this.assets,
    required this.layout,
    required this.preferredDevice,
    this.heroVideoAsset,
  });

  final String id;
  final String title;
  final String benefit;
  final List<String> assets;
  final AppsGroupLayout layout;
  final ChineseDeviceType preferredDevice;
  final String? heroVideoAsset;
}

/// Builds the Apps page feature atlas from localized strings.
List<AppsFeatureGroup> buildAppsShowcaseGroups(AppLocalizations l10n) {
  return [
    AppsFeatureGroup(
      id: 'overview',
      title: l10n.appsGroupOverview,
      benefit: l10n.appsGroupOverviewBenefit,
      assets: [AppContent.assetAppMainMenu],
      layout: AppsGroupLayout.ecosystem,
      preferredDevice: ChineseDeviceType.desktop,
      heroVideoAsset: AppContent.assetAppPageVideo,
    ),
    AppsFeatureGroup(
      id: 'bazi',
      title: l10n.appsGroupBazi,
      benefit: l10n.appsGroupBaziBenefit,
      assets: [
        AppContent.assetAppBazi01,
        AppContent.assetAppBazi02,
        AppContent.assetAppBazi03,
        AppContent.assetAppBazi04,
        AppContent.assetAppBazi05,
        AppContent.assetAppBazi06,
        AppContent.assetAppBazi07,
      ],
      layout: AppsGroupLayout.strip,
      preferredDevice: ChineseDeviceType.desktop,
    ),
    AppsFeatureGroup(
      id: 'qimen',
      title: l10n.appsGroupQiMen,
      benefit: l10n.appsGroupQiMenBenefit,
      assets: [AppContent.assetAppQiMen],
      layout: AppsGroupLayout.single,
      preferredDevice: ChineseDeviceType.browser,
    ),
    AppsFeatureGroup(
      id: 'date-selection',
      title: l10n.appsGroupDateSelection,
      benefit: l10n.appsGroupDateSelectionBenefit,
      assets: [AppContent.assetAppDateSelection],
      layout: AppsGroupLayout.single,
      preferredDevice: ChineseDeviceType.browser,
    ),
    AppsFeatureGroup(
      id: 'marriage',
      title: l10n.appsGroupMarriage,
      benefit: l10n.appsGroupMarriageBenefit,
      assets: [
        AppContent.assetAppCoupleCompatibility01,
        AppContent.assetAppCoupleCompatibility02,
        AppContent.assetAppCoupleCompatibility03,
      ],
      layout: AppsGroupLayout.triptych,
      preferredDevice: ChineseDeviceType.tablet,
    ),
    AppsFeatureGroup(
      id: 'business',
      title: l10n.appsGroupBusiness,
      benefit: l10n.appsGroupBusinessBenefit,
      assets: [
        AppContent.assetAppBusinessPartnership01,
        AppContent.assetAppBusinessPartnership02,
        AppContent.assetAppBusinessPartnership03,
      ],
      layout: AppsGroupLayout.triptych,
      preferredDevice: ChineseDeviceType.tablet,
    ),
    AppsFeatureGroup(
      id: 'fengshui-tools',
      title: l10n.appsGroupFengShuiTools,
      benefit: l10n.appsGroupFengShuiToolsBenefit,
      assets: [AppContent.assetAppFengShuiTools],
      layout: AppsGroupLayout.single,
      preferredDevice: ChineseDeviceType.browser,
    ),
    AppsFeatureGroup(
      id: 'iching',
      title: l10n.appsGroupIChing,
      benefit: l10n.appsGroupIChingBenefit,
      assets: [AppContent.assetAppIChing],
      layout: AppsGroupLayout.single,
      preferredDevice: ChineseDeviceType.browser,
    ),
  ];
}
