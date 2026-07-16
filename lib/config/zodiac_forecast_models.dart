/// Zodiac forecast models and static star data for the Free 12 Animal Forecast dialog.
library;

import '../l10n/app_localizations.dart';

class ZodiacForecast {
  const ZodiacForecast({
    required this.id,
    required this.englishName,
    required this.chineseName,

    this.auspiciousStars,
    this.auspiciousPredictions,
    this.inauspiciousStars,
    this.inauspiciousWarnings,
  });

  final String id;
  final String englishName;
  final String chineseName;

  final List<StarInfo>? auspiciousStars;
  final String? auspiciousPredictions;
  final List<StarInfo>? inauspiciousStars;
  final String? inauspiciousWarnings;
}

class StarInfo {
  const StarInfo({
    required this.khmerName,
    required this.chineseName,
    required this.englishTranslation,
  });

  final String khmerName;
  final String chineseName;
  final String englishTranslation;
}

const List<ZodiacForecast> zodiacForecasts = [
  ZodiacForecast(
    id: 'rat',
    englishName: 'Rat',
    chineseName: '鼠',
    auspiciousStars: [
      StarInfo(khmerName: 'យូកុង', chineseName: '月空', englishTranslation: 'Clear Moon'),
      StarInfo(khmerName: 'ធានជូ', chineseName: '天厨', englishTranslation: 'Heavenly Kitchen'),
      StarInfo(khmerName: 'ថាងហ្វូ', chineseName: '唐符', englishTranslation: 'Imperial Note'),
    ],
    auspiciousPredictions:
        'វេលាល្អសម្រាប់រៀបចំជិវិតថ្មី លំនៅឋានថ្មី\nទទួលឡានថ្មី បើកមុខរបរថ្មី!\nបោះចោលបញ្ហាចាស់\nចោលទំនាក់ទំនងអាប់អួរ\nវេលាដល់ពេលគេទទួលស្គាល់\nនឹងមានសង្គមរាប់រក\nឡើងឋានៈ មានអំណាច និងល្បីល្បាញ។',
    inauspiciousStars: [
      StarInfo(khmerName: 'ស៊ុយ ប៉', chineseName: '歲破', englishTranslation: 'Year Breaker'),
      StarInfo(khmerName: 'តាហាវ', chineseName: '大耗', englishTranslation: 'Major Waste'),
      StarInfo(khmerName: 'ធានគូ', chineseName: '天哭', englishTranslation: 'Heavenly Tears'),
      StarInfo(khmerName: 'ហ្សៃ ចា', chineseName: '災殺', englishTranslation: 'Accident'),
    ],
    inauspiciousWarnings:
        'ឆ្នាំនេះកណ្តុរនៅចំមុខ ថាយស៊ួយ ហត់នឿយបន្តិចហើយ ឆាប់ស្រ្តេស ឆាប់បាក់កំលាំង។\nប្រយ័ត្នប្រយែងលុយកាក់.\nមានគ្រោះថ្នាក់ ឈឺច្រើន និងងាយមានក្តីក្តាំ',
  ),
  ZodiacForecast(
    id: 'ox',
    englishName: 'Ox',
    chineseName: '牛',
    auspiciousStars: [
      StarInfo(khmerName: 'លុង ដេ', chineseName: '龍德', englishTranslation: 'Dragon Virtue'),
      StarInfo(khmerName: 'ជឺ វ៉ី', chineseName: '紫微', englishTranslation: 'Purple Star'),
      StarInfo(khmerName: 'ក្វូ យិង', chineseName: '國印', englishTranslation: 'Imperial Seal'),
    ],
    auspiciousPredictions:
        'មានអំណាច ឡើងបុណ្យស័ក្តិ កិត្តិយស និងល្បីល្បាញ\nមានគេជួយជ្រោមជ្រែងទាន់ពេលវេលាល្អ\nឡើងលាភកើនលុយ និងសម្បូរកម្មវិធីសប្បាយៗ\nបុណ្យពីជាតិមុន នឹងជួយជ្រោមជ្រែងពីលើមេឃ',
    inauspiciousStars: [
      StarInfo(khmerName: 'ប៉ាវ បៃ', chineseName: '暴敗', englishTranslation: 'Sudden Decline'),
      StarInfo(khmerName: 'ទៀន អ៊ឹរ', chineseName: '天厄', englishTranslation: 'Heavenly Misfortune'),
      StarInfo(khmerName: 'ទៀន សា', chineseName: '天殺', englishTranslation: 'Heavenly Sha'),
    ],
    inauspiciousWarnings:
        'គេនិយាយមួលបង្កាច់ បង្ខូចឈ្មោះ អាចមានក្តីក្តាំផ្លូវច្បាប់ មានជំលោះ ត្រូវចេះទប់អារម្មណ៍ បាត់របស់ភ្លាមៗ ឈឺធ្ងន់ភ្លាមៗ ប្រយ័ត្នមិត្តភ័ក្តិឯងបោកប្រាស់!',
  ),
  ZodiacForecast(
    id: 'tiger',
    englishName: 'Tiger',
    chineseName: '虎',
    auspiciousStars: [
      StarInfo(khmerName: 'សាន ហេ', chineseName: '三合', englishTranslation: 'Three Harmony'),
      StarInfo(khmerName: 'ស្វេ តាង', chineseName: '學堂', englishTranslation: 'Study Hall'),
    ],
    auspiciousPredictions:
        'យល់ពីជីវិតនិងស្ថានការណ៍ជ្រៅជ្រះ និងគេទទួលស្កាល់ជាងមុន\nឆ្នាំនេះបើរៀនជំនាញថ្មីនឹងបានលាភ បើប្រលងនឹងជាប់\nធ្វើការនឹងបានទទួលដំណែងថ្មី រឺឡើងប្រាក់ខែ រឺលុយកាក់\nលាភច្រើនឆ្នាំនេះ បើឧស្សាហ៍នឹងចាប់បានច្រើន',
    inauspiciousStars: [
      StarInfo(khmerName: 'បៃ ហូ', chineseName: '白虎', englishTranslation: 'White Tiger'),
      StarInfo(khmerName: 'ហ្វី លៀន', chineseName: '飛廉', englishTranslation: 'Flying Insect'),
      StarInfo(khmerName: 'ដា សា', chineseName: '大殺', englishTranslation: 'Major Sha'),
      StarInfo(khmerName: 'ជី ប៉ី', chineseName: '指背', englishTranslation: 'Back Pointing'),
    ],
    inauspiciousWarnings:
        'គេនិយាយមួលបង្កាច់ បង្ខូចឈ្មោះ អាចមានក្តីក្តាំផ្លូវច្បាប់\nមានជំលោះ ត្រូវចេះទប់អារម្មណ៍\nចេះតែចង់នៅម្នាក់ឯង មានជំងឺសល់ពីឆ្នាំចាស់\nគ្រោះផ្លូវឆ្ងាយ មិត្តជិតស្និតនឹងក្បត់អ្នក ចូរប្រយ័ត្ន',
  ),
  ZodiacForecast(
    id: 'rabbit',
    englishName: 'Rabbit',
    chineseName: '兔',
    auspiciousStars: [
      StarInfo(khmerName: 'ទៀន ដេ', chineseName: '天德', englishTranslation: 'Heavenly Virtue'),
      StarInfo(khmerName: 'ហ្វូ ដេ', chineseName: '福德', englishTranslation: 'Fortune Virtue'),
      StarInfo(khmerName: 'ហ្វូ ស៊ីង', chineseName: '福星', englishTranslation: 'Good fortune'),
      StarInfo(khmerName: 'ទៀន ស៊ី', chineseName: '天喜', englishTranslation: 'Heavenly Happiness'),
    ],
    auspiciousPredictions:
        'សុភមង្គល ស្ងប់សុខ និងទទួលពរជ័យពីឋានសួគ៌\nសុខភាពប្រសើជាឆ្នាំមុន និងមានគេជួយជ្រោមជ្រែងបើកផ្លូវ\nរីកចម្រើន ហេងថ្កុំថ្កើង និងទទួលបានលាភពីរបររកស៊ីការងារ',
    inauspiciousStars: [
      StarInfo(khmerName: 'ពី ម៉ា', chineseName: '披麻', englishTranslation: 'Jute Cover'),
      StarInfo(khmerName: 'ជួន សេ', chineseName: '卷舌', englishTranslation: 'Twisting Tongue'),
      StarInfo(khmerName: 'ជៀវ សា', chineseName: '絞殺', englishTranslation: 'Strangling Sha'),
      StarInfo(khmerName: 'សៀន ឈី', chineseName: '咸池', englishTranslation: 'Bathing Hall'),
    ],
    inauspiciousWarnings:
        'គេច្រណែន មួលបង្កាច់ក្រោយខ្នង ក្តីក្តាំអាចនឹងមានរឺមិនទាន់ចប់\nប្រយ័ត្នគូស្នេហ៍មិនស្មោះត្រង់ រឺនាំទុក្ខពីក្រៅមក\nគ្រួសារនឹងមានអ្នកឈឺ មើលមិនទាន់ឈឺធ្ងន់\nនិងប្រយ័ត្នដំណើរជិតឆ្ងាយ',
  ),
  ZodiacForecast(
    id: 'dragon',
    englishName: 'Dragon',
    chineseName: '龙',
    auspiciousStars: [
      StarInfo(khmerName: 'ទៀន ជៀ', chineseName: '天解', englishTranslation: 'Heavenly Relief'),
      StarInfo(khmerName: 'ជៀ សឹន', chineseName: '解神', englishTranslation: 'Resolving God'),
      StarInfo(khmerName: 'បា សួច', chineseName: '八座', englishTranslation: 'Eight Seats'),
    ],
    auspiciousPredictions:
        'ដំណោះស្រាយនឹងមាន ឋាមពលពិសេសក្នុងខ្លួននឹងកើនឡើង\nឡើងប្រាក់ខែ និយាយគេស្តាប់\nនឹងឡើងឋានៈ អស្សនៈ៨ទិស នឹងមានគេកោតក្រែង\nក្តីក្តាំឈ្នះគេ រត់ការការងាររកស៊ីនឹងបានសម្រេច',
    inauspiciousStars: [
      StarInfo(khmerName: 'ទៀន កូ', chineseName: '天狗', englishTranslation: 'Heavenly Dog'),
      StarInfo(khmerName: 'ឌៀវ ខេ', chineseName: '弔客', englishTranslation: 'Sadness Star'),
      StarInfo(khmerName: 'ស្វេ ស៊ិន', chineseName: '血刃', englishTranslation: 'Bloody Blade'),
      StarInfo(khmerName: 'ហ្វូ ចឹន', chineseName: '浮沈', englishTranslation: 'Float and sink'),
    ],
    inauspiciousWarnings:
        'នឹងជួបគ្រោះថ្នាក់ និងជំលោះ\nជំលោះការងារ និងជំលោះដៃគូរ\nចិត្តត្រជាក់ៗ របស់បានដល់ដៃអាចរបូត កុំប្រហែស\nបញ្ហាសុខភាព និងគ្រោះថ្នាក់',
  ),
  ZodiacForecast(
    id: 'snake',
    englishName: 'Snake',
    chineseName: '蛇',
    auspiciousStars: [
      StarInfo(khmerName: 'លូ ស៊ុន', chineseName: '祿勲', englishTranslation: 'Prosperity Medal'),
    ],
    auspiciousPredictions:
        'នឹងត្រូវបានគេទទួលស្គាល់ មេកើយទុកចិត្ត\nនឹងផ្តល់រង្វាន់ នឹងបានឡើងឋានៈ ឡើងលាភ\nឡើងលុយ ឡើងប្រាក់ខែ\nមានមិត្តភ័ក្តិជួយទំនុកបម្រុងជ្រោមជ្រែង។',
    inauspiciousStars: [
      StarInfo(khmerName: 'ម៉ូ យ៉ូ', chineseName: '驀越', englishTranslation: 'Fast Changes'),
      StarInfo(khmerName: 'ប៊ីង ហ្វូ', chineseName: '病符', englishTranslation: 'Disease Note'),
      StarInfo(khmerName: 'ប៉ូ សួយ', chineseName: '破碎', englishTranslation: 'Broken Pieces'),
      StarInfo(khmerName: 'វ៉ាង សឹន', chineseName: '亡神', englishTranslation: 'Clouded Spirit'),
    ],
    inauspiciousWarnings:
        'មានរឿងច្រើនកើតនៅផ្ទះ ត្រូវចេះបត់បែន\nនឹងមានជំងឺចាស់រើវិញ អាចលែងលះគូរស្នេហ៍\nបាត់ទ្រព្យ នៅឲ្យឆ្ងាយពីមនុស្សអវិជ្ជមាន\nនិងគ្រោះខែ',
  ),
  ZodiacForecast(
    id: 'horse',
    englishName: 'Horse',
    chineseName: '马',
    auspiciousStars: [
      StarInfo(khmerName: 'សួយ ជៀ', chineseName: '歲駕', englishTranslation: 'Yearly Governing'),
      StarInfo(khmerName: 'ជៀង ស៊ីង', chineseName: '將星', englishTranslation: 'General Star'),
      StarInfo(khmerName: 'ជីន ក្វី', chineseName: '金匱', englishTranslation: 'Golden Cabinet'),
    ],
    auspiciousPredictions:
        'គ្រែស្នែងទេវតា ព្រះរាជាស្រលាញ់ពេញបេះដូង\nនឹងបានធ្វើដំណើរជោគជ័យ ប្តូរកន្លែងក៏បានលាភ\nបានតំណែង ឡើងឋានៈ ផ្លាស់ប្តូខ្សែជីវិតថ្មី\nបញ្ជាគេបាន មានអំណាច គេស្តាប់បង្គាប់\nមានគេហែហមទំនុកបំរុង\nទ្រព្យសន្សំនឹងកើនឡើង បើយកមកវិនិយាគ នឹងហេង មិនខាតបង់',
    inauspiciousStars: [
      StarInfo(khmerName: 'តាយ សួយ', chineseName: '太歲', englishTranslation: 'Yearly God'),
      StarInfo(khmerName: 'ជៀន ហ្វេង', chineseName: '劍鋒', englishTranslation: 'Sword Tip'),
      StarInfo(khmerName: 'ហ្វូ ស៊ី', chineseName: '伏屍', englishTranslation: 'Corpse'),
      StarInfo(khmerName: 'សួយ ស៊ីង', chineseName: '歲刑', englishTranslation: 'Yearly Confinement'),
    ],
    inauspiciousWarnings:
        'ទេវតាកាន់ឆ្នាំគ្រងតំណែង ហត់នឿយ សម្ពាធច្រើន\nងាយឆេវឆាវ គិតច្រើនជ្រុល គេងមិនលក់\nអាចនឹងមានឈាមចេញពីខ្លួនច្រើនប្រយ័ត្នអស់បុណ្យ\nតែតារាលាភទាំង៣ នឹងជួយកាត់ឆុងឲ្យ\nលេខខ្មោចគេកប់ចោល\nជំងឺផ្លូវចិត្តធ្ងន់ ព្រោះទូលរែករឿងគ្រួសារតែឯង\nចាក់ច្រវ៉ាក់ចងជើងខ្លួនឯងកន្លែងដដែល',
  ),
  ZodiacForecast(
    id: 'goat',
    englishName: 'Goat',
    chineseName: '羊',
    auspiciousStars: [
      StarInfo(khmerName: 'តាយ យ៉ាង', chineseName: '太陽', englishTranslation: 'The Sun'),
      StarInfo(khmerName: 'សួយ ហេ', chineseName: '歲合', englishTranslation: 'Yearly Harmony'),
      StarInfo(khmerName: 'បាន អាន', chineseName: '板鞍', englishTranslation: 'Horse Saddle'),
    ],
    auspiciousPredictions:
        'ពន្លឺព្រះអាទិត្យភ្លឺត្រចះត្រចង់ នឹងមានអ្នកមានបុណ្យជួយជ្រោមជ្រែងបានលាភបានជ័យ ដំណោះស្រាយអ្វីក៏មានច្រកចេញ។ ល្អណាស់! សុខដុមរមនាឆ្នាំថ្មី ឋាមពលឈី (Qi) វិជ្ជមានខ្ពស់ណាស់ គ្រោះទៅជាលាភ លាភទៅជាស្តុកស្តម្ភ ជីវិតឡើងមួយថ្នាក់',
    inauspiciousStars: [
      StarInfo(khmerName: 'ទៀន កុង', chineseName: '天空', englishTranslation: 'Sky Emptiness'),
      StarInfo(khmerName: 'ហ៊ូយ ឈី', chineseName: '晦气', englishTranslation: 'Obstacle Star'),
      StarInfo(khmerName: 'ច្រិត ជីវ៉ូ សេ សា', chineseName: '酒色煞', englishTranslation: 'Negative Sha'),
      StarInfo(khmerName: 'លៀវ សៀ', chineseName: '六煞', englishTranslation: 'Liu Sha'),
    ],
    inauspiciousWarnings:
        'ផ្លូវចិត្តធំដូចផ្ទៃមេឃ តែទទេស្អាត ងាយនឹងប្រើចិត្តខុស បំណងដែលហួសព្រំដែន នឹងមិនបានផល ឧបសគ្គនឹងកើតមានពេលចិត្តមិនស្រស់ស្រាយ មនុស្សចាំកេងចំណេញមានច្រើនឆ្នាំនេះ ត្រូវចំណាយពេលបង្រៀនចិត្ត រំសាយអារម្មណ៍ ងាយនឹងយកស្រា យកល្បែងបាំងមុខ នឹងមានឈាមចេញពីខ្លួនបើមិនប្រយ័ត្ន កំរិតវះកាត់ រឺសន្លប់ច្រើនថ្ងៃ',
  ),
  ZodiacForecast(
    id: 'monkey',
    englishName: 'Monkey',
    chineseName: '猴',
    auspiciousStars: [
      StarInfo(khmerName: 'សួយ ឌៀន', chineseName: '歳殿', englishTranslation: 'Yearly Palace'),
      StarInfo(khmerName: 'វ៉ិន ចាង', chineseName: '文昌', englishTranslation: 'Intelligence Star'),
      StarInfo(khmerName: 'អ៊ី ម៉ា', chineseName: '驛馬', englishTranslation: 'Traveling Horse'),
    ],
    auspiciousPredictions:
        'តារាបង្ហាញផ្លូវ អាចនឹងមានរៀបចំណងអាពាហ៍ពិពាហ៍ រឺចាប់ដៃគូរជីវិត តារាបញ្ញាញាណនៅរក្សា បើប្រលងជានិស្សិតរឺមន្ត្រីរាជការ នឹងបានដុចបំំណង តារានេះងាយឲ្យអ្នកប្រលងជាប់។ ចុះកុងត្រាមិនងាយចាញ់បោកគេ។ មានទំនោនឹងប្តុរកន្លែងការងារ រឺផ្ទះសម្បែក រឺចំណាកស្រុក។ ធ្វើដំណើរច្រើន។',
    inauspiciousStars: [
      StarInfo(khmerName: 'សាង ម៉ិន', chineseName: '喪門', englishTranslation: 'Funeral Gate'),
      StarInfo(khmerName: 'ឌី សាន', chineseName: '地喪', englishTranslation: 'Earth Funeral'),
      StarInfo(khmerName: 'ហ្គូ ចឹន', chineseName: '孤辰', englishTranslation: 'Lonely Spirit'),
      StarInfo(khmerName: 'ហ្គូ ស៊ូ', chineseName: '孤虚', englishTranslation: 'Lonely Emptiness'),
    ],
    inauspiciousWarnings:
        'សាលដំកល់សព ងាយបាត់សមាជិកគ្រួសារ រឺអ្នកធ្លាប់ស្គាល់ កើតទុក្ខក្រៀមក្រំដោយសារដៃគូរមិនបានដូចចិត្ត។ បើឈឺ គឺជំងឺកាច គួរទៅពិនិត្យព្យាបាលក្នុងឆ្នាំនេះ មានគូមិនយល់ចិត្ត ចង់នៅម្នាក់ឯង សើចនៅមុខ យំក្នុងចិត្ត គេឃើញចំនុចខ្សោយ ចូរប្រយ័ត្ន',
  ),
  ZodiacForecast(
    id: 'rooster',
    englishName: 'Rooster',
    chineseName: '鸡',
    auspiciousStars: [
      StarInfo(khmerName: 'តាយ យិន', chineseName: '太陰', englishTranslation: 'The Moon'),
      StarInfo(khmerName: 'ហុង លួន', chineseName: '紅鸞', englishTranslation: 'Romance Star'),
      StarInfo(khmerName: 'ទៀន អ៊ី', chineseName: '天乙', englishTranslation: 'Noble Support'),
    ],
    auspiciousPredictions:
        'សម្រប់ផូរផង់ត្រលប់មកវិញ មានង៉ូវហេង នឹងជួបគូរ ធាតុអ៊ីនខ្លាំងគួជាទីស្រលាញ់របស់មនុស្សទាំងឡាយ មានដំណឹងល្អ គេសារភាពស្រលាញ់ នឹងមានអំណោយដោយមិនដឹងខ្លួន គូរឆ្នាំនេះបើយកគ្នាគឺត្រូវ! មយូរ៉ាជួបនាគ។ មានអ្នកធំជួយជ្រោមជ្រែង ពឹងគេបាន។ លុយមិនគ្រប់ មានគេជួបបន្ថែម។',
    inauspiciousStars: [
      StarInfo(khmerName: 'កូ ជៀវ', chineseName: '勾紋', englishTranslation: 'Entaglement'),
      StarInfo(khmerName: 'ក្វាន សួច', chineseName: '貫索', englishTranslation: 'Rope Tying'),
      StarInfo(khmerName: 'ហ្សូ ប៉ាវ', chineseName: '卒暴', englishTranslation: 'Sudden Disease'),
    ],
    inauspiciousWarnings:
        'ប្រយ័ត្នមានរឿងសាហាយស្មន់ លួចលាក់ គេចមិនផុត នឹងធ្លាយចេញ។ ខូចកិត្តយស។ ធ្លាយពីអ្នកជិតស្និត និងដៃគូរខាងក្រៅ។ គេនិយាយដើម នាំបញ្ហាចូលផ្ទះ បំណុលដោះមិនទាន់អស់ទេ រឿងចូលគ្រប់ច្រក ពេលមានរឿងមួយ គួរណាស់កុំបន្ថែមរឿង',
  ),
  ZodiacForecast(
    id: 'dog',
    englishName: 'Dog',
    chineseName: '狗',
    auspiciousStars: [
      StarInfo(khmerName: 'សាន ហេ', chineseName: '三合', englishTranslation: 'Three Harmony'),
      StarInfo(khmerName: 'ឌី ជៀ', chineseName: '地解', englishTranslation: 'Earthly Resolve'),
      StarInfo(khmerName: 'ហួ កៃ', chineseName: '華蓋', englishTranslation: 'Luxury Cover'),
    ],
    auspiciousPredictions:
        'មានមិនល្អជួយជ្រោមជ្រែង ចៅហ្វាយនាយជឿជាក់ រកស៊ីឈ្នះគេ។ បើចង់ជួបជុំជាមួយអ្នកណា និយាយនឹងគេបាន ដំណោះស្រាយបំណុល រឿងការងារ ក្តីក្តាំ ធ្វើឆ្នាំនេះនឹងបានចប់',
    inauspiciousStars: [
      StarInfo(khmerName: 'វូ ក្វី', chineseName: '五鬼', englishTranslation: 'Five Ghosts'),
      StarInfo(khmerName: 'ក្វាន ហ្វូ', chineseName: '官符', englishTranslation: 'Legal Notice'),
      StarInfo(khmerName: 'ពី ទូ', chineseName: '披頭', englishTranslation: 'Scruffy Hair'),
    ],
    inauspiciousWarnings:
        'មនុស្សល្អិតល្អោចនាំរឿងឥតបានការក្លាយជារឿងធំ តែបើចេះប្រើខ្មោចអោយបាយស៊ី នឹងបានផ្ទុះលាភ ជំលោះកន្លែងការងារ រកស៊ី អ្នកចូលហ៊ុន ប្រយ័ត្ន សោកសៅ បាត់ដំណឹង លាហើយមិនងាកក្រោយ បើបាត់របស់ពិបាករកឃើញ មនុស្សនៅនឹងមុខលាជារៀងរហូត លែងលះពិបាកយកគ្នា។',
  ),
  ZodiacForecast(
    id: 'pig',
    englishName: 'Pig',
    chineseName: '猪',
    auspiciousStars: [
      StarInfo(khmerName: 'យ៉ូ ដេ', chineseName: '月德', englishTranslation: 'Monthly Virtue'),
      StarInfo(khmerName: 'យូ តាង', chineseName: '玉堂', englishTranslation: 'Jade Hall'),
    ],
    auspiciousPredictions:
        'កិច្ចខំប្រឹងប្រែងជាច្រើនឆ្នាំនឹងបានគេទទួលស្គាល់ ដល់ពេលអោបយកលាភ និងសមិទ្ធិផល។ លុយកាក់នឹងមានបានច្រើនឡើងវិញឆ្នាំនេះ បើប្រលងនឹងជាប់ នឹងបានតាំងស៊ប់ អ្នកធំ អ្នកស្រលាញ់ នឹងជ្រោមជ្រែង',
    inauspiciousStars: [
      StarInfo(khmerName: 'សៀវ ហាវ', chineseName: '小耗', englishTranslation: 'Small Waste'),
      StarInfo(khmerName: 'ស៊ី ហ្វូ', chineseName: '死符', englishTranslation: 'Death Note'),
      StarInfo(khmerName: 'យូ អ៊ី', chineseName: '遊奕', englishTranslation: 'Aimless Wander'),
    ],
    inauspiciousWarnings:
        'បាត់របស់លុយកាក់ ចាញ់បោកគេ បាត់មនុស្សចាស់ក្នុងផ្ទះ បាត់សមាជិកដែលធ្លាប់ស្រលាញ់ ជំងឺបៀតបៀនខ្លួន រឺនឹងឆ្លង ពិបាកព្យាបាល អ្នកក្លាហានឯកោ នឹងប្តូរការងារ ពិបាកមុនស្រណុកក្រោយ',
  ),
];

/// Localized display name for a zodiac sign by id.
String zodiacDisplayName(AppLocalizations l10n, String id) {
  switch (id) {
    case 'rat':
      return l10n.zodiacRat;
    case 'ox':
      return l10n.zodiacOx;
    case 'tiger':
      return l10n.zodiacTiger;
    case 'rabbit':
      return l10n.zodiacRabbit;
    case 'dragon':
      return l10n.zodiacDragon;
    case 'snake':
      return l10n.zodiacSnake;
    case 'horse':
      return l10n.zodiacHorse;
    case 'goat':
      return l10n.zodiacGoat;
    case 'monkey':
      return l10n.zodiacMonkey;
    case 'rooster':
      return l10n.zodiacRooster;
    case 'dog':
      return l10n.zodiacDog;
    case 'pig':
      return l10n.zodiacPig;
    default:
      return id;
  }
}

/// Returns 5 recent birth years for a zodiac sign (12-year cycle; 2024 = Dragon).
List<int> zodiacBirthYears(String zodiacId) {
  const baseYears = {
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

  var mostRecentYear = baseYear;
  while (mostRecentYear + 12 <= currentYear) {
    mostRecentYear += 12;
  }

  final years = <int>[];
  for (var i = 0; i < 5; i++) {
    years.add(mostRecentYear - (i * 12));
  }
  return years.reversed.toList();
}

String starDisplaySecondary(StarInfo star, String locale) {
  switch (locale) {
    case 'zh':
      return star.englishTranslation;
    case 'km':
      return '${star.khmerName} · ${star.englishTranslation}';
    default:
      return star.englishTranslation;
  }
}

extension ZodiacForecastX on ZodiacForecast {
  bool get hasDetailedContent =>
      (auspiciousStars != null && auspiciousStars!.isNotEmpty) ||
      (inauspiciousStars != null && inauspiciousStars!.isNotEmpty);
}

ZodiacForecast? zodiacForecastById(String id) {
  for (final z in zodiacForecasts) {
    if (z.id == id) return z;
  }
  return null;
}
