import 'app_content.dart';
import 'field_work_content.dart';

/// Consultation or realm filter link for an activity photo card.
String activityCardLinkPath(FieldWorkRealm realm, String serviceId) {
  return switch (serviceId) {
    'fengshui' => '/consultations?service=fengshui',
    'bazi' => '/consultations?service=bazi',
    'maosan' => '/consultations?service=maosan',
    'dateselection' => '/consultations?service=dateselection',
    'qimeniching' => '/consultations?service=qimeniching',
    _ => '/field-work?realm=${realm.queryValue()}',
  };
}

/// Photo-based activity card definition (Activities 1–29).
class FieldWorkPhotoCard {
  const FieldWorkPhotoCard({
    required this.id,
    required this.photoNum,
    required this.realm,
    required this.serviceId,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final int photoNum;
  final FieldWorkRealm realm;
  final String serviceId;
  final LocalizedCopy title;
  final LocalizedCopy subtitle;

  String get coverImage => AppContent.assetActivityPhoto(photoNum);

  FieldWorkShowcasePillar toPillar(String languageCode) {
    return FieldWorkShowcasePillar(
      id: id,
      coverImage: coverImage,
      realm: realm,
      title: title.forLocale(languageCode),
      subtitle: subtitle.forLocale(languageCode),
      titleCopy: title,
      subtitleCopy: subtitle,
      linkPath: activityCardLinkPath(realm, serviceId),
      icon: iconForRealm(realm),
      accentColor: realmColor(realm),
    );
  }
}

/// All 29 photo activity cards in display order.
final List<FieldWorkPhotoCard> kFieldWorkPhotoCards = [
  FieldWorkPhotoCard(
    id: 'activity-photo-01',
    photoNum: 1,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Construction Site Field Audit',
      km: 'ការត្រួតពិនិត្យទីតាំងសាងសង់',
      zh: '建筑工地实地勘察',
    ),
    subtitle: const LocalizedCopy(
      en: 'On-site notes and compass readings at active builds align every structure with prosperous Feng Shui energy.',
      km: 'កំណត់ត្រា និងការអានខ្យុងនៅទីតាំងសាងសង់ពិត សម្របរចនាសម្ព័ន្ធជាមួយថាមពលហុងស៊ុយ (Feng Shui) អំណោយផល។',
      zh: '在在建工地现场记录与罗盘读数，使建筑布局与旺盛的 Feng Shui 能量相合。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-02',
    photoNum: 2,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Seminar Graduation Milestone',
      km: 'ពិធីបញ្ចប់សិក្ខាសាលា',
      zh: '研讨会结业里程碑',
    ),
    subtitle: const LocalizedCopy(
      en: 'Celebrate your metaphysics certification with Master Elf after transformative seminar training.',
      km: 'អបអរសាទរវិញ្ញាបនបត្ររូបវិទ្យាចិនបុរាណជាមួយ Master Elf បន្ទាប់ពីបណ្តុះបណ្តល់ដ៏ផ្លាស់ប្តូរ។',
      zh: '在 Master Elf 变革性课程培训后，庆祝您获得玄学认证。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-03',
    photoNum: 3,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Luxury Villa Luopan Reading',
      km: 'ការអានលូផានវីឡាប្រណីត',
      zh: '豪宅罗盘勘测',
    ),
    subtitle: const LocalizedCopy(
      en: 'Precision compass measurements at elite residences channel wealth energy through every gate and driveway.',
      km: 'ការវាស់ខ្យុងចម្រុះនៅវីឡាប្រណីត បញ្ជូនថាមពលទ្រព្យតាមច្រកចូល និងផ្លូវចូលទាំងអស់។',
      zh: '在高端住宅进行精准罗盘测量，让财富能量贯通大门与车道。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-04',
    photoNum: 4,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Commercial Office Audit Complete',
      km: 'បញ្ចប់ការត្រួតពិនិត្យការិយាល័យ',
      zh: '商业办公风水审计完成',
    ),
    subtitle: const LocalizedCopy(
      en: 'Delivered Feng Shui findings at Bassac headquarters strengthen business prosperity from the reception desk up.',
      km: 'លទ្ធផលហុងស៊ុយ (Feng Shui) នៅការិយាល័យ Bassac ពង្រឹងភាពរុងរឿងអាជីវកម្មពីការិយាល័យទទួលភ្ញៀវឡើងទៅ។',
      zh: 'Bassac 总部风水勘察成果，从接待台起全面提升商业旺气。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-05',
    photoNum: 5,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Personal Talisman Blessing',
      km: 'ពិធីឧទ្ទិសស្តេចយ័ន្តផ្ទាល់ខ្លួន',
      zh: '个人符咒开光',
    ),
    subtitle: const LocalizedCopy(
      en: 'Sacred Mao Shan talismans connect discerning clients to ancestral protection drawn in black ink on yellow paper.',
      km: 'ស្តេចយ័ន្តម៉ៅសាន (Mao Shan) ភ្ជាប់អតិថិជនទៅការការពារបុរាណ ដែលគូរដោយទឹកខ្មែសលើក្រដាសលឿង។',
      zh: '茅山 (Mao Shan) 灵符以黄纸墨书，为有缘人连接祖先护佑。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-06',
    photoNum: 6,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Destiny Charts Delivered',
      km: 'ប្រគល់ក្រាបវាសនា',
      zh: '命盘交付',
    ),
    subtitle: const LocalizedCopy(
      en: 'Walk away with printed BaZi insights beside the masters who interpreted your Four Pillars destiny map.',
      km: 'ទទួលក្រាបប៉ាជឺ (BaZi) បោះពុម្ភ ជាមួយអ្នកមេដែលបកស្រាយសសរបួនជើងវាសនារបស់អ្នក។',
      zh: '携印制的 BaZi 命盘离开，与解读四柱命理的大师合影留念。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-07',
    photoNum: 7,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Client Gratitude Celebration',
      km: 'អបអរសាទរអតិថិជន',
      zh: '客户感恩留念',
    ),
    subtitle: const LocalizedCopy(
      en: 'Heartfelt gift baskets honor the trust built through life-changing destiny consultation sessions.',
      km: 'កញ្ចប់អំណោយគោរពទំនុកចិត្តដែលបង្កើតតាមរយៈវដ្តពិគ្រោះវាសនាដ៏ផ្លាស់ប្តូរជីវិត។',
      zh: '以心意礼盒致敬，感谢命运咨询中建立的深厚信任。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-08',
    photoNum: 8,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Bagua Blessing Ceremony',
      km: 'ពិធីអរពរបាកួយ',
      zh: '八卦祈福仪式',
    ),
    subtitle: const LocalizedCopy(
      en: 'Lotus offerings before the Eight Trigrams mark a sacred Mao Shan harmony ritual for spiritual balance.',
      km: 'ការបូជាផ្កាឈូកមុព្រះបាកួយ សម្គាល់ពិធីម៉ៅសាន (Mao Shan) សម្រាប់តុល្យភាពផ្លូវវិញ្ញាណ។',
      zh: '八卦前莲花供奉，标志茅山和谐祈福，平衡灵性能量。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-09',
    photoNum: 9,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Master Seminar Front Row',
      km: 'ជួរមុខសិក្ខាសាលាមេ',
      zh: '大师讲座前排',
    ),
    subtitle: const LocalizedCopy(
      en: 'Hundreds gather as Master Elf shares destiny wisdom from the theater stage with orchids and a microphone.',
      km: 'អ្នកចូលរួមរាប់រយនាក់ ស្តាប់ Master Elf ចែករំលែកបញ្ញាវាសនាពីឆាករៀងជាមួយផ្កាអ័រគីដេ។',
      zh: '数百人齐聚，Master Elf 于舞台分享命理智慧，兰花与话筒相伴。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-10',
    photoNum: 10,
    realm: FieldWorkRealm.office,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Harmony Desk Consultation',
      km: 'ការពិគ្រោះតុសុខដម',
      zh: '和谐桌面咨询',
    ),
    subtitle: const LocalizedCopy(
      en: 'Master Elf talismans and Feng Shui documents await beneath the Harmony & Balance banner at your session.',
      km: 'ស្តេចយ័ន្ត Master Elf និងឯកសារហុងស៊ុយ (Feng Shui) រង់ចាំក្រោមបដាសុខដម និងតុល្យភាព។',
      zh: 'Master Elf 灵符与 Feng Shui 文件，在和谐平衡横幅下等候您的咨询。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-11',
    photoNum: 11,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Hands Blessed, Spirits Awakened',
      km: 'ដៃទទួលពិធីអរពរ',
      zh: '双手受福，灵性觉醒',
    ),
    subtitle: const LocalizedCopy(
      en: 'Gentle ritual touch over scripture cards activates Mao Shan protection for every seeker who comes forward.',
      km: 'ការប៉ះដៃពិធីទន់ទាបលើកាតគម្ពីរ បើកថាមពលការពារម៉ៅសាន (Mao Shan) សម្រាប់អ្នកស្វែងរក។',
      zh: '仪式轻触经卡，为每一位求福者开启茅山护佑。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-12',
    photoNum: 12,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Storefront Entrance Review',
      km: 'ពិនិត្យច្រកហាង',
      zh: '店面入口勘察',
    ),
    subtitle: const LocalizedCopy(
      en: 'Traditional pub facades deserve compass-guided audits before doors open to welcome prosperous foot traffic.',
      km: 'ផ្ទះល្វែងបុរាណគួរត្រូវបានពិនិត្យខ្យុងមុនពេលបើកទ្វារទទួលអតិថិជនហេង។',
      zh: '传统门面开业前宜以罗盘勘察，迎接旺盛客流。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-13',
    photoNum: 13,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Talisman Presentation Ceremony',
      km: 'ពិធីប្រគល់ស្តេចយ័ន្ត',
      zh: '符咒颁授仪式',
    ),
    subtitle: const LocalizedCopy(
      en: 'Receive your consecrated yellow Mao Shan scroll before the guardian deity altar in a formal blessing.',
      km: 'ទទួលក្រដាសលឿងម៉ៅសាន (Mao Shan) ដែលបានឧទ្ទិសមុព្រះវិញ្ញាណការពារ។',
      zh: '在护法神台前，正式领取开光黄色茅山灵符。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-14',
    photoNum: 14,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Beauty Clinic Site Blessing',
      km: 'ពិធីអរពរទីតាំងគ្លីនិក',
      zh: '美容诊所实地祈福',
    ),
    subtitle: const LocalizedCopy(
      en: 'Elevate salon energy at N.22 with festive Feng Shui alignment that attracts clients and prosperity.',
      km: 'លើកថាមពល N.22 Beauty Klinik ជាមួយការសម្របហុងស៊ុយ (Feng Shui) ទទួលអតិថិជន និងទ្រព្យ។',
      zh: '以喜庆 Feng Shui 布局提升 N.22 美容诊所能量，招徕客源与财运。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-15',
    photoNum: 15,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Raw Land Compass Survey',
      km: 'ស្ទង់ខ្យុងលើដីទទេ',
      zh: '空地罗盘勘测',
    ),
    subtitle: const LocalizedCopy(
      en: 'Squat beside the master as Luopan readings reveal the fortune buried in bare, undeveloped earth.',
      km: 'អង្គុយក្បែរមេដើម្បីអានលូផាន បង្ហាញវាសនាលាក់កំបាំងក្នុងដីទទេ។',
      zh: '蹲身大师身旁，以罗盘读数揭示裸土中潜藏的地运。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-16',
    photoNum: 16,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Estate Corner Assessment',
      km: 'វាយតម្លៃមុំគម្រោងអភិវឌ្ឍន៍',
      zh: '楼盘转角评估',
    ),
    subtitle: const LocalizedCopy(
      en: 'Tablet in hand, every street junction and villa facade receives strategic Feng Shui review on site.',
      km: 'ដៃកាន់ថេប្លេត ពិនិត្យផ្លូវបំបែក និងផ្ទះវីឡាទាំងអស់តាមយុទ្ធសាស្ត្រហុងស៊ុយ (Feng Shui)។',
      zh: '手持平板，于现场战略审视每个路口与别墅立面风水。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-17',
    photoNum: 17,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Outdoor Luo Pan Briefing',
      km: 'ណែនាំលូផានក្រៅផ្ទះ',
      zh: '户外罗盘讲解',
    ),
    subtitle: const LocalizedCopy(
      en: 'Clients learn land orientation secrets as the master reads compass rings aloud at an outdoor site.',
      km: 'អតិថិជនរៀនអំណោយផលទិសដី ខណៈមេអានខ្យុងលូផានឱ្យឮនៅទីតាំងពិត។',
      zh: '大师于户外现场朗读罗盘圈层，传授地块朝向要诀。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-18',
    photoNum: 18,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Open Field Compass Mastery',
      km: 'លូផានលើវាលទំនេរ',
      zh: '旷野罗盘精研',
    ),
    subtitle: const LocalizedCopy(
      en: 'Traditional Luopan meets modern tablet on sunlit plots destined for prosperous new development.',
      km: 'លូផានបុរាណ និងថេប្លេតទំនើបនៅដីពន្លឺថ្ងៃ សម្រាប់គម្រោងអភិវឌ្ឍន៍ថ្មីហេង។',
      zh: '传统罗盘与现代平板并用于阳光地块，奠基兴旺新开发。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-19',
    photoNum: 19,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Altar Offerings and Incense',
      km: 'បូជាព្រះវិញ្ញាណ និងធូប',
      zh: '供品焚香',
    ),
    subtitle: const LocalizedCopy(
      en: 'Whole chicken, fruit, and red candles honor deities in solemn Mao Shan blessing rites at the altar.',
      km: 'មាន់ទាំងក្បាល ផ្លែឈើ និងទៀនក្រហម គោរពទេវតាក្នុងពិធីម៉ៅសាន (Mao Shan) ដ៏ពិរិទ្ធិ។',
      zh: '全鸡、鲜果与红烛，于祭坛举行庄严的茅山祈福礼敬神明。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-20',
    photoNum: 20,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Statue Consecration by Light',
      km: 'ឧទ្ទិសរូបដោយពន្លឺ',
      zh: '神像开光引灵',
    ),
    subtitle: const LocalizedCopy(
      en: 'Ceremonial green light awakens divine presence within a golden figurine placed on ritual yellow cloth.',
      km: 'ពន្លឺបៃតងពិធីបើកថាមពលទេវតានៅក្នុងរូបមាសលើក្រដាសលឿងពិធី។',
      zh: '仪式绿光唤醒金黄神像内的神圣灵性，置于黄色法布之上。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-21',
    photoNum: 21,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Kneeling Talisman Fan Ritual',
      km: 'ពិធីអធិដ្ឋានអចុយអធិដ្ឋាន',
      zh: '跪式符扇仪式',
    ),
    subtitle: const LocalizedCopy(
      en: 'Red-calligraphy fans and noodle offerings complete a floor-level Mao Shan devotion performed with solemn focus.',
      km: 'អចុយអធិដ្ឋានកាត់ក្រហម និងបូជាមី បញ្ចប់ពិធីម៉ៅសាន (Mao Shan) កម្រិតជាន់ផ្ទ៉ា។',
      zh: '朱红符扇与面条供品，完成庄严的地面茅山修持。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-22',
    photoNum: 22,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Eye-Dotting Kaiguang Rite',
      km: 'ពិធីបើកកន្ត្រាក់ (开眼)',
      zh: '点睛开光仪式',
    ),
    subtitle: const LocalizedCopy(
      en: 'Cinnabar brush awakens the spirit within every golden deity figurine through the sacred eye-opening ceremony.',
      km: 'ច្នុហ្វេពិធីបើកភ្នែកភ្ញាញ់ បើកវិញ្ញាណក្នុងរូបមាសទេវតារាល់អង្គ។',
      zh: '朱砂笔点睛，以神圣开眼礼唤醒金身神像灵性。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-23',
    photoNum: 23,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'BaZi Chart Deep Dive',
      km: 'វិភាគក្រាបប៉ាជឺជ្រៅ',
      zh: '八字命盘深度解读',
    ),
    subtitle: const LocalizedCopy(
      en: 'Your Four Pillars destiny map explained point by point at the consultation desk with Master Elf.',
      km: 'ក្រាបសសរបួនជើងប៉ាជឺ (BaZi) បកស្រាយជាបន្តបន្ទាប់នៅតុពិគ្រោះជាមួយ Master Elf។',
      zh: '于咨询桌前，Master Elf 逐点解读您的四柱 BaZi 命盘。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-24',
    photoNum: 24,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Grand Mansion Gate Review',
      km: 'ពិនិត្យច្រកវិឡាដ៏ធំ',
      zh: '豪宅大门勘察',
    ),
    subtitle: const LocalizedCopy(
      en: 'Neoclassical estates and luxury driveways receive expert on-site energy assessment before you build.',
      km: 'វិឡាបុរាណថ្មី និងផ្លូវចូលប្រណីត ទទួលការវាយតម្លៃថាមពលហុងស៊ុយ (Feng Shui) មុនសាងសង់។',
      zh: '新古典庄园与豪华车道，动工前接受专业现场能量评估。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-25',
    photoNum: 25,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Couple Destiny Session',
      km: 'វដ្តពិគ្រោះគូស្នេហ៍',
      zh: '夫妻命理咨询',
    ),
    subtitle: const LocalizedCopy(
      en: 'Face-to-face BaZi guidance helps partners align life plans beneath the dragon wall art and mandala poster.',
      km: 'ការណែនាំប៉ាជឺ (BaZi) ផ្ទាល់ជួយគូស្នេហ៍សម្របផែនការជីវិតក្រោមផ្ទាំងមណ្ឌលា Master Elf។',
      zh: '面对面 BaZi 指导，助伴侣在 Master Elf 曼陀罗海报下协调人生规划。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-26',
    photoNum: 26,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'White Shirt Office Reading',
      km: 'ការអានការិយាល័យ',
      zh: '白衬衫办公室解读',
    ),
    subtitle: const LocalizedCopy(
      en: 'Couples receive personalized metaphysical counsel across a desk lined with ritual envelopes and documents.',
      km: 'គូស្នេហ៍ទទួលការណែនាំផ្ទាល់ខ្លួនតាមតុដែលមានស្រោមពិធី និងឯកសារ។',
      zh: '夫妻于摆满法事信封与文件的桌前，接受个性化玄学指导。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-27',
    photoNum: 27,
    realm: FieldWorkRealm.office,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Development Blueprint Strategy',
      km: 'យុទ្ធសាស្ត្រផែនការអភិវឌ្ឍន៍',
      zh: '开发蓝图战略',
    ),
    subtitle: const LocalizedCopy(
      en: 'Multi-storey site plans and Period charts merge on screen for investment-grade Feng Shui consultation.',
      km: 'ផែនការអគារពហុជាន់ និងក្រាហ្វយុគ រួមបញ្ចូលគ្នាលើអេក្រង់សម្រាប់ពិគ្រោះហុងស៊ុយ (Feng Shui) កម្រិតវិនិយោគ។',
      zh: '多层平面图与运期图表同屏呈现，投资级 Feng Shui 咨询。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-28',
    photoNum: 28,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Young Couple Consultation Day',
      km: 'ថ្ងៃពិគ្រោះគូវ័យក្មេង',
      zh: '年轻伴侣咨询日',
    ),
    subtitle: const LocalizedCopy(
      en: 'Pose with your master beside yellow scrolls after a transformative destiny reading in the consultation room.',
      km: 'ថតរូបជាមួយមេក្រោយអានវាសនាដ៏ផ្លាស់ប្តូរ ក្បែរក្រដាសលឿងក្នុងបន្ទប់ពិគ្រោះ។',
      zh: '命运解读后，于咨询室黄卷旁与大师合影留念。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-29',
    photoNum: 29,
    realm: FieldWorkRealm.office,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Floorplan Luopan Analysis',
      km: 'វិភាគផែនការជាមួយលូផាន',
      zh: '平面图罗盘分析',
    ),
    subtitle: const LocalizedCopy(
      en: 'Architectural blueprints and a red compass together reveal hidden layout opportunities for your property.',
      km: 'ប្លង់ស្ថាបត្យកម្ម និងខ្យុងក្រហម បង្ហាញឱកាសរចនាដែលលាក់បាំងសម្រាប់អចលនទ្រព្យរបស់អ្នក។',
      zh: '建筑蓝图与红色罗盘并用，揭示物业布局中的隐藏机遇。',
    ),
  ),
];
