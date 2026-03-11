/// Constants for inspection form dropdowns and predefined options.
library;

/// Months of the year (for Month of Visit).
const List<String> kMonths = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// 8 Trigrams (八卦) for Converted to Trigram.
const List<String> kTrigrams = [
  'Qian (乾) - Heaven', 'Kun (坤) - Earth', 'Zhen (震) - Thunder',
  'Xun (巽) - Wind', 'Kan (坎) - Water', 'Li (離) - Fire',
  'Gen (艮) - Mountain', 'Dui (兌) - Lake',
];

/// 8 Directions for Sheng Qi, Tian Yi, Yan Nian, Fu Wei.
const List<String> kEightDirections = [
  'North', 'South', 'East', 'West',
  'Northeast', 'Northwest', 'Southeast', 'Southwest',
];

/// Eight Mansions sectors (8 palaces).
const List<String> kEightMansionsSectors = [
  'Kan (坎) - North', 'Kun (坤) - Southwest', 'Zhen (震) - East',
  'Xun (巽) - Southeast', 'Qian (乾) - Northwest', 'Dui (兌) - West',
  'Gen (艮) - Northeast', 'Li (離) - South',
];

/// Flying Stars 1–9.
const List<String> kFlyingStars = [
  'Star 1', 'Star 2', 'Star 3', 'Star 4', 'Star 5',
  'Star 6', 'Star 7', 'Star 8', 'Star 9',
];

/// 24 Solar Terms (二十四节气).
const List<String> kSolarTerms = [
  'Lichun (立春)', 'Yushui (雨水)', 'Jingzhe (惊蛰)', 'Chunfen (春分)',
  'Qingming (清明)', 'Guyu (谷雨)', 'Lixia (立夏)', 'Xiaoman (小满)',
  'Mangzhong (芒种)', 'Xiazhi (夏至)', 'Xiaoshu (小暑)', 'Dashu (大暑)',
  'Liqiu (立秋)', 'Chushu (处暑)', 'Bailu (白露)', 'Qiufen (秋分)',
  'Hanlu (寒露)', 'Shuangjiang (霜降)', 'Lidong (立冬)', 'Xiaoxue (小雪)',
  'Daxue (大雪)', 'Dongzhi (冬至)', 'Xiaohan (小寒)', 'Dahan (大寒)',
];

/// Lunar dates (day of month 1–30).
const List<String> kLunarDates = [
  '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th',
  '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th', '19th', '20th',
  '21st', '22nd', '23rd', '24th', '25th', '26th', '27th', '28th', '29th', '30th',
];

/// Weather conditions for inspection.
const List<String> kWeatherConditions = [
  'Sunny', 'Cloudy', 'Overcast', 'Rainy', 'Stormy', 'Foggy', 'Partly cloudy',
];

/// Years for completion/construction (1980–2040).
final List<String> kYears = List.generate(61, (i) => (1980 + i).toString());

/// Chinese zodiac (12 animals).
const List<String> kChineseZodiac = [
  'Rat (鼠)', 'Ox (牛)', 'Tiger (虎)', 'Rabbit (兔)', 'Dragon (龙)', 'Snake (蛇)',
  'Horse (马)', 'Goat (羊)', 'Monkey (猴)', 'Rooster (鸡)', 'Dog (狗)', 'Pig (猪)',
];

/// Personal Gua options (8 trigrams for Bazi).
const List<String> kPersonalGua = [
  'Kan (坎) - Water', 'Kun (坤) - Earth', 'Zhen (震) - Wood', 'Xun (巽) - Wood',
  'Qian (乾) - Metal', 'Dui (兌) - Metal', 'Gen (艮) - Earth', 'Li (離) - Fire',
];
