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
      en: 'Build on Auspicious Ground',
      km: 'សាងសង់លើដីហេង',
      zh: '在吉地之上建造',
    ),
    subtitle: const LocalizedCopy(
      en: 'Luopan readings on active sites align facing, landform, and Period 9 before walls go up.',
      km: 'ការអានលូផាននៅទីតាំងសាងសង់ សម្របទិស រូបរាងដី និងយុគទី ៩ មុនពេលដាក់ជញ្ជាំង។',
      zh: '在建工地罗盘勘测，动工前对齐朝向、地貌与九运布局。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-02',
    photoNum: 2,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Classical Training, Lasting Practice',
      km: 'បណ្តុះបណ្តល់បុរាណ អនុវត្តយូរអង្វែង',
      zh: '正统传承，学以致用',
    ),
    subtitle: const LocalizedCopy(
      en: 'Graduates leave certified to read BaZi charts and guide others with classical discipline.',
      km: 'អ្នកបញ្ចប់ទទួលវិញ្ញាបនបត្រ អាចអានក្រាបប៉ាជឺ និងណែនាំអ្នកដទៃតាមបច្ចេកទ្វារបុរាណ។',
      zh: '学员结业持证，能以正统八字学问解读命盘、指导他人。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-03',
    photoNum: 3,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Estate Qi, Mapped Precisely',
      km: 'ថាមពលវិឡា វាស់ចម្រុះ',
      zh: '精测宅运，布局有据',
    ),
    subtitle: const LocalizedCopy(
      en: 'Luopan surveying reveals where wealth qi enters—so gates and layouts invite prosperity.',
      km: 'ការស្ទង់លូផានបង្ហាញទីថាមពលទ្រព្យចូល—ដើម្បីឱ្យច្រក និងរចនាអញ្ជើញភាពរុងរឿង។',
      zh: '罗盘精测揭示财富气场入口，让大门与布局纳旺招财。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-04',
    photoNum: 4,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Offices Built to Prosper',
      km: 'ការិយាល័យសាងសម្រាប់រុងរឿង',
      zh: '旺气办公，生财有局',
    ),
    subtitle: const LocalizedCopy(
      en: 'Feng Shui findings turn landform and Flying Stars into layout changes that strengthen business momentum.',
      km: 'លទ្ធផលហុងស៊ុយប្តូររូបរាងដី និងផ្កាយហោទៅជាការកែរចនាដែលពង្រឹងចលនាអាជីវកម្ម។',
      zh: '风水勘察将地貌与飞星化为布局调整，助旺商业运势。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-05',
    photoNum: 5,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Carry Ancestral Protection',
      km: 'យកការពារបុរាណទៅជាមួយ',
      zh: '随身护佑，灵符傍身',
    ),
    subtitle: const LocalizedCopy(
      en: 'Consecrated Mao Shan talismans channel protective qi beyond the walls of any single space.',
      km: 'ស្តេចយ័ន្តម៉ៅសានដែលបានឧទ្ទិស បញ្ជូនថាមពលការពារហួសពីជញ្ជាំងនៃលំហមួយ។',
      zh: '开光茅山灵符引通护佑之气，随身而行，不限于一室之内。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-06',
    photoNum: 6,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Your Four Pillars, Made Clear',
      km: 'សសរបួនជើង ច្បាស់លាស់',
      zh: '四柱命盘，一目了然',
    ),
    subtitle: const LocalizedCopy(
      en: 'Printed BaZi charts and a direct reading turn birth data into timing and practical next steps.',
      km: 'ក្រាបប៉ាជឺបោះពុម្ភ និងការអានផ្ទាល់ ប្តូរទិន្នន័យកំណើតទៅជាពេលវេលា និងជំហានបន្ទាប់ជាក់ស្តែង។',
      zh: '印制八字命盘与当面解读，将生辰化为运程与可行下一步。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-07',
    photoNum: 7,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Clarity Clients Return For',
      km: 'ភាពច្បាស់ដែលអតិថិជនត្រឡប់មក',
      zh: '解疑有方，客户回头',
    ),
    subtitle: const LocalizedCopy(
      en: 'When BaZi resolves real confusion, clients return because the chart earned their trust.',
      km: 'ពេលប៉ាជឺដោះស្រាយការភ្លាវ់ពិត អតិថិជនត្រឡប់មកពីទំនុកចិត្តក្រាបបានបង្កើត។',
      zh: '八字厘清真困惑，客户因命盘可信而再次登门。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-08',
    photoNum: 8,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Restore Spiritual Balance',
      km: 'ស្តារតុល្យភាពផ្លូវវិញ្ញាណ',
      zh: '调和气场，重归平衡',
    ),
    subtitle: const LocalizedCopy(
      en: 'Mao Shan harmony rites with the Bagua settle restless qi and restore equilibrium.',
      km: 'ពិធីសុខដមម៉ៅសានជាមួយបាកួយ សម្រាកថាមពលរញរី និងស្តារតុល្យភាព។',
      zh: '茅山合和仪式借八卦之力，安定躁动气场，恢复平衡。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-09',
    photoNum: 9,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Destiny Wisdom, Taught Live',
      km: 'បញ្ញាវាសនា បង្រៀនផ្ទាល់',
      zh: '命理真传，现场讲授',
    ),
    subtitle: const LocalizedCopy(
      en: 'Master Elf teaches BaZi and classical metaphysics—turning curiosity into usable skill.',
      km: 'Master Elf បង្រៀនប៉ាជឺ និងរូបវិទ្យាចិនបុរាណ—ប្តូរការចង់ដឹងទៅជាជំនាញប្រើបាន។',
      zh: 'Master Elf 讲授八字与古典玄学，化好奇为可用之学。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-10',
    photoNum: 10,
    realm: FieldWorkRealm.office,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Prepared Before You Arrive',
      km: 'រៀបចំរួចមុនពេលអ្នកមក',
      zh: '有备而来，开门见山',
    ),
    subtitle: const LocalizedCopy(
      en: 'Charts, talismans, and Feng Shui notes ready—so your session starts with insight, not small talk.',
      km: 'ក្រាប ស្តេចយ័ន្ត និងកំណត់ត្រាហុងស៊ុយរួចរាល់—វដ្តចាប់ផ្តើមដោយចំណេះដឹង មិនមែនរករឿង។',
      zh: '命盘、灵符与风水笔记备妥，咨询开门见山，直入要点。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-11',
    photoNum: 11,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Ritual Protection, Activated',
      km: 'បើកការពារពិធី',
      zh: '仪式护佑，即刻生效',
    ),
    subtitle: const LocalizedCopy(
      en: 'Mao Shan scripture blessings consecrate each seeker—formal rites that bind intent to lasting cover.',
      km: 'ពិធីអរពរគម្ពីរម៉ៅសាន ឧទ្ទិសអ្នកស្វែងរករាល់រូប—ពិធីផ្គត់ផ្គង់បំណងទៅការពារយូរអង្វែង។',
      zh: '茅山经咒祈福为每位求福者开光，仪轨庄严，护佑随身。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-12',
    photoNum: 12,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Open on Welcoming Qi',
      km: 'បើកដំណើរលើថាមពលអញ្ជើញ',
      zh: '开门纳气，迎客生财',
    ),
    subtitle: const LocalizedCopy(
      en: 'Compass-led storefront audits check entrance qi before launch—favouring foot traffic and revenue.',
      km: 'ការត្រួតពិនិត្យហាងដឹកនាំដោយខ្យុង ពិនិត្យថាមពលច្រកមុនបើកដំណើរ—អំណោយផលដល់អតិថិជន និងចំណូល។',
      zh: '罗盘勘察店面入口气场，开业前迎纳旺气，利客流与营收。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-13',
    photoNum: 13,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Receive Your Blessed Talisman',
      km: 'ទទួលស្តេចយ័ន្តដែលបានឧទ្ទិស',
      zh: '恭领灵符，护佑随身',
    ),
    subtitle: const LocalizedCopy(
      en: 'A formal Mao Shan presentation rite consecrates your scroll—protection you take home and keep.',
      km: 'ពិធីប្រគល់ម៉ៅសានផ្លូវការ ឧទ្ទិសក្រដាសរបស់អ្នក—ការពារដែលយកទៅផ្ទះរក្សាទុក។',
      zh: '茅山颁符仪轨庄严开光，灵符护佑，可携归家中供奉。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-14',
    photoNum: 14,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Service Spaces That Attract',
      km: 'លំហសេវាកម្មដែលទាក់ទងអតិថិជន',
      zh: '旺场布局，客来不断',
    ),
    subtitle: const LocalizedCopy(
      en: 'Feng Shui alignment for clinics and salons lifts reception qi so clients feel at ease and return.',
      km: 'ការសម្របហុងស៊ុយសម្រាប់គ្លីនិក និងសាឡុង លើកថាមពលទទួល ដើម្បីឱ្យអតិថិជនមានអារម្មណ៍សុខ និងត្រឡប់មកវិញ។',
      zh: '诊所与沙龙风水布局，提升迎宾气场，令客户安心愿再光临。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-15',
    photoNum: 15,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Know the Land Before You Buy',
      km: 'ស្គាល់ដីមុនពេលទិញ',
      zh: '买地先看地运',
    ),
    subtitle: const LocalizedCopy(
      en: 'Luopan readings on undeveloped plots expose buried land qi—protecting land and investment decisions.',
      km: 'ការអានលូផានលើដីទទេ បង្ហាញថាមពលដីលាក់កំបាំង—ការពារការសម្រេចចិត្តទិញដី និងវិនិយោគ។',
      zh: '空地罗盘勘测，揭示潜藏地运，护佑购地与投资决策。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-16',
    photoNum: 16,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Every Angle, Strategically Read',
      km: 'គ្រប់មុំ អានយុទ្ធសាស្ត្រ',
      zh: '四方审局，无一遗漏',
    ),
    subtitle: const LocalizedCopy(
      en: 'On-site Feng Shui review of junctions and facades catches what plans miss—eyes on qi, not just paper.',
      km: 'ការពិនិត្យហុងស៊ុយនៅផ្លូវបំបែក និងផ្ទះ ចាប់អ្វីដែលផែនការមិនបង្ហាញ—មើលថាមពល មិនមែនតែក្រដាស។',
      zh: '现场审视路口与立面风水，补平面图之不足，眼见气场。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-17',
    photoNum: 17,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Orientation Secrets, Revealed',
      km: 'បើកអំណោយផលទិសដី',
      zh: '朝向要诀，现场点破',
    ),
    subtitle: const LocalizedCopy(
      en: 'The master reads Luopan rings on site so you understand facing and landform before committing.',
      km: 'មេអានខ្យុងលូផាននៅទីតាំង ដើម្បីឱ្យអ្នកយល់ទិស និងរូបរាងដីមុនពេលសម្រេចចិត្ត។',
      zh: '大师现场解读罗盘圈层，让您在决策前明了朝向与地貌。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-18',
    photoNum: 18,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Ancient Compass, Modern Development',
      km: 'លូផានបុរាណ អភិវឌ្ឍន៍ទំនើប',
      zh: '古法罗盘，现代开发',
    ),
    subtitle: const LocalizedCopy(
      en: 'Traditional Luopan and digital mapping together lay the Feng Shui foundation for new development.',
      km: 'លូផានបុរាណ និងផែនទីឌីជីថល ដាក់មូលដ្ឋានហុងស៊ុយសម្រាប់គម្រោងអភិវឌ្ឍន៍ថ្មី។',
      zh: '传统罗盘与数字地图并用，为新项目奠定风水基础。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-19',
    photoNum: 19,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Invoke Divine Favour',
      km: 'អញ្ជើញព្រះគុណ',
      zh: '礼敬神明，祈求护佑',
    ),
    subtitle: const LocalizedCopy(
      en: 'Solemn Mao Shan altar rites honour the forces that guard your path—rooted in reverence and correct form.',
      km: 'ពិធីម៉ៅសាននៅព្រះវិញ្ញាណ គោរពកម្លាំងដែលការពារផ្លូវអ្នក—មានមូលដ្ឋានគោរព និងទម្រង់ត្រឹមត្រូវ។',
      zh: '茅山祭坛仪轨礼敬护佑之神，源于敬畏与正统法式。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-20',
    photoNum: 20,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Awaken the Sacred Image',
      km: 'បើកវិញ្ញាណរូបពិរិទ្ធ',
      zh: '神像开光，灵性入驻',
    ),
    subtitle: const LocalizedCopy(
      en: 'Kaiguang consecration invites divine presence into honoured figurines—protection that is active, not decorative.',
      km: 'ពិធីឧទ្ទិសបើកកន្ត្រាក់ អញ្ជើញវត្តទេវតាចូលរូបដែលគោរព—ការពារសកម្ម មិនមែនតែរចនា។',
      zh: '开光引灵入驻神像，护佑生效，而非仅供摆设。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-21',
    photoNum: 21,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Devotion That Channels Power',
      km: 'បរិវត្តដែលបញ្ជូនថាមពល',
      zh: '虔诚修持，引通灵力',
    ),
    subtitle: const LocalizedCopy(
      en: 'Focused Mao Shan rites concentrate intent and spiritual force—classical form with practitioner discipline.',
      km: 'ពិធីម៉ៅសានផ្តោតបំណង និងថាមពលផ្លូវវិញ្ញាណ—ទម្រង់បុរាណជាមួយវិន័យអ្នកប្រតិបត្តិ។',
      zh: '专注茅山仪轨凝聚心念与灵力，法式正统，修持严谨。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-22',
    photoNum: 22,
    realm: FieldWorkRealm.ritual,
    serviceId: 'maosan',
    title: const LocalizedCopy(
      en: 'Open the Eyes, Invite Blessing',
      km: 'បើកភ្នែក អញ្ជើញពិធីអរពរ',
      zh: '点睛开光，迎请护佑',
    ),
    subtitle: const LocalizedCopy(
      en: 'The sacred eye-opening rite awakens each deity image—so guardians in your space actually stand watch.',
      km: 'ពិធីបើកភ្នែកភ្ញាញ់ បើករូបទេវតារាល់អង្គ—ដើម្បីឱ្យអ្នកការពារក្នុងលំហរបស់អ្នកពិតប្រាកដចាំរក្សា។',
      zh: '神圣开眼礼唤醒每尊神像，护佑神明真正镇守一方。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-23',
    photoNum: 23,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Your Chart, Line by Line',
      km: 'ក្រាបរបស់អ្នក បន្តិចម្តង',
      zh: '命盘逐行，无一遗漏',
    ),
    subtitle: const LocalizedCopy(
      en: 'Four Pillars mapped and explained—BaZi insights you understand, remember, and act on after you leave.',
      km: 'សសរបួនជើងគូរ និងបកស្រាយ—ចំណេះដឹងប៉ាជឺដែលអ្នកយល់ ចងចាំ និងអនុវត្តបន្ទាប់ពីចាកចេញ។',
      zh: '四柱命盘逐项解读，离席后仍能领会、铭记并践行。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-24',
    photoNum: 24,
    realm: FieldWorkRealm.site,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Grand Entrances That Command Fortune',
      km: 'ច្រកដ៏អស្ចារ្យ ទាក់ទងវាសនា',
      zh: '气派大门，纳福迎运',
    ),
    subtitle: const LocalizedCopy(
      en: 'Gate and driveway qi assessed on luxury estates before construction—know the entrance welcomes prosperity.',
      km: 'វាយតម្លៃថាមពលច្រក និងផ្លូវចូលនៅវិឡាប្រណីតមុនសាងសង់—ដឹងថាច្រកទទួលភាពរុងរឿង។',
      zh: '豪宅动工前评估大门与车道气场，确知入口纳旺招财。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-25',
    photoNum: 25,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Align Your Path as a Couple',
      km: 'សម្របផ្លូវជាគូ',
      zh: '夫妻同心，规划未来',
    ),
    subtitle: const LocalizedCopy(
      en: 'Joint BaZi readings reveal compatibility, timing, and shared direction—clarity, not guesswork.',
      km: 'ការអានប៉ាជឺរួមបង្ហាញភាពឆបគ្នា ពេលវេលា និងទិសដៅរួម—ភាពច្បាស់ មិនមែនទាប់ទាយ។',
      zh: '合盘解读契合度、时机与共同方向，清晰有据，而非猜测。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-26',
    photoNum: 26,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Counsel Shaped to Your Bond',
      km: 'ការណែនាំសមស្របទំនាក់ទំនង',
      zh: '因缘施策，量身定制',
    ),
    subtitle: const LocalizedCopy(
      en: 'Partners receive tailored BaZi guidance built around their charts and the decisions they face together.',
      km: 'គូស្នេហ៍ទទួលការណែនាំប៉ាជឺផ្ទាល់ខ្លួន តាមក្រាប និងការសម្រេចចិត្តរួមរបស់ពួកគេ។',
      zh: '伴侣获量身八字指导，依双方命盘与共同面临的抉择而定。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-27',
    photoNum: 27,
    realm: FieldWorkRealm.office,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Investment-Grade Feng Shui',
      km: 'ហុងស៊ុយកម្រិតវិនិយោគ',
      zh: '投资级风水战略',
    ),
    subtitle: const LocalizedCopy(
      en: 'Period charts and multi-storey plans reviewed together—for developers who cannot afford to guess layout qi.',
      km: 'ក្រាហ្វយុគ និងផែនការពហុជាន់ពិនិត្យរួម—សម្រាប់អ្នកអភិវឌ្ឍដែលមិនអាចទាប់ទាយថាមពលរចនា។',
      zh: '运期图表与多层平面图同审，为不容失误的开发商把关布局气场。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-28',
    photoNum: 28,
    realm: FieldWorkRealm.office,
    serviceId: 'bazi',
    title: const LocalizedCopy(
      en: 'Commit With Clear Timing',
      km: 'សម្រេចចិត្តដោយមានពេលវេលាច្បាស់',
      zh: '大事有期，心中有数',
    ),
    subtitle: const LocalizedCopy(
      en: 'A shared BaZi reading shows compatibility and auspicious windows—so major steps are chosen with confidence.',
      km: 'ការអានប៉ាជឺរួមបង្ហាញភាពឆបគ្នា និងពេលវេលាហេង—ដើម្បីឱ្យជំហានសំខាន់ត្រូវបានជ្រើសដោយមានទំនុកចិត្ត។',
      zh: '合盘揭示契合与吉时窗口，人生大事择而有据，胸有成竹。',
    ),
  ),
  FieldWorkPhotoCard(
    id: 'activity-photo-29',
    photoNum: 29,
    realm: FieldWorkRealm.office,
    serviceId: 'fengshui',
    title: const LocalizedCopy(
      en: 'Blueprints Meet the Compass',
      km: 'ប្លង់ជួបលូផាន',
      zh: '蓝图配罗盘，先机在握',
    ),
    subtitle: const LocalizedCopy(
      en: 'Architectural plans crossed with Luopan analysis reveal layout opportunities before the first brick is laid.',
      km: 'ផែនការស្ថាបត្យរួមវិភាគលូផាន បង្ហាញឱកាសរចនាមុនដាក់ឥដ្ឋដំបូង។',
      zh: '建筑蓝图与罗盘分析并用，动土前揭示布局先机。',
    ),
  ),
];
