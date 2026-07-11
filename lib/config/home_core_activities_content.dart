import '../l10n/app_localizations.dart';
import 'field_work_content.dart';

class _HomeActivityCopy {
  const _HomeActivityCopy({required this.title, required this.subtitle});

  final LocalizedCopy title;
  final LocalizedCopy subtitle;
}

/// Homepage-only marketing copy for the core activities carousel.
const Map<String, _HomeActivityCopy> _kHomeCoreActivityCopyOverrides = {
  'feng-shui-site': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Unlock Your Property\'s Hidden Fortune',
      km: 'បើកទ្រព្យដែលលាក់កំបាំងក្នុងអចលនទ្រព្យរបស់អ្នក',
      zh: '解锁物业中潜藏的旺运',
    ),
    subtitle: LocalizedCopy(
      en: 'Compass-guided site visits reveal where wealth and harmony can flow—before you sign, build, or open your doors.',
      km: 'ទស្សនាវាលដឹកនាំដោយខ្យុងបង្ហាញទីកន្លែងទ្រព្យ និងសុខដមអាចហូរចូល—មុនពេលចុះហត្ថលេខា សាងសង់ ឬបើកទ្វារ។',
      zh: '罗盘实地勘察，在您签约、动工或开业前，找出财富与和谐能量应汇聚之处。',
    ),
  ),
  'consultations': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Clarity for Life\'s Biggest Decisions',
      km: 'ភាពច្បាស់សម្រាប់ការសម្រេចចិត្តសំខាន់បំផុត',
      zh: '人生重大抉择的清晰指引',
    ),
    subtitle: LocalizedCopy(
      en: 'BaZi, Qi Men, and I Ching sessions that turn ancient charts into practical steps you can act on today.',
      km: 'វដ្តប៉ាជឺ Qi Men និងអ៊ីជីង ប្តូរក្រាបបុរាណទៅជាជំហានអនុវត្តបានថ្ងៃនេះ។',
      zh: 'BaZi、奇门与易经咨询，将古老命盘化为今日可执行的具体行动。',
    ),
  ),
  'mao-shan-blessing': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Protection You Can Feel at Home',
      km: 'ការការពារដែលអ្នកមានអារម្មណ៍នៅផ្ទះ',
      zh: '居家可感知的护佑之力',
    ),
    subtitle: LocalizedCopy(
      en: 'Authentic Mao Shan rituals that shield your space, settle restless energy, and restore peace where you live.',
      km: 'ពិធីម៉ៅសានពិត ការពារលំហរបស់អ្នក សម្រាកថាមពល និងស្តារសុខដមក្នុងផ្ទះ។',
      zh: '正统茅山仪式，护佑空间、安定气场，让居所重归安宁和谐。',
    ),
  ),
  'date-selection': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Choose the Day Destiny Smiles',
      km: 'ជ្រើសថ្ងៃដែលវាសនាញញឹម',
      zh: '择吉日，让天时助您一臂之力',
    ),
    subtitle: LocalizedCopy(
      en: 'Auspicious timing for openings, contracts, and milestones—so your effort lands on the right day, not just any day.',
      km: 'ពេលវេលាហេងសម្រាប់បើកដំណើរ កិច្ចសន្យា និងព្រឹត្តិការណ៍—ដើម្បីឱ្យការខិតខំរបស់អ្នកទៅដល់ថ្ងៃត្រឹមត្រូវ។',
      zh: '为开业、签约与人生里程碑择取吉时，让努力落在对的日期，而非任意一天。',
    ),
  ),
  'activity-photo-01': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Build on Ground That Works for You',
      km: 'សាងសង់លើដីដែលធ្វើការសម្រាប់អ្នក',
      zh: '在合您地运的地基上建造',
    ),
    subtitle: LocalizedCopy(
      en: 'Active construction sites get real-time compass readings so every wall and doorway supports prosperity—not fights it.',
      km: 'ទីតាំងសាងសង់ទទួលការអានខ្យុងពេលវេលាពិត ដើម្បីឱ្យជញ្ជាំង និងទ្វារគាំទ្រភាពរុងរឿង។',
      zh: '在建工地现场罗盘读数，让每一面墙、每一扇门都助旺运势，而非与之相悖。',
    ),
  ),
  'activity-photo-02': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Graduate With Confidence, Not Guesswork',
      km: 'បញ្ចប់ការសិក្សាដោយមានទំនុកចិត្ត',
      zh: '结业时胸有成竹，而非茫然猜测',
    ),
    subtitle: LocalizedCopy(
      en: 'Seminar graduates leave certified, connected, and ready to apply classical wisdom in their own lives and practice.',
      km: 'អ្នកបញ្ចប់សិក្ខាសាលាចាកចេញជាមួយវិញ្ញាបនបត្រ ទំនាក់ទំនង និងរួររាល់អនុវត្តបញ្ញាបុរាណ។',
      zh: '研讨会学员结业时持证上岗，人脉相连，随时将古典智慧运用于生活与实践。',
    ),
  ),
  'activity-photo-03': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Luxury Living, Aligned to Prosperity',
      km: 'ជីវិតប្រណីត សម្របភាពរុងរឿង',
      zh: '奢华居所，对齐旺运',
    ),
    subtitle: LocalizedCopy(
      en: 'Precision Luopan readings at elite residences channel wealth energy through every gate and driveway.',
      km: 'ការអានលូផានចម្រុះនៅវិឡាប្រណីត បញ្ជូនថាមពលទ្រព្យតាមច្រក និងផ្លូវចូលទាំងអស់។',
      zh: '高端住宅精准罗盘勘测，让财富能量贯通大门与车道。',
    ),
  ),
  'activity-photo-04': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Offices That Earn, Not Just Occupy Space',
      km: 'ការិយាល័យរកប្រាក់ មិនមែនតែកាន់ទីតាំង',
      zh: '真正生财的办公空间',
    ),
    subtitle: LocalizedCopy(
      en: 'Delivered Feng Shui findings strengthen business prosperity from the reception desk to the corner office.',
      km: 'លទ្ធផលហុងស៊ុយពង្រឹងភាពរុងរឿងអាជីវកម្មពីតុទទួលភ្ញៀវដល់បន្ទប់អគ្គនាយក។',
      zh: '风水勘察成果，从接待台到总裁室，全面提升商业旺气。',
    ),
  ),
  'activity-photo-05': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Carry Protection Wherever You Go',
      km: 'យកការការពារទៅគ្រប់ទីកន្លែង',
      zh: '随身护佑，走到哪里',
    ),
    subtitle: LocalizedCopy(
      en: 'Sacred Mao Shan talismans connect discerning clients to ancestral protection drawn in time-honoured ritual ink.',
      km: 'ស្តេចយ័ន្តម៉ៅសានភ្ជាប់អតិថិជនទៅការការពារបុរាណតាមទឹកខ្មែសពិធី។',
      zh: '茅山灵符以传统仪式墨书，为有缘人连接祖先护佑。',
    ),
  ),
  'activity-photo-06': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Your Destiny Map, Explained in Person',
      km: 'ក្រាបវាសនារបស់អ្នក បកស្រាយផ្ទាល់',
      zh: '命盘当面解读，一目了然',
    ),
    subtitle: LocalizedCopy(
      en: 'Walk away with printed BaZi insights beside the master who decoded your Four Pillars—clarity you can revisit anytime.',
      km: 'ទទួលក្រាបប៉ាជឺបោះពុម្ភ ជាមួយមេដែលបកស្រាយសសរបួនជើង—ភាពច្បាស់ដែលអ្នកអាចពិនិត្យមើលឡើងវិញ។',
      zh: '携印制的 BaZi 命盘离开，与解读四柱的大师合影——清晰指引，随时重温。',
    ),
  ),
  'activity-photo-07': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Trust Built Over Life-Changing Sessions',
      km: 'ទំនុកចិត្តកសាងតាមវដ្តផ្លាស់ប្តូរជីវិត',
      zh: '改变人生的咨询，铸就深厚信任',
    ),
    subtitle: LocalizedCopy(
      en: 'Heartfelt gratitude from clients who found direction, relief, and renewed purpose through destiny consultation.',
      km: 'ការដឹងគុណពីអតិថិជនដែលរកឃើញទិសដៅ ការសម្រាក និងគោលបំណងថ្មីតាមពិគ្រោះវាសនា។',
      zh: '客户以感恩之心回馈，在命运咨询中找到方向、释然与崭新的人生目标。',
    ),
  ),
  'activity-photo-08': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Restore Balance When Life Feels Off-Centre',
      km: 'ស្តារតុល្យភាពពេលជីវិតរសើប',
      zh: '人生失衡时，重归平衡',
    ),
    subtitle: LocalizedCopy(
      en: 'Lotus offerings before the Eight Trigrams mark a sacred Mao Shan harmony ritual for spiritual equilibrium.',
      km: 'បូជាផ្កាឈូកមុព្រះបាកួយ សម្គាល់ពិធីម៉ៅសានសម្រាប់តុល្យភាពផ្លូវវិញ្ញាណ។',
      zh: '八卦前莲花供奉，举行茅山和谐祈福，平衡灵性能量。',
    ),
  ),
  'activity-photo-09': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Wisdom Shared Before Hundreds',
      km: 'បញ្ញាចែករំលែកមុព្រះអ្នកស្តាប់រាប់រយ',
      zh: '台前传法，数百人受益',
    ),
    subtitle: LocalizedCopy(
      en: 'Master Elf brings destiny wisdom to the stage—transformative teaching that moves audiences from curiosity to conviction.',
      km: 'Master Elf យកបញ្ញាវាសនាទៅឆាក—ការបង្រៀនផ្លាស់ប្តូរពីការចង់ដឹងទៅជាទំនុកចិត្ត។',
      zh: 'Master Elf 于舞台分享命理智慧——化好奇为信念的变革性讲授。',
    ),
  ),
  'activity-photo-10': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Your Session, Prepared With Purpose',
      km: 'វដ្តរបស់អ្នក រៀបចំដោយបំណង',
      zh: '每一次咨询，皆有备而来',
    ),
    subtitle: LocalizedCopy(
      en: 'Talismans, charts, and Feng Shui documents await beneath the Harmony & Balance banner—ready when you arrive.',
      km: 'ស្តេចយ័ន្ត ក្រាប និងឯកសារហុងស៊ុយរង់ចាំក្រោមបដាសុខដម—រួចរាល់ពេលអ្នកមកដល់។',
      zh: '灵符、命盘与 Feng Shui 文件在和谐平衡横幅下等候——您到，一切就绪。',
    ),
  ),
  'activity-photo-11': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Blessings That Reach Through Touch',
      km: 'ពិធីអរពរដែលប៉ះដល់ចិត្ត',
      zh: '一触即达的祈福护佑',
    ),
    subtitle: LocalizedCopy(
      en: 'Gentle ritual touch over scripture cards activates Mao Shan protection for every seeker who steps forward.',
      km: 'ការប៉ះពិធីទន់ទាបលើកាតគម្ពីរ បើកការការពារម៉ៅសានសម្រាប់អ្នកស្វែងរករាល់រូប។',
      zh: '仪式轻触经卡，为每一位求福者开启茅山护佑。',
    ),
  ),
  'activity-photo-12': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'First Impressions That Draw Prosperity',
      km: 'ចំណាប់ដំបូងទាក់ទងទ្រព្យ',
      zh: '第一印象，招徕旺运',
    ),
    subtitle: LocalizedCopy(
      en: 'Compass-guided storefront audits ensure your entrance welcomes the right energy—and the right customers—before you open.',
      km: 'ការត្រួតពិនិត្យហាងដឹកនាំដោយខ្យុង ធានាច្រកទ្វារទទួលថាមពល និងអតិថិជនត្រឹមត្រូវមុនបើកដំណើរ។',
      zh: '罗盘勘察店面，开业前确保入口迎纳正能与客户。',
    ),
  ),
  'activity-photo-13': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Receive What Was Made for You Alone',
      km: 'ទទួលអ្វីដែលបង្កើតសម្រាប់អ្នកតែមួយ',
      zh: '领取专属于您的灵符',
    ),
    subtitle: LocalizedCopy(
      en: 'Your consecrated Mao Shan scroll is presented before the guardian altar—a formal blessing you carry home.',
      km: 'ក្រដាសម៉ៅសានដែលបានឧទ្ទិសប្រគល់មុព្រះវិញ្ញាណការពារ—ពិធីអរពរដែលអ្នកយកទៅផ្ទះ។',
      zh: '开光茅山灵符于护法神台前正式颁授——护佑随身，带回家中。',
    ),
  ),
  'activity-photo-14': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Spaces That Attract Clients and Calm',
      km: 'លំហទាក់ទងអតិថិជន និងសុខដម',
      zh: '招客又安心的空间能量',
    ),
    subtitle: LocalizedCopy(
      en: 'Festive Feng Shui alignment at beauty clinics elevates salon energy so clients feel welcome—and keep returning.',
      km: 'ការសម្របហុងស៊ុយនៅគ្លីនិកគ្រោះបង្កើនថាមពល ដើម្បីឱ្យអតិថិជនមានអារម្មណ៍ស្វាគមន៍ និងត្រឡប់មកវិញ។',
      zh: '美容诊所喜庆 Feng Shui 布局，提升空间能量，让客户倍感欢迎、愿再光临。',
    ),
  ),
  'activity-photo-15': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Know the Land Before You Invest',
      km: 'ស្គាល់ដីមុនពេលវិនិយោគ',
      zh: '投资前先识地运',
    ),
    subtitle: LocalizedCopy(
      en: 'Luopan readings on raw land reveal the fortune buried in bare earth—intelligence that protects your investment.',
      km: 'ការអានលូផានលើដីទទេបង្ហាញវាសនាក្នុងដី—ព័ត៌មានការពារការវិនិយោគរបស់អ្នក។',
      zh: '空地罗盘读数，揭示裸土中潜藏的地运——护佑您的投资决策。',
    ),
  ),
  'activity-photo-16': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Every Corner Assessed, Nothing Left to Chance',
      km: 'គ្រប់មុំត្រូវបានវាយតម្លៃ',
      zh: '每个角落皆审视，不留侥幸',
    ),
    subtitle: LocalizedCopy(
      en: 'Strategic on-site Feng Shui review of junctions and facades—expert eyes on what maps alone cannot show.',
      km: 'ការពិនិត្យហុងស៊ុយយុទ្ធសាស្ត្រនៅផ្លូវបំបែក និងផ្ទះ—ភ្នែកអ្នកជំនាញលើអ្វីដែលផែនការមិនបង្ហាញ។',
      zh: '路口与立面战略风水审视——专家眼力，补平面图之不足。',
    ),
  ),
  'activity-photo-17': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Learn What the Compass Reveals',
      km: 'រៀនអ្វីដែលខ្យុងបង្ហាញ',
      zh: '读懂罗盘所揭示的天机',
    ),
    subtitle: LocalizedCopy(
      en: 'Clients discover land-orientation secrets as the master reads compass rings aloud—knowledge that empowers your decisions.',
      km: 'អតិថិជនរកឃើញអំណោយផលទិសដី ខណៈមេអានខ្យុង—ចំណេះដឹងដែលជួយការសម្រេចចិត្តរបស់អ្នក។',
      zh: '大师现场朗读罗盘圈层，传授地块朝向要诀——助您决策更有底气。',
    ),
  ),
  'activity-photo-18': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Ancient Tools, Modern Precision',
      km: 'ឧបករណ៍បុរាណ ភាពត្រឹមត្រូវទំនើប',
      zh: '古法罗盘，现代精准',
    ),
    subtitle: LocalizedCopy(
      en: 'Traditional Luopan meets digital mapping on sunlit plots—laying the Feng Shui foundation for prosperous development.',
      km: 'លូផានបុរាណ និងផែនទីឌីជីថលលើដីពន្លឺថ្ងៃ—ដាក់មូលដ្ឋានហុងស៊ុយសម្រាប់អភិវឌ្ឍន៍ហេង។',
      zh: '传统罗盘与数字地图并用，于阳光地块奠定兴旺开发的 Feng Shui 基础。',
    ),
  ),
  'activity-photo-19': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Honour the Forces That Guard Your Path',
      km: 'គោរពកម្លាំងដែលការពារផ្លូវអ្នក',
      zh: '礼敬护佑您前路的神明',
    ),
    subtitle: LocalizedCopy(
      en: 'Solemn altar offerings invoke divine favour in Mao Shan blessing rites—protection rooted in reverence, not superstition.',
      km: 'បូជាព្រះវិញ្ញាណអញ្ជើញព្រះគុណក្នុងពិធីម៉ៅសាន—ការការពារមានមូលដ្ឋានគោរព។',
      zh: '庄严祭坛供品，于茅山祈福礼敬神明——护佑源于敬畏，而非迷信。',
    ),
  ),
  'activity-photo-20': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Awaken the Spirit Within the Sacred Image',
      km: 'បើកវិញ្ញាណក្នុងរូបពិរិទ្ធ',
      zh: '唤醒神像内的神圣灵性',
    ),
    subtitle: LocalizedCopy(
      en: 'Ceremonial light consecrates golden figurines—bringing divine presence into the spaces you honour most.',
      km: 'ពន្លឺពិធីឧទ្ទិសរូបមាស—បញ្ចូលវត្តទេវតាទៅក្នុងលំហដែលអ្នកគោរពបំផុត។',
      zh: '仪式开光引灵于金身神像——让护佑入驻您最敬重的空间。',
    ),
  ),
  'activity-photo-21': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Devotion That Goes Deeper Than Words',
      km: 'ការបរិវត្តជ្រៅជាងពាក្យ',
      zh: '虔诚修持，超越言语',
    ),
    subtitle: LocalizedCopy(
      en: 'Floor-level Mao Shan devotion with calligraphy fans and offerings—ritual focus that channels real spiritual power.',
      km: 'ពិធីម៉ៅសានកម្រិតជាន់ផ្ទ៉ាជាមួយអចុយអធិដ្ឋាន—ការផ្តោតពិធីដែលបញ្ជូនថាមពលពិត។',
      zh: '地面茅山修持，符扇供品相伴——专注仪式，引通真实灵力。',
    ),
  ),
  'activity-photo-22': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Open the Eyes, Invite the Blessing',
      km: 'បើកភ្នែក អញ្ជើញពិធីអរពរ',
      zh: '点睛开光，迎请护佑',
    ),
    subtitle: LocalizedCopy(
      en: 'The sacred eye-opening rite awakens every deity figurine—so protection is active, not merely decorative.',
      km: 'ពិធីបើកភ្នែកភ្ញាញ់បើករូបទេវតា—ដើម្បីឱ្យការការពារសកម្ម មិនមែនតែរចនា។',
      zh: '神圣开眼礼唤醒每一尊神像——护佑生效，而非仅供摆设。',
    ),
  ),
  'activity-photo-23': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Your Chart, Decoded Line by Line',
      km: 'ក្រាបរបស់អ្នក បកស្រាយជួរតួ',
      zh: '命盘逐行解读，无一遗漏',
    ),
    subtitle: LocalizedCopy(
      en: 'Four Pillars destiny maps explained in depth at the consultation desk—insights you understand, remember, and use.',
      km: 'ក្រាបសសរបួនជើងបកស្រាយជ្រៅនៅតុពិគ្រោះ—ចំណេះដឹងដែលអ្នកយល់ ចងចាំ និងប្រើប្រាស់។',
      zh: '咨询桌前深度解读四柱命盘——清晰易懂、铭记于心、随时运用。',
    ),
  ),
  'activity-photo-24': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Grand Entrances That Command Good Fortune',
      km: 'ច្រកដ៏អស្ចារ្យ ទាក់ទងវាសនាល្អ',
      zh: '气派大门，纳福迎运',
    ),
    subtitle: LocalizedCopy(
      en: 'Expert energy assessment of neoclassical estates and driveways—before you build, know the gate welcomes prosperity.',
      km: 'ការវាយតម្លៃថាមពលវិឡាបុរាណ និងផ្លូវចូល—មុនសាងសង់ ដឹងថាច្រកទទួលភាពរុងរឿង។',
      zh: '新古典庄园与车道专业能量评估——动工前确知大门迎纳旺运。',
    ),
  ),
  'activity-photo-25': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Align Your Futures as a Couple',
      km: 'សម្របអនាគតរបស់អ្នកជាគូ',
      zh: '夫妻同心，规划未来',
    ),
    subtitle: LocalizedCopy(
      en: 'Face-to-face BaZi guidance helps partners harmonise life plans—with clarity that strengthens the bond you share.',
      km: 'ការណែនាំប៉ាជឺផ្ទាល់ជួយគូសម្របផែនការជីវិត—ភាពច្បាស់ដែលពង្រឹងទំនាក់ទំនង។',
      zh: '面对面 BaZi 指导，助伴侣协调人生规划——清晰指引，巩固彼此情谊。',
    ),
  ),
  'activity-photo-26': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Personal Counsel Across the Consultation Desk',
      km: 'ការណែនាំផ្ទាល់ខ្លួនតាមតុពិគ្រោះ',
      zh: '咨询桌前，一对一专属指导',
    ),
    subtitle: LocalizedCopy(
      en: 'Couples receive tailored metaphysical counsel surrounded by ritual documents—answers shaped to your unique situation.',
      km: 'គូស្នេហ៍ទទួលការណែនាំផ្ទាល់ខ្លួនក្បែរឯកសារពិធី ជាមួយចម្លើយសមស្របដំណើរការពិសេសរបស់អ្នក។',
      zh: '夫妻于法事文件环绕的咨询桌前，获得量身定制的玄学指导——因您的情况而异。',
    ),
  ),
  'activity-photo-27': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Investment-Grade Feng Shui Strategy',
      km: 'យុទ្ធសាស្ត្រហុងស៊ុយកម្រិតវិនិយោគ',
      zh: '投资级 Feng Shui 战略',
    ),
    subtitle: LocalizedCopy(
      en: 'Multi-storey plans and Period charts merge on screen—consultation built for developers who cannot afford to guess.',
      km: 'ផែនការពហុជាន់ និងក្រាហ្វយុគរួមលើអេក្រង់—ពិគ្រោះសម្រាប់អ្នកអភិវឌ្ឍដែលមិនអាចទាប់ទាយ។',
      zh: '多层平面图与运期图表同屏呈现——为不容失误的开发商量身咨询。',
    ),
  ),
  'activity-photo-28': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'A Reading That Changes How You See Tomorrow',
      km: 'ការអានផ្លាស់ប្តូររបៀបអ្នកមើលថ្ងៃស្អែក',
      zh: '一次解读，改变您看明天的方式',
    ),
    subtitle: LocalizedCopy(
      en: 'Young couples leave with clarity and confidence after a transformative destiny session—with scrolls that mark the moment.',
      km: 'គូវ័យក្មេងចាកចេញជាមួយភាពច្បាស់ និងទំនុកចិត្តបន្ទាប់ពីវដ្តវាសនា—ជាមួយក្រដាសដែលសម្គាល់ពេលនោះ។',
      zh: '年轻伴侣经历变革性命运解读后，带着清晰与信心离开——黄卷见证此刻。',
    ),
  ),
  'activity-photo-29': _HomeActivityCopy(
    title: LocalizedCopy(
      en: 'Blueprints Meet the Compass',
      km: 'ប្លង់ជួបលូផាន',
      zh: '蓝图与罗盘，双剑合璧',
    ),
    subtitle: LocalizedCopy(
      en: 'Architectural plans and Luopan analysis together reveal hidden layout opportunities—advantage before a single brick is laid.',
      km: 'ផែនការស្ថាបត្យ និងវិភាគលូផានបង្ហាញឱកាសរចនាដែលលាក់—អត្ថប្រយោជន៍មុនដាក់ឥដ្ឋដំបូង។',
      zh: '建筑蓝图与罗盘分析并用，揭示布局中的隐藏机遇——动土前占得先机。',
    ),
  ),
};

/// Homepage carousel pillars with marketing copy (field-work page unchanged).
List<FieldWorkShowcasePillar> buildHomeCoreActivities(
  AppLocalizations l10n,
  String languageCode,
) {
  return buildFieldWorkCoreActivities(l10n, languageCode).map((pillar) {
    final override = _kHomeCoreActivityCopyOverrides[pillar.id];
    if (override == null) return pillar;
    return FieldWorkShowcasePillar(
      id: pillar.id,
      coverImage: pillar.coverImage,
      realm: pillar.realm,
      title: override.title.forLocale(languageCode),
      subtitle: override.subtitle.forLocale(languageCode),
      linkPath: pillar.linkPath,
      icon: pillar.icon,
      accentColor: pillar.accentColor,
      titleCopy: override.title,
      subtitleCopy: override.subtitle,
    );
  }).toList();
}

