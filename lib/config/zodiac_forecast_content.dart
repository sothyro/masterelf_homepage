/// Localized 2026 zodiac forecast content for EN, KM, and ZH.
/// Predictions and warnings for each animal sign.
class ZodiacForecastContent {
  const ZodiacForecastContent({
    required this.auspiciousPredictions,
    required this.inauspiciousWarnings,
  });

  final String auspiciousPredictions;
  final String inauspiciousWarnings;
}

/// Returns forecast content for the given locale.
/// Supported: en, km, zh.
Map<String, ZodiacForecastContent> getZodiacForecastContent(String locale) {
  switch (locale) {
    case 'zh':
      return _contentZh;
    case 'km':
      return _contentKm;
    default:
      return _contentEn;
  }
}

const Map<String, ZodiacForecastContent> _contentEn = {
  'rat': ZodiacForecastContent(
    auspiciousPredictions:
        'Good time to prepare for a new life and new home.\nBuy a new car, start a new business!\nLet go of old problems.\nCut off toxic relationships.\nTime for recognition.\nSociety will seek you out.\nRise in status, gain power and fame.',
    inauspiciousWarnings:
        'Rats face the year head-on but may feel weary, prone to stress and burnout.\nBe cautious with finances.\nPossible accidents, more illness, and legal matters.',
  ),
  'ox': ZodiacForecastContent(
    auspiciousPredictions:
        'Gain power, rise in rank, honour and fame.\nTimely support from helpful people.\nProsperity, more wealth and enjoyable activities.\nBlessings from past lives will support from above.',
    inauspiciousWarnings:
        'Gossip, reputation damage, possible legal issues, disputes. Learn to control emotions. Sudden loss of possessions, sudden illness. Beware of friends who may betray you!',
  ),
  'tiger': ZodiacForecastContent(
    auspiciousPredictions:
        'Deeper understanding of life and situations; greater recognition.\nLearn new skills and excel in exams this year.\nNew positions, raises or financial gains at work.\nAbundant opportunities if you work hard.',
    inauspiciousWarnings:
        'Gossip, reputation damage, possible legal issues.\nDisputes—learn to control emotions.\nTendency to want solitude, old illness may return.\nTravel cautiously; close friends may betray you.',
  ),
  'rabbit': ZodiacForecastContent(
    auspiciousPredictions:
        'Blessings, peace and heavenly favour.\nBetter health than last year and helpful supporters to open doors.\nProsperity, success and gains from work and business.',
    inauspiciousWarnings:
        'Jealousy, backbiting; legal matters may or may not be resolved.\nBeware of unfaithful partners or outside trouble.\nFamily may have illness; monitor health.\nBe cautious when travelling near and far.',
  ),
  'dragon': ZodiacForecastContent(
    auspiciousPredictions:
        'Solutions will come; special inner strength will grow.\nRaises; people listen to you.\nRise in status; respect from all directions.\nWin cases; career and business goals will be achieved.',
    inauspiciousWarnings:
        'May face accidents and disputes.\nWork and relationship conflicts.\nCool feelings; possessions may slip away—do not be careless.\nHealth issues and accidents.',
  ),
  'snake': ZodiacForecastContent(
    auspiciousPredictions:
        'Recognition, trust from superiors.\nRewards, promotions, prosperity.\nMore wealth, salary increases.\nFriends support and sustain you.',
    inauspiciousWarnings:
        'Many things happening at home; be flexible.\nOld illness may return; possible breakup.\nLoss of property; stay away from negative people.\nBeware of misfortune.',
  ),
  'horse': ZodiacForecastContent(
    auspiciousPredictions:
        'Divine favour; the year ruler loves you.\nSuccessful travel; relocation brings gains.\nNew positions, promotions, new life paths.\nCommand respect; people obey.\nSupport from influential people.\nSavings will grow; investments will flourish.',
    inauspiciousWarnings:
        'The year god rules—tired, high pressure.\nEasily anxious, overthinking, sleepless nights.\nPossible bloodshed; guard your blessings.\nBut the three fortune stars will help ease matters.\nMental health strain from family burdens.\nAvoid self-sabotage.',
  ),
  'goat': ZodiacForecastContent(
    auspiciousPredictions:
        'Brilliant sunshine; blessed support for gains and victories. Solutions for every challenge. Great Qi energy; misfortune turns to gain, gain to abundance. Life rises a level.',
    inauspiciousWarnings:
        'Mind vast as sky but empty; easy to misuse. Unrealistic expectations yield nothing. Obstacles when mind is troubled. Opportunists abound—teach the mind, release emotions. Easy to fall into drink and gambling. Bloodshed if not careful; surgery or fainting.',
  ),
  'monkey': ZodiacForecastContent(
    auspiciousPredictions:
        'Stars show the way; marriage or life partner possible. Intelligence star protects; exams and civil service—success. Contracts less likely to be cheated. Tendency to relocate, change job or emigrate. Much travel.',
    inauspiciousWarnings:
        'Funeral hall; easy loss of family or acquaintances. Grief from unfulfilled relationships. If ill, seek treatment this year. Partner may not understand; desire for solitude. Smile outside, cry inside. Others see your weaknesses—be cautious.',
  ),
  'rooster': ZodiacForecastContent(
    auspiciousPredictions:
        'Recovery from turbulence; glow returns. Will meet a partner. Yin energy strong—beloved by many. Good news, declarations of love, unexpected gifts. If taking a partner this year, it fits! Noble support. If short on money, someone will add.',
    inauspiciousWarnings:
        'Beware of scandal, theft; secrets will leak. Reputation damage. Leaks from close ones and external partners. Gossip brings trouble home. Debt not fully repaid. When one issue arises, do not add more.',
  ),
  'dog': ZodiacForecastContent(
    auspiciousPredictions:
        'Beneficial support; bosses trust you. Win in business. If you want to meet someone, talk to them. Resolve debt, work, legal matters—finish them this year.',
    inauspiciousWarnings:
        'Trivial matters become big; but use it wisely and fortune may explode. Work and business disputes; beware investors. Grief, loss of news, departures. Lost items hard to find. People leave; separation is difficult.',
  ),
  'pig': ZodiacForecastContent(
    auspiciousPredictions:
        'Years of hard work will be recognized. Time to reap gains and achievements. Finances improve this year. Exams passed; stable position. Elders and loved ones will support.',
    inauspiciousWarnings:
        'Loss of possessions and money; cheated. Loss of elderly at home or loved ones. Illness or contagion; hard to treat. Independent types may change jobs; hardship before ease.',
  ),
};

const Map<String, ZodiacForecastContent> _contentKm = {
  'rat': ZodiacForecastContent(
    auspiciousPredictions:
        'វេលាល្អសម្រាប់រៀបចំជិវិតថ្មី លំនៅឋានថ្មី\nទទួលឡានថ្មី បើកមុខរបរថ្មី!\nបោះចោលបញ្ហាចាស់\nចោលទំនាក់ទំនងToxic\nវេលាដល់ពេលគេទទួលស្គាល់\nនឹងមានសង្គមរាប់រក\nឡើងឋានៈ មានអំណាច និងល្បីល្បាញ។',
    inauspiciousWarnings:
        'ឆ្នាំនេះកណ្តុរនៅចំមុខ ថាយស៊ួយ ហត់នឿយបន្តិចហើយ ឆាប់ស្រ្តេស ឆាប់បាក់កំលាំង។\nប្រយ័ត្នប្រយែងលុយកាក់.\nមានគ្រោះថ្នាក់ ឈឺច្រើន និងងាយមានក្តីក្តាំ',
  ),
  'ox': ZodiacForecastContent(
    auspiciousPredictions:
        'មានអំណាច ឡើងបុណ្យស័ក្តិ កិត្តិយស និងល្បីល្បាញ\nមានគេជួយជ្រោមជ្រែងទាន់ពេលវេលាល្អ\nឡើងលាភកើនលុយ និងសម្បូរកម្មវិធីសប្បាយៗ\nបុណ្យពីជាតិមុន នឹងជួយជ្រោមជ្រែងពីលើមេឃ',
    inauspiciousWarnings:
        'គេនិយាយមួលបង្កាច់ បង្ខូចឈ្មោះ អាចមានក្តីក្តាំផ្លូវច្បាប់ មានជំលោះ ត្រូវចេះទប់អារម្មណ៍ បាត់របស់ភ្លាមៗ ឈឺធ្ងន់ភ្លាមៗ ប្រយ័ត្នមិត្តភ័ក្តិឯងបោកប្រាស់!',
  ),
  'tiger': ZodiacForecastContent(
    auspiciousPredictions:
        'យល់ពីជីវិតនិងស្ថានការណ៍ជ្រៅជ្រះ និងគេទទួលស្កាល់ជាងមុន\nឆ្នាំនេះបើរៀនជំនាញថ្មីនឹងបានលាភ បើប្រលងនឹងជាប់\nធ្វើការនឹងបានទទួលដំណែងថ្មី រឺឡើងប្រាក់ខែ រឺលុយកាក់\nលាភច្រើនឆ្នាំនេះ បើឧស្សាហ៍នឹងចាប់បានច្រើន',
    inauspiciousWarnings:
        'គេនិយាយមួលបង្កាច់ បង្ខូចឈ្មោះ អាចមានក្តីក្តាំផ្លូវច្បាប់\nមានជំលោះ ត្រូវចេះទប់អារម្មណ៍\nចេះតែចង់នៅម្នាក់ឯង មានជំងឺសល់ពីឆ្នាំចាស់\nគ្រោះផ្លូវឆ្ងាយ មិត្តជិតស្និតនឹងក្បត់អ្នក ចូរប្រយ័ត្ន',
  ),
  'rabbit': ZodiacForecastContent(
    auspiciousPredictions:
        'សុភមង្គល ស្ងប់សុខ និងទទួលពរជ័យពីឋានសួគ៌\nសុខភាពប្រសើជាឆ្នាំមុន និងមានគេជួយជ្រោមជ្រែងបើកផ្លូវ\nរីកចម្រើន ហេងថ្កុំថ្កើង និងទទួលបានលាភពីរបររកស៊ីការងារ',
    inauspiciousWarnings:
        'គេច្រណែន មួលបង្កាច់ក្រោយខ្នង ក្តីក្តាំអាចនឹងមានរឺមិនទាន់ចប់\nប្រយ័ត្នគូស្នេហ៍មិនស្មោះត្រង់ រឺនាំទុក្ខពីក្រៅមក\nគ្រួសារនឹងមានអ្នកឈឺ មើលមិនទាន់ឈឺធ្ងន់\nនិងប្រយ័ត្នដំណើរជិតឆ្ងាយ',
  ),
  'dragon': ZodiacForecastContent(
    auspiciousPredictions:
        'ដំណោះស្រាយនឹងមាន ឋាមពលពិសេសក្នុងខ្លួននឹងកើនឡើង\nឡើងប្រាក់ខែ និយាយគេស្តាប់\nនឹងឡើងឋានៈ អស្សនៈ៨ទិស នឹងមានគេកោតក្រែង\nក្តីក្តាំឈ្នះគេ រត់ការការងាររកស៊ីនឹងបានសម្រេច',
    inauspiciousWarnings:
        'នឹងជួបគ្រោះថ្នាក់ និងជំលោះ\nជំលោះការងារ និងជំលោះដៃគូរ\nចិត្តត្រជាក់ៗ របស់បានដល់ដៃអាចរបូត កុំប្រហែស\nបញ្ហាសុខភាព និងគ្រោះថ្នាក់',
  ),
  'snake': ZodiacForecastContent(
    auspiciousPredictions:
        'នឹងត្រូវបានគេទទួលស្គាល់ មេកើយទុកចិត្ត\nនឹងផ្តល់រង្វាន់ នឹងបានឡើងឋានៈ ឡើងលាភ\nឡើងលុយ ឡើងប្រាក់ខែ\nមានមិត្តភ័ក្តិជួយទំនុកបម្រុងជ្រោមជ្រែង។',
    inauspiciousWarnings:
        'មានរឿងច្រើនកើតនៅផ្ទះ ត្រូវចេះបត់បែន\nនឹងមានជំងឺចាស់រើវិញ អាចលែងលះគូរស្នេហ៍\nបាត់ទ្រព្យ នៅឲ្យឆ្ងាយពីមនុស្សអវិជ្ជមាន\nនិងគ្រោះខែ',
  ),
  'horse': ZodiacForecastContent(
    auspiciousPredictions:
        'គ្រែស្នែងទេវតា ព្រះរាជាស្រលាញ់ពេញបេះដូង\nនឹងបានធ្វើដំណើរជោគជ័យ ប្តូរកន្លែងក៏បានលាភ\nបានតំណែង ឡើងឋានៈ ផ្លាស់ប្តូខ្សែជីវិតថ្មី\nបញ្ជាគេបាន មានអំណាច គេស្តាប់បង្គាប់\nមានគេហែហមទំនុកបំរុង\nទ្រព្យសន្សំនឹងកើនឡើង បើយកមកវិនិយាគ នឹងហេង មិនខាតបង់',
    inauspiciousWarnings:
        'ទេវតាកាន់ឆ្នាំគ្រងតំណែង ហត់នឿយ សម្ពាធច្រើន\nងាយឆេវឆាវ គិតច្រើនជ្រុល គេងមិនលក់\nអាចនឹងមានឈាមចេញពីខ្លួនច្រើនប្រយ័ត្នអស់បុណ្យ\nតែតារាលាភទាំង៣ នឹងជួយកាត់ឆុងឲ្យ\nលេខខ្មោចគេកប់ចោល\nជំងឺផ្លូវចិត្តធ្ងន់ ព្រោះទូលរែករឿងគ្រួសារតែឯង\nចាក់ច្រវ៉ាក់ចងជើងខ្លួនឯងកន្លែងដដែល',
  ),
  'goat': ZodiacForecastContent(
    auspiciousPredictions:
        'ពន្លឺព្រះអាទិត្យភ្លឺត្រចះត្រចង់ នឹងមានអ្នកមានបុណ្យជួយជ្រោមជ្រែងបានលាភបានជ័យ ដំណោះស្រាយអ្វីក៏មានច្រកចេញ។ ល្អណាស់! សុខដុមរមនាឆ្នាំថ្មី ឋាមពលQiវិជ្ជមានខ្ពស់ណាស់ គ្រោះទៅជាលាភ លាភទៅជាស្តុកស្តម្ភ ជីវិតឡើងមួយថ្នាក់',
    inauspiciousWarnings:
        'ផ្លូវចិត្តធំដូចផ្ទៃមេឃ តែទទេស្អាត ងាយនឹងប្រើចិត្តខុស បំណងដែលហួសព្រំដែន នឹងមិនបានផល ឧបសគ្គនឹងកើតមានពេលចិត្តមិនស្រស់ស្រាយ មនុស្សចាំកេងចំណេញមានច្រើនឆ្នាំនេះ ត្រូវចំណាយពេលបង្រៀនចិត្ត រំសាយអារម្មណ៍ ងាយនឹងយកស្រា យកល្បែងបាំងមុខ នឹងមានឈាមចេញពីខ្លួនបើមិនប្រយ័ត្ន កំរិតវះកាត់ រឺសន្លប់ច្រើនថ្ងៃ',
  ),
  'monkey': ZodiacForecastContent(
    auspiciousPredictions:
        'តារាបង្ហាញផ្លូវ អាចនឹងមានរៀបចំណងអាពាហ៍ពិពាហ៍ រឺចាប់ដៃគូរជីវិត តារាបញ្ញាញាណនៅរក្សា បើប្រលងជានិស្សិតរឺមន្ត្រីរាជការ នឹងបានដុចបំំណង តារានេះងាយឲ្យអ្នកប្រលងជាប់។ ចុះកុងត្រាមិនងាយចាញ់បោកគេ។ មានទំនោនឹងប្តុរកន្លែងការងារ រឺផ្ទះសម្បែក រឺចំណាកស្រុក។ ធ្វើដំណើរច្រើន។',
    inauspiciousWarnings:
        'សាលដំកល់សព ងាយបាត់សមាជិកគ្រួសារ រឺអ្នកធ្លាប់ស្គាល់ កើតទុក្ខក្រៀមក្រំដោយសារដៃគូរមិនបានដូចចិត្ត។ បើឈឺ គឺជំងឺកាច គួរទៅពិនិត្យព្យាបាលក្នុងឆ្នាំនេះ មានគូមិនយល់ចិត្ត ចង់នៅម្នាក់ឯង សើចនៅមុខ យំក្នុងចិត្ត គេឃើញចំនុចខ្សោយ ចូរប្រយ័ត្ន',
  ),
  'rooster': ZodiacForecastContent(
    auspiciousPredictions:
        'សម្រប់ផូរផង់ត្រលប់មកវិញ មានង៉ូវហេង នឹងជួបគូរ ធាតុអ៊ីនខ្លាំងគួជាទីស្រលាញ់របស់មនុស្សទាំងឡាយ មានដំណឹងល្អ គេសារភាពស្រលាញ់ នឹងមានអំណោយដោយមិនដឹងខ្លួន គូរឆ្នាំនេះបើយកគ្នាគឺត្រូវ! មយូរ៉ាជួបនាគ។ មានអ្នកធំជួយជ្រោមជ្រែង ពឹងគេបាន។ លុយមិនគ្រប់ មានគេជួបបន្ថែម។',
    inauspiciousWarnings:
        'ប្រយ័ត្នមានរឿងសាហាយស្មន់ លួចលាក់ គេចមិនផុត នឹងធ្លាយចេញ។ ខូចកិត្តយស។ ធ្លាយពីអ្នកជិតស្និត និងដៃគូរខាងក្រៅ។ គេនិយាយដើម នាំបញ្ហាចូលផ្ទះ បំណុលដោះមិនទាន់អស់ទេ រឿងចូលគ្រប់ច្រក ពេលមានរឿងមួយ គួរណាស់កុំបន្ថែមរឿង',
  ),
  'dog': ZodiacForecastContent(
    auspiciousPredictions:
        'មានមិនល្អជួយជ្រោមជ្រែង ចៅហ្វាយនាយជឿជាក់ រកស៊ីឈ្នះគេ។ បើចង់ជួបជុំជាមួយអ្នកណា និយាយនឹងគេបាន ដំណោះស្រាយបំណុល រឿងការងារ ក្តីក្តាំ ធ្វើឆ្នាំនេះនឹងបានចប់',
    inauspiciousWarnings:
        'មនុស្សល្អិតល្អោចនាំរឿងឥតបានការក្លាយជារឿងធំ តែបើចេះប្រើខ្មោចអោយបាយស៊ី នឹងបានផ្ទុះលាភ ជំលោះកន្លែងការងារ រកស៊ី អ្នកចូលហ៊ុន ប្រយ័ត្ន សោកសៅ បាត់ដំណឹង លាហើយមិនងាកក្រោយ បើបាត់របស់ពិបាករកឃើញ មនុស្សនៅនឹងមុខលាជារៀងរហូត លែងលះពិបាកយកគ្នា។',
  ),
  'pig': ZodiacForecastContent(
    auspiciousPredictions:
        'កិច្ចខំប្រឹងប្រែងជាច្រើនឆ្នាំនឹងបានគេទទួលស្គាល់ ដល់ពេលអោបយកលាភ និងសមិទ្ធិផល។ លុយកាក់នឹងមានបានច្រើនឡើងវិញឆ្នាំនេះ បើប្រលងនឹងជាប់ នឹងបានតាំងស៊ប់ អ្នកធំ អ្នកស្រលាញ់ នឹងជ្រោមជ្រែង',
    inauspiciousWarnings:
        'បាត់របស់លុយកាក់ ចាញ់បោកគេ បាត់មនុស្សចាស់ក្នុងផ្ទះ បាត់សមាជិកដែលធ្លាប់ស្រលាញ់ ជំងឺបៀតបៀនខ្លួន រឺនឹងឆ្លង ពិបាកព្យាបាល អ្នកក្លាហានឯកោ នឹងប្តូរការងារ ពិបាកមុនស្រណុកក្រោយ',
  ),
};

const Map<String, ZodiacForecastContent> _contentZh = {
  'rat': ZodiacForecastContent(
    auspiciousPredictions:
        '適宜籌劃新生活、新居所。\n買新車、開新業！\n拋開舊問題。\n斬斷有毒關係。\n時來運轉獲認可。\n人脈主動上門。\n升職加薪、掌權揚名。',
    inauspiciousWarnings:
        '鼠年當頭，易疲憊、壓力大、易崩潰。\n謹慎理財。\n注意意外、疾病及官司。',
  ),
  'ox': ZodiacForecastContent(
    auspiciousPredictions:
        '得權勢、升官晉爵、名利雙收。\n貴人及時相助。\n財運亨通、喜事連連。\n前世福報護佑。',
    inauspiciousWarnings:
        '口舌是非、名譽受損、易涉官司、爭端。須控制情緒。財物突然遺失、急病。慎防友人背棄！',
  ),
  'tiger': ZodiacForecastContent(
    auspiciousPredictions:
        '對人生與局勢領悟更深；更獲認可。\n今年學新技能、考試順利。\n升職加薪或事業進財。\n勤奮則機會多。',
    inauspiciousWarnings:
        '口舌是非、名譽受損、易涉官司。\n爭端—須控制情緒。\n傾向獨處，舊疾或復發。\n遠行謹慎；密友或背叛。',
  ),
  'rabbit': ZodiacForecastContent(
    auspiciousPredictions:
        '福星高照、平安喜樂、天賜吉祥。\n健康勝去年，貴人開路。\n事業興旺、名利兼收。',
    inauspiciousWarnings:
        '易招嫉妒、背後是非；官司或有或無。\n慎防伴侶不忠或外來麻煩。\n家人或有病痛；留意健康。\n遠近出行皆宜謹慎。',
  ),
  'dragon': ZodiacForecastContent(
    auspiciousPredictions:
        '化解有方；內在力量增長。\n加薪；一言九鼎。\n地位提升；八方敬重。\n官司勝訴；事業達成。',
    inauspiciousWarnings:
        '或遇意外與爭端。\n工作及感情糾紛。\n情意轉淡；財物易失—勿大意。\n注意健康與意外。',
  ),
  'snake': ZodiacForecastContent(
    auspiciousPredictions:
        '得認可，上司器重。\n獲獎、升職、財運佳。\n收入增加、加薪。\n友人扶持。',
    inauspiciousWarnings:
        '家事繁多；須懂得變通。\n舊疾或復發；或有分手。\n失物；遠離負面之人。\n謹防凶煞。',
  ),
  'horse': ZodiacForecastContent(
    auspiciousPredictions:
        '得太歲眷顧；歲君厚愛。\n出行順利；遷徙有得。\n新職、升遷、新人生。\n能發號施令；眾聽從。\n得貴人扶持。\n積蓄增長；投資獲利。',
    inauspiciousWarnings:
        '值太歲—疲憊、壓力大。\n易焦慮、多思、失眠。\n或見血光；須惜福。\n三吉星可化解。\n家事牽動心神。\n勿自縛手腳。',
  ),
  'goat': ZodiacForecastContent(
    auspiciousPredictions:
        '太陽高照；貴人相助得利得勝。凡事有解。運勢佳；凶轉吉、吉轉旺。人生上一台階。',
    inauspiciousWarnings:
        '心大而空；易走偏。奢望難成。心煩時易生障礙。小人多—須修心養性。易沾酒色賭。見血光若不謹慎；手術或暈厥。',
  ),
  'monkey': ZodiacForecastContent(
    auspiciousPredictions:
        '星照前路；可婚嫁或遇伴侶。文昌護持；考試、公職有望。合約不易上當。利遷移、換工或移居。出行多。',
    inauspiciousWarnings:
        '喪門星；易失家人或故人。感情未遂致憂愁。若有病，今年宜就醫。伴侶或不解；傾向獨處。表面笑、心中苦。旁人見弱點—須謹慎。',
  ),
  'rooster': ZodiacForecastContent(
    auspiciousPredictions:
        '動盪後回穩；容光煥發。可遇良緣。陰性強—得人緣。喜訊、表白、意外之財。今年若成婚，正合！得天乙貴人。錢不敷有人補。',
    inauspiciousWarnings:
        '慎防桃色、竊盜；秘密難守。名譽受損。親近之人與外力泄密。是非入宅。債務未清。一事起時勿再添事。',
  ),
  'dog': ZodiacForecastContent(
    auspiciousPredictions:
        '三合貴人；上司信任。事業可勝。欲見何人，直接相談。債務、工作、官司，今年可了結。',
    inauspiciousWarnings:
        '小事化大；善用可轉吉。工作與合夥糾紛；慎防股東。喪事、失聯、離別。失物難尋。人走難留；分離不易。',
  ),
  'pig': ZodiacForecastContent(
    auspiciousPredictions:
        '多年努力終獲認可。收穫時節到。今年財運回升。考試可過；職位穩固。長輩與貴人扶持。',
    inauspiciousWarnings:
        '失物破財；易受騙。家中長輩或親人離世。疾病或傳染；難治。獨立者或換工；先難後易。',
  ),
};
