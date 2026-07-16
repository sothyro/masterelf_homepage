import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'app_content.dart';
import 'field_work_activity_cards.dart';
import '../l10n/app_localizations.dart';

/// Activity category for field work posts.
enum FieldWorkRealm {
  office,
  ritual,
  site;

  static FieldWorkRealm? fromQuery(String? value) {
    if (value == null || value.isEmpty || value == 'all') return null;
    return switch (value) {
      'office' => FieldWorkRealm.office,
      'ritual' => FieldWorkRealm.ritual,
      'site' => FieldWorkRealm.site,
      _ => null,
    };
  }

  String queryValue() => name;
}

class LocalizedCopy {
  const LocalizedCopy({
    required this.en,
    required this.km,
    required this.zh,
  });

  final String en;
  final String km;
  final String zh;

  String forLocale(String languageCode) {
    return switch (languageCode) {
      'km' => km,
      'zh' => zh,
      _ => en,
    };
  }
}

/// Documented real-world Master Elf activity (consultation, ritual, site visit).
class FieldWorkPost {
  const FieldWorkPost({
    required this.id,
    required this.slug,
    required this.realm,
    required this.date,
    required this.location,
    required this.title,
    required this.outcome,
    required this.body,
    required this.coverImage,
    this.galleryImages = const [],
    this.videoAsset,
    this.serviceId,
    this.featured = false,
  });

  final String id;
  final String slug;
  final FieldWorkRealm realm;
  final DateTime date;
  final LocalizedCopy location;
  final LocalizedCopy title;
  final LocalizedCopy outcome;
  final LocalizedCopy body;
  final String coverImage;
  final List<String> galleryImages;
  final String? videoAsset;
  /// Consultation service id: bazi, fengshui, maosan, etc.
  final String? serviceId;
  final bool featured;

  bool get hasVideo => videoAsset != null && videoAsset!.isNotEmpty;

  String localizedLocation(String locale) => location.forLocale(locale);
  String localizedTitle(String locale) => title.forLocale(locale);
  String localizedOutcome(String locale) => outcome.forLocale(locale);
  String localizedBody(String locale) => body.forLocale(locale);

  String? consultationPath() {
    if (serviceId == null || serviceId!.isEmpty) return null;
    return '/consultations?service=$serviceId';
  }
}

/// All curated field work posts (newest first).
final List<FieldWorkPost> kFieldWorkPosts = [
  FieldWorkPost(
    id: 'site-shophouse-audit',
    slug: 'feng-shui-shophouse-audit-phnom-penh',
    realm: FieldWorkRealm.site,
    date: DateTime(2026, 3, 12),
    location: LocalizedCopy(
      en: 'Phnom Penh',
      km: 'ភ្នំពេញ',
      zh: '金边',
    ),
    title: LocalizedCopy(
      en: 'Feng Shui site visit — commercial shophouse',
      km: 'ទស្សនាវាលហុងស៊ុយ — ផ្ទះហាងពាណិជ្ជកម្ម',
      zh: '风水实地勘察 — 商业店屋',
    ),
    outcome: LocalizedCopy(
      en: 'Compass readings and landform assessment for Period 9 alignment before opening.',
      km: 'ការអានខ្យុង និងវាយតម្លៃរូបរាងដីសម្រាប់សម្របយុគទី ៩ មុនពេលបើកដំណើរ។',
      zh: '为开业前进行罗盘读数与地貌评估，配合九运布局。',
    ),
    body: LocalizedCopy(
      en:
          'On-site Feng Shui audit at a commercial shophouse in Phnom Penh. We recorded facing direction, assessed the four celestial animals landform, and noted recommendations for the client\'s opening timeline.\n\nThis is the kind of work we document so you can see how classical methods are applied in real buildings—not only in theory.',
      km:
          'ការត្រវែងហុងស៊ុយ (Feng Shui) នៅផ្ទះហាងពាណិជ្ជកម្មនៅភ្នំពេញ។ យើងកត់ត្រាទិសមុខ វាយតម្លៃរូបរាងសត្វអប្សរាចតុកោណ និងណែនាំពេលវេលាបើកដំណើរសម្រាប់អតិថិជន។\n\nនេះជាការងារពិតដែលយើងឯកសារ ដើម្បីឱ្យអ្នកឃើញវិធីបុរាណត្រូវបានអនុវត្តក្នុងអគារពិត—មិនមែនតែក្នុងទ្រឹស្តីទេ។',
      zh:
          '在金边一座商业店屋进行实地风水勘察。我们记录朝向、评估四灵地貌，并就开业时机向客户提出建议。\n\n我们记录真实工作，让您看到经典方法如何应用于真实建筑，而非仅停留在理论。',
    ),
    coverImage: AppContent.assetActivityFengShui,
    galleryImages: [
      AppContent.assetActivityFengShui,
      AppContent.assetDirection,
      AppContent.assetConsultation,
    ],
    serviceId: 'fengshui',
    featured: true,
  ),
  FieldWorkPost(
    id: 'ritual-mao-shan-office',
    slug: 'mao-shan-office-blessing-victory-city',
    realm: FieldWorkRealm.ritual,
    date: DateTime(2026, 2, 28),
    location: LocalizedCopy(
      en: 'Victory City Office',
      km: 'ការិយាល័យ Victory City',
      zh: 'Victory City 办公室',
    ),
    title: LocalizedCopy(
      en: 'Mao Shan (Mao San) ritual — office space blessing',
      km: 'ពិធីម៉ៅសាន (Mao Shan) — ពរឧស្សាហកម្មការិយាល័យ',
      zh: '茅山仪式 — 办公空间祈福',
    ),
    outcome: LocalizedCopy(
      en: 'Ceremony to clear and align the workspace for the new business cycle.',
      km: 'ពិធីសម្អាត និងសម្របកន្លែងធ្វើការសម្រាប់វដ្តអាជីវកម្មថ្មី។',
      zh: '为新商业周期净化并调整办公空间气场。',
    ),
    body: LocalizedCopy(
      en:
          'Mao Shan ritual performed at a client office to support a fresh start. Setup, invocation, and placement followed classical form within Master Elf\'s system.\n\nRituals are documented respectfully—focusing on the space, altar, and ceremonial flow rather than private details.',
      km:
          'ពិធីម៉ៅសាន (Mao Shan) នៅការិយាល័យអតិថិជន ដើម្បីគាំទ្រការចាប់ផ្តើមថ្មី។ ការរៀបចំ ពិធី និងការដាក់ទីតាមទម្រង់បុរាណក្នុងប្រព័ន្ធ Master Elf។\n\nយើងឯកសារពិធីដោយគោរព—ផ្តោតលើកន្លែង ពិធីការ និងលំហូរពិធី មិនមែនព័ត៌មានផ្ទាល់ខ្លួនទេ។',
      zh:
          '在客户办公室举行茅山仪式，助力全新开始。布置、启请与安放均遵循 Master Elf 体系中的经典仪轨。\n\n我们以尊重的方式记录仪式——聚焦空间、法坛与流程，而非私人细节。',
    ),
    coverImage: AppContent.assetActivityMaoShan,
    galleryImages: [AppContent.assetActivityMaoShan, AppContent.assetRegistration],
    serviceId: 'maosan',
  ),
  FieldWorkPost(
    id: 'office-bazi-reading',
    slug: 'bazi-consultation-master-elf-office',
    realm: FieldWorkRealm.office,
    date: DateTime(2026, 2, 20),
    location: LocalizedCopy(
      en: 'Master Elf Office, Phnom Penh',
      km: 'ការិយាល័យ Master Elf ភ្នំពេញ',
      zh: 'Master Elf 金边办公室',
    ),
    title: LocalizedCopy(
      en: 'BaZi (BaZi) consultation at the office',
      km: 'ការពិគ្រោះប៉ាជឺ (BaZi) នៅការិយាល័យ',
      zh: '办公室八字咨询',
    ),
    outcome: LocalizedCopy(
      en: 'Birth chart plotted and discussed for career timing and personal direction.',
      km: 'គូរក្រាបកំណើត និងពិភាក្សាពេលវេលាអាជីវកម្ម និងទិសដៅផ្ទាល់ខ្លួន។',
      zh: '排盘并讨论事业时机与个人方向。',
    ),
    body: LocalizedCopy(
      en:
          'A one-to-one BaZi session at our Victory City office. Charts, timing cycles, and practical next steps—documented here so prospective clients know what a real consultation looks like.',
      km:
          'វគ្គប៉ាជឺ (BaZi) ផ្ទាល់ខ្លួននៅការិយាល័យ Victory City របស់យើង។ ក្រាប វដ្តពេលវេលា និងជំហានបន្ទាប់ជាក់ស្តែង—ឯកសារនេះឱ្យអតិថិជនឃើញការពិគ្រោះពិតយ៉ាងដូចម្តេច។',
      zh:
          '在我们 Victory City 办公室进行一对一八字咨询。命盘、运程与可执行的下一步——在此记录，让潜在客户了解真实咨询过程。',
    ),
    coverImage: AppContent.assetActivityConsultation,
    galleryImages: [AppContent.assetActivityConsultation, AppContent.assetAboutHero],
    serviceId: 'bazi',
  ),
  FieldWorkPost(
    id: 'site-compass-reading',
    slug: 'luo-pan-site-reading-commercial',
    realm: FieldWorkRealm.site,
    date: DateTime(2026, 2, 8),
    location: LocalizedCopy(
      en: 'Steung Meanchey',
      km: 'ស្ទឹងមានជ័យ',
      zh: '铁桥头',
    ),
    title: LocalizedCopy(
      en: 'On-site compass readings — new development',
      km: 'ការអានខ្យុងនៅវាល — គម្រោងអភិវឌ្ឍថ្មី',
      zh: '新开发项目现场罗盘读数',
    ),
    outcome: LocalizedCopy(
      en: 'Facing and sitting directions recorded for Flying Star chart preparation.',
      km: 'កត់ត្រាទិសមុខ និងទិសអង្គុយសម្រាប់រៀបក្រាហ្វតារាហោះហើរ។',
      zh: '记录向与坐向，为飞星盘做准备。',
    ),
    body: LocalizedCopy(
      en:
          'Field visit to a developing commercial property. Multiple compass readings taken to establish accurate facing for Xuan Kong Flying Star analysis.',
      km:
          'ទស្សនាវាលអចលនទ្រព្យពាណិជ្ជកម្មកំពុងអភិវឌ្ឍ។ ការអានខ្យុងច្រើនដងដើម្បីកំណត់ទិសមុខឱ្យត្រឹមត្រូវសម្រាប់វិភាគតារាហោះហើរស៊ួនកុង (Xuan Kong)។',
      zh:
          '勘察一处在建商业物业。多次罗盘读数以确定准确朝向，用于玄空飞星分析。',
    ),
    coverImage: AppContent.assetActivityFengShui,
    galleryImages: [AppContent.assetActivityFengShui, AppContent.assetDirection],
    serviceId: 'fengshui',
  ),
  FieldWorkPost(
    id: 'ritual-home-blessing',
    slug: 'mao-shan-home-blessing-phnom-penh',
    realm: FieldWorkRealm.ritual,
    date: DateTime(2026, 1, 25),
    location: LocalizedCopy(
      en: 'Phnom Penh',
      km: 'ភ្នំពេញ',
      zh: '金边',
    ),
    title: LocalizedCopy(
      en: 'Mao Shan home blessing ceremony',
      km: 'ពិធីពរផ្ទះម៉ៅសាន (Mao Shan)',
      zh: '茅山住家祈福仪式',
    ),
    outcome: LocalizedCopy(
      en: 'House blessing before move-in; remedies placed per classical purpose.',
      km: 'ពរផ្ទះមុនចូលស្នាក់នៅ ដាក់ថ្នាំបន្ថយតាមគោលបំណងបុរាណ។',
      zh: '入住前住家祈福；按传统目的安放化解物品。',
    ),
    body: LocalizedCopy(
      en:
          'Home blessing for a family preparing to move into a new residence. The ritual supports peace, protection, and harmony in the dwelling.',
      km:
          'ពិធីពរផ្ទះសម្រាប់គ្រួសារត្រៀមចូលផ្ទះថ្មី។ ពិធីគាំទ្រសន្តិភាព ការពារ និងភាពព្រមព្រៀងក្នុងទីជម្រក។',
      zh:
          '为即将搬入新居的家庭举行住家祈福，助力安宁、护佑与和谐。',
    ),
    coverImage: AppContent.assetActivityMaoShan,
    galleryImages: [AppContent.assetActivityMaoShan, AppContent.assetAboutHero],
    serviceId: 'maosan',
  ),
  FieldWorkPost(
    id: 'office-strategy-session',
    slug: 'qimen-strategy-office-session',
    realm: FieldWorkRealm.office,
    date: DateTime(2026, 1, 15),
    location: LocalizedCopy(
      en: 'Master Elf Office',
      km: 'ការិយាល័យ Master Elf',
      zh: 'Master Elf 办公室',
    ),
    title: LocalizedCopy(
      en: 'Strategy consultation — Qi Men & timing',
      km: 'ការពិគ្រោះយុទ្ធសាស្ត្រ — ឈីមិនទុនជា (Qi Men) និងពេលវេលា',
      zh: '战略咨询 — 奇门与择时',
    ),
    outcome: LocalizedCopy(
      en: 'Complex business decision framed with strategic timing insight.',
      km: 'ការសម្រេចចិត្តអាជីវកម្មស្មុយស្មាញត្រូវបានដោះស្រាយដោយពេលវេលាយុទ្ធសាស្ត្រ។',
      zh: '以战略择时视角梳理复杂商业决策。',
    ),
    body: LocalizedCopy(
      en:
          'Office session combining Qi Men Dunjia perspective with practical planning. Clients see how ancient strategy tools support modern decisions.',
      km:
          'វគ្គនៅការិយាល័យរួមបញ្ចូលទស្សនៈឈីមិនទុនជា (Qi Men Dunjia) ជាមួយការរៀបចំជាក់ស្តែង។ អតិថិជនឃើញឧបករណ៍យុទ្ធសាស្ត្របុរាណគាំទ្រការសម្រេចចិត្តសម័យទំនើប។',
      zh:
          '在办公室结合奇门遁甲视角与务实规划。让客户看到古老策略工具如何服务现代决策。',
    ),
    coverImage: AppContent.assetActivityConsultation,
    galleryImages: [AppContent.assetActivityConsultation, AppContent.assetConsultation],
    serviceId: 'qimeniching',
  ),
  FieldWorkPost(
    id: 'site-landform-review',
    slug: 'four-celestial-animals-landform-review',
    realm: FieldWorkRealm.site,
    date: DateTime(2025, 12, 18),
    location: LocalizedCopy(
      en: 'Phnom Penh outskirts',
      km: 'ជាយក្រុងភ្នំពេញ',
      zh: '金边郊区',
    ),
    title: LocalizedCopy(
      en: 'Landform review — four celestial animals',
      km: 'ពិនិត្យរូបរាងដី — សត្វអប្សរាចតុកោណ',
      zh: '地貌勘察 — 四灵',
    ),
    outcome: LocalizedCopy(
      en: 'Dragon, Tiger, Tortoise, and Phoenix positions assessed on site.',
      km: 'វាយតម្លៃទីតាំងនាគ ខ្លាស អណ្តើក និងភ្នុកស័រនៅវាលពិត។',
      zh: '现场评估青龙、白虎、玄武、朱雀方位。',
    ),
    body: LocalizedCopy(
      en:
          'Walking the site to read macro landform—the foundation of classical Feng Shui before any interior work begins.',
      km:
          'ដើររុករកវាលដើម្បីអានរូបរាងម៉ាក្រូ—មូលដ្ឋានហុងស៊ុយ (Feng Shui) បុរាណមុនពេលចាប់ការខាងក្នុង។',
      zh:
          '步行勘察场地解读宏观地貌——经典风水室内布局之前的根基。',
    ),
    coverImage: AppContent.assetActivityFengShui,
    galleryImages: [AppContent.assetActivityFengShui, AppContent.assetDirection],
    serviceId: 'fengshui',
  ),
  FieldWorkPost(
    id: 'ritual-business-opening',
    slug: 'mao-shan-business-opening-blessing',
    realm: FieldWorkRealm.ritual,
    date: DateTime(2025, 12, 5),
    location: LocalizedCopy(
      en: 'Commercial district',
      km: 'តំបន់ពាណិជ្ជកម្ម',
      zh: '商业区',
    ),
    title: LocalizedCopy(
      en: 'Business opening blessing — Mao Shan ritual',
      km: 'ពិធីពរបើកដំណើរអាជីវកម្ម — ម៉ៅសាន (Mao Shan)',
      zh: '开业祈福 — 茅山仪式',
    ),
    outcome: LocalizedCopy(
      en: 'Opening ceremony aligned with auspicious date selection.',
      km: 'ពិធីបើកដំណើរសម្របជាមួយការជ្រើសថ្ងៃហេង។',
      zh: '开业仪式配合吉日择选。',
    ),
    body: LocalizedCopy(
      en:
          'Ritual support for a new shop opening, coordinated with date selection work. Real outcomes start with real timing and real ceremony.',
      km:
          'ពិធីគាំទ្រការបើកហាងថ្មី សម្របជាមួយការជ្រើសរើសថ្ងៃ (Date Selection)។ លទ្ធផលពិតចាប់ផ្តើមពីពេលវេលា និងពិធីពិត។',
      zh:
          '为新店开业提供仪式支持，并与择日工作配合。真实成果始于真实时机与真实仪式。',
    ),
    coverImage: AppContent.assetActivityMaoShan,
    galleryImages: [AppContent.assetActivityMaoShan, AppContent.assetEventMain],
    serviceId: 'maosan',
  ),
];

/// Vertical 9:16 video spotlight on the Activities hub.
class ActivityVideoSpotlight {
  const ActivityVideoSpotlight({
    required this.id,
    required this.slug,
    required this.videoAsset,
    required this.posterImage,
    required this.realm,
    required this.title,
    required this.subtitle,
    this.serviceId,
  });

  final String id;
  final String slug;
  final String videoAsset;
  final String posterImage;
  final FieldWorkRealm realm;
  final String title;
  final String subtitle;
  final String? serviceId;

  String localizedTitle(String locale) => title;
  String localizedSubtitle(String locale) => subtitle;

  String? consultationPath() {
    if (serviceId == null || serviceId!.isEmpty) return null;
    return '/consultations?service=$serviceId';
  }

  String detailPath() => '/field-work/video/$slug';
}

ActivityVideoSpotlight? getActivityVideoBySlug(String slug) {
  for (final video in kActivityVideoSpotlights) {
    if (video.slug == slug) return video;
  }
  return null;
}

/// Resolves a video spotlight with localized title/subtitle for the current locale.
ActivityVideoSpotlight? getLocalizedActivityVideoBySlug(String slug, AppLocalizations l10n) {
  for (final video in buildActivityVideoSpotlights(l10n)) {
    if (video.slug == slug) return video;
  }
  return null;
}

/// Six spotlight videos (placeholder assets under assets/videos/activities/).
List<ActivityVideoSpotlight> buildActivityVideoSpotlights(AppLocalizations l10n) {
  return [
    ActivityVideoSpotlight(
      id: 'video-feng-shui-compass',
      slug: 'feng-shui-compass-on-site',
      videoAsset: AppContent.assetActivityVideo01,
      posterImage: AppContent.assetActivityFengShui,
      realm: FieldWorkRealm.site,
      title: l10n.fieldWorkVideoSpotlight1Title,
      subtitle: l10n.fieldWorkVideoSpotlight1Subtitle,
      serviceId: 'fengshui',
    ),
    ActivityVideoSpotlight(
      id: 'video-feng-shui-facing',
      slug: 'feng-shui-facing-sitting-directions',
      videoAsset: AppContent.assetActivityVideo02,
      posterImage: AppContent.assetActivityMaoShan,
      realm: FieldWorkRealm.site,
      title: l10n.fieldWorkVideoSpotlight2Title,
      subtitle: l10n.fieldWorkVideoSpotlight2Subtitle,
      serviceId: 'fengshui',
    ),
    ActivityVideoSpotlight(
      id: 'video-bazi-office',
      slug: 'bazi-consultation-office',
      videoAsset: AppContent.assetActivityVideo03,
      posterImage: AppContent.assetActivityConsultation,
      realm: FieldWorkRealm.office,
      title: l10n.fieldWorkVideoSpotlight3Title,
      subtitle: l10n.fieldWorkVideoSpotlight3Subtitle,
      serviceId: 'bazi',
    ),
    ActivityVideoSpotlight(
      id: 'video-qimen-strategy',
      slug: 'qimen-strategy-session',
      videoAsset: AppContent.assetActivityVideo04,
      posterImage: AppContent.assetActivityPhoto(5),
      realm: FieldWorkRealm.office,
      title: l10n.fieldWorkVideoSpotlight4Title,
      subtitle: l10n.fieldWorkVideoSpotlight4Subtitle,
      serviceId: 'qimeniching',
    ),
    ActivityVideoSpotlight(
      id: 'video-mao-shan-office',
      slug: 'mao-shan-office-blessing',
      videoAsset: AppContent.assetActivityVideo05,
      posterImage: AppContent.assetActivityPhoto(10),
      realm: FieldWorkRealm.ritual,
      title: l10n.fieldWorkVideoSpotlight5Title,
      subtitle: l10n.fieldWorkVideoSpotlight5Subtitle,
      serviceId: 'maosan',
    ),
    ActivityVideoSpotlight(
      id: 'video-date-selection',
      slug: 'date-selection-in-practice',
      videoAsset: AppContent.assetActivityVideo06,
      posterImage: AppContent.assetActivityPhoto(19),
      realm: FieldWorkRealm.office,
      title: l10n.fieldWorkVideoSpotlight6Title,
      subtitle: l10n.fieldWorkVideoSpotlight6Subtitle,
      serviceId: 'dateselection',
    ),
  ];
}

/// Static list for slug lookup (English titles; use [buildActivityVideoSpotlights] in UI).
final List<ActivityVideoSpotlight> kActivityVideoSpotlights = [
  ActivityVideoSpotlight(
    id: 'video-feng-shui-compass',
    slug: 'feng-shui-compass-on-site',
    videoAsset: AppContent.assetActivityVideo01,
    posterImage: AppContent.assetActivityFengShui,
    realm: FieldWorkRealm.site,
    title: 'Feng Shui site visit — compass on site',
    subtitle: 'On-location readings and landform assessment for a commercial property.',
    serviceId: 'fengshui',
  ),
  ActivityVideoSpotlight(
    id: 'video-feng-shui-facing',
    slug: 'feng-shui-facing-sitting-directions',
    videoAsset: AppContent.assetActivityVideo02,
    posterImage: AppContent.assetActivityMaoShan,
    realm: FieldWorkRealm.site,
    title: 'Feng Shui audit — facing and sitting directions',
    subtitle: 'Recording accurate directions for Flying Star analysis before interior work.',
    serviceId: 'fengshui',
  ),
  ActivityVideoSpotlight(
    id: 'video-bazi-office',
    slug: 'bazi-consultation-office',
    videoAsset: AppContent.assetActivityVideo03,
    posterImage: AppContent.assetActivityConsultation,
    realm: FieldWorkRealm.office,
    title: 'BaZi consultation at the office',
    subtitle: 'A one-to-one session—charts, timing, and practical next steps.',
    serviceId: 'bazi',
  ),
  ActivityVideoSpotlight(
    id: 'video-qimen-strategy',
    slug: 'qimen-strategy-session',
    videoAsset: AppContent.assetActivityVideo04,
    posterImage: AppContent.assetActivityPhoto(5),
    realm: FieldWorkRealm.office,
    title: 'Qi Men strategy session',
    subtitle: 'Ancient timing tools applied to modern business decisions.',
    serviceId: 'qimeniching',
  ),
  ActivityVideoSpotlight(
    id: 'video-mao-shan-office',
    slug: 'mao-shan-office-blessing',
    videoAsset: AppContent.assetActivityVideo05,
    posterImage: AppContent.assetActivityPhoto(10),
    realm: FieldWorkRealm.ritual,
    title: 'Mao Shan ritual — office blessing',
    subtitle: 'Ceremony to clear and align a workspace for a new business cycle.',
    serviceId: 'maosan',
  ),
  ActivityVideoSpotlight(
    id: 'video-date-selection',
    slug: 'date-selection-in-practice',
    videoAsset: AppContent.assetActivityVideo06,
    posterImage: AppContent.assetActivityPhoto(19),
    realm: FieldWorkRealm.office,
    title: 'Date Selection in practice',
    subtitle: 'Choosing auspicious timing for openings, signings, and milestones.',
    serviceId: 'dateselection',
  ),
];

FieldWorkPost? getFieldWorkPostBySlug(String slug) {
  for (final post in kFieldWorkPosts) {
    if (post.slug == slug) return post;
  }
  return null;
}

FieldWorkPost? getFeaturedFieldWorkPost() {
  for (final post in kFieldWorkPosts) {
    if (post.featured) return post;
  }
  return kFieldWorkPosts.isNotEmpty ? kFieldWorkPosts.first : null;
}

List<FieldWorkPost> getFieldWorkPosts({
  FieldWorkRealm? realm,
  bool videosOnly = false,
}) {
  var list = List<FieldWorkPost>.from(kFieldWorkPosts)
    ..sort((a, b) => b.date.compareTo(a.date));
  if (realm != null) {
    list = list.where((p) => p.realm == realm).toList();
  }
  if (videosOnly) {
    list = list.where((p) => p.hasVideo).toList();
  }
  return list;
}

List<FieldWorkPost> getHomeFieldWorkPosts({FieldWorkRealm? realm}) {
  final filtered = getFieldWorkPosts(realm: realm);
  final cards = <FieldWorkPost>[];
  for (final realmValue in FieldWorkRealm.values) {
    final realmPosts = filtered.where((p) => p.realm == realmValue).take(2);
    cards.addAll(realmPosts);
  }
  if (cards.length > 6) {
    cards.removeRange(6, cards.length);
  }
  return cards;
}

Color realmColor(FieldWorkRealm realm) {
  return switch (realm) {
    FieldWorkRealm.office => const Color(0xFFC9A227),
    FieldWorkRealm.ritual => const Color(0xFFB85C4A),
    FieldWorkRealm.site => const Color(0xFF4A8F7C),
  };
}

IconData iconForRealm(FieldWorkRealm realm) {
  return switch (realm) {
    FieldWorkRealm.office => LucideIcons.building2,
    FieldWorkRealm.ritual => LucideIcons.sparkles,
    FieldWorkRealm.site => LucideIcons.compass,
  };
}

/// Homepage showcase pillar (category card, not a journal entry).
class FieldWorkShowcasePillar {
  const FieldWorkShowcasePillar({
    required this.id,
    required this.coverImage,
    required this.realm,
    required this.title,
    required this.subtitle,
    required this.linkPath,
    required this.icon,
    required this.accentColor,
    this.titleCopy,
    this.subtitleCopy,
  });

  final String id;
  final String coverImage;
  final FieldWorkRealm realm;
  final String title;
  final String subtitle;
  final String linkPath;
  final IconData icon;
  final Color accentColor;
  final LocalizedCopy? titleCopy;
  final LocalizedCopy? subtitleCopy;

  String localizedTitle(String languageCode) =>
      titleCopy?.forLocale(languageCode) ?? title;

  String localizedSubtitle(String languageCode) =>
      subtitleCopy?.forLocale(languageCode) ?? subtitle;
}

/// Four fixed category pillars for the homepage grid.
List<FieldWorkShowcasePillar> buildFieldWorkCategoryPillars(AppLocalizations l10n) {
  return [
    FieldWorkShowcasePillar(
      id: 'feng-shui-site',
      coverImage: AppContent.assetActivityFengShui,
      realm: FieldWorkRealm.site,
      title: l10n.fieldWorkPillarFengShuiTitle,
      subtitle: l10n.fieldWorkPillarFengShuiSubtitle,
      linkPath: '/field-work?realm=site',
      icon: LucideIcons.compass,
      accentColor: realmColor(FieldWorkRealm.site),
    ),
    FieldWorkShowcasePillar(
      id: 'consultations',
      coverImage: AppContent.assetActivityConsultation,
      realm: FieldWorkRealm.office,
      title: l10n.fieldWorkPillarConsultTitle,
      subtitle: l10n.fieldWorkPillarConsultSubtitle,
      linkPath: '/field-work?realm=office',
      icon: LucideIcons.building2,
      accentColor: realmColor(FieldWorkRealm.office),
    ),
    FieldWorkShowcasePillar(
      id: 'mao-shan-blessing',
      coverImage: AppContent.assetActivityMaoShan,
      realm: FieldWorkRealm.ritual,
      title: l10n.fieldWorkPillarMaoShanTitle,
      subtitle: l10n.fieldWorkPillarMaoShanSubtitle,
      linkPath: '/field-work?realm=ritual',
      icon: LucideIcons.sparkles,
      accentColor: realmColor(FieldWorkRealm.ritual),
    ),
    FieldWorkShowcasePillar(
      id: 'date-selection',
      coverImage: AppContent.assetActivityDateSelection,
      realm: FieldWorkRealm.office,
      title: l10n.fieldWorkPillarDateSelectionTitle,
      subtitle: l10n.fieldWorkPillarDateSelectionSubtitle,
      linkPath: '/consultations?service=dateselection',
      icon: LucideIcons.calendarDays,
      accentColor: realmColor(FieldWorkRealm.office),
    ),
  ];
}

/// @deprecated Use [buildFieldWorkCategoryPillars].
List<FieldWorkShowcasePillar> buildHomeFieldWorkShowcase(AppLocalizations l10n) =>
    buildFieldWorkCategoryPillars(l10n);

/// Category pillars plus 29 photo cards for the Field Work page carousel.
List<FieldWorkShowcasePillar> buildFieldWorkCoreActivities(
  AppLocalizations l10n,
  String languageCode,
) {
  return [
    ...buildFieldWorkCategoryPillars(l10n),
    ...kFieldWorkPhotoCards.map((card) => card.toPillar(languageCode)),
  ];
}
