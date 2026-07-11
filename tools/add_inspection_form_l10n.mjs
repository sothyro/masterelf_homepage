#!/usr/bin/env node
/**
 * Adds site inspection form field labels and dropdown option keys to EN/KM/ZH ARB files.
 * Run: node tools/add_inspection_form_l10n.mjs && flutter gen-l10n
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const l10nDir = path.join(__dirname, '..', 'lib', 'l10n');

function loadArb(name) {
  return JSON.parse(fs.readFileSync(path.join(l10nDir, name), 'utf8'));
}

function saveArb(name, data) {
  fs.writeFileSync(path.join(l10nDir, name), JSON.stringify(data, null, 2) + '\n', 'utf8');
}

const ordinals = [
  '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th',
  '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th', '19th', '20th',
  '21st', '22nd', '23rd', '24th', '25th', '26th', '27th', '28th', '29th', '30th',
];

const solarEn = [
  'Lichun (立春)', 'Yushui (雨水)', 'Jingzhe (惊蛰)', 'Chunfen (春分)',
  'Qingming (清明)', 'Guyu (谷雨)', 'Lixia (立夏)', 'Xiaoman (小满)',
  'Mangzhong (芒种)', 'Xiazhi (夏至)', 'Xiaoshu (小暑)', 'Dashu (大暑)',
  'Liqiu (立秋)', 'Chushu (处暑)', 'Bailu (白露)', 'Qiufen (秋分)',
  'Hanlu (寒露)', 'Shuangjiang (霜降)', 'Lidong (立冬)', 'Xiaoxue (小雪)',
  'Daxue (大雪)', 'Dongzhi (冬至)', 'Xiaohan (小寒)', 'Dahan (大寒)',
];

/** @type {Record<string, { en: string; km: string; zh: string }>} */
const patches = {
  inspectionXuanKongPeriod: {
    en: 'Xuan Kong Period',
    km: 'រយៈកាលស៊ួនកុង (Xuan Kong)',
    zh: '玄空运期',
  },
  inspectionPeriod7: {
    en: 'Period 7 (1984–2003)',
    km: 'យុគទី ៧ (១៩៨៤–២០០៣)',
    zh: '七运 (1984–2003)',
  },
  inspectionPeriod8: {
    en: 'Period 8 (2004–2023)',
    km: 'យុគទី ៨ (២០០៤–២០២៣)',
    zh: '八运 (2004–2023)',
  },
  inspectionPeriod9Option: {
    en: 'Period 9 (2024–2043)',
    km: 'យុគទី ៩ (២០២៤–២០៤៣)',
    zh: '九运 (2024–2043)',
  },
  inspectionConvertedToTrigram: {
    en: 'Converted to Trigram',
    km: 'បម្លែងទៅប្រាំបីហ្គ្រាម (Trigram)',
    zh: '转换为卦象',
  },
  inspectionHouseGua: { en: 'House Gua', km: 'គួរផ្ទះ (House Gua)', zh: '宅卦' },
  inspectionHouseKan: {
    en: 'Kan House (坎) - Sitting North',
    km: 'ផ្ទះកាន់ (坎) - អង្គុយខាងជើង',
    zh: '坎宅 (坎) - 坐北',
  },
  inspectionHouseKun: {
    en: 'Kun House (坤) - Sitting Southwest',
    km: 'ផ្ទះគុន (坤) - អង្គុយខាងត្បូងពាយព្យ',
    zh: '坤宅 (坤) - 坐西南',
  },
  inspectionHouseZhen: {
    en: 'Zhen House (震) - Sitting East',
    km: 'ផ្ទះចិន (震) - អង្គុយខាងកើត',
    zh: '震宅 (震) - 坐东',
  },
  inspectionHouseXun: {
    en: 'Xun House (巽) - Sitting Southeast',
    km: 'ផ្ទះស៊ុន (巽) - អង្គុយខាងត្បូងកើត',
    zh: '巽宅 (巽) - 坐东南',
  },
  inspectionHouseQian: {
    en: 'Qian House (乾) - Sitting Northwest',
    km: 'ផ្ទះឈៀន (乾) - អង្គុយខាងជើងពាយព្យ',
    zh: '乾宅 (乾) - 坐西北',
  },
  inspectionHouseDui: {
    en: 'Dui House (兌) - Sitting West',
    km: 'ផ្ទះឌួយ (兌) - អង្គុយខាងលិច',
    zh: '兑宅 (兌) - 坐西',
  },
  inspectionHouseGen: {
    en: 'Gen House (艮) - Sitting Northeast',
    km: 'ផ្ទះហ្គេន (艮) - អង្គុយខាងជើងកើត',
    zh: '艮宅 (艮) - 坐东北',
  },
  inspectionHouseLi: {
    en: 'Li House (離) - Sitting South',
    km: 'ផ្ទះលី (離) - អង្គុយខាងត្បូង',
    zh: '离宅 (離) - 坐南',
  },
  inspectionHouseGroup: { en: 'House Group', km: 'ក្រុមផ្ទះ', zh: '宅组' },
  inspectionHouseGroupEast: {
    en: 'East Group (Kan, Zhen, Xun, Li)',
    km: 'ក្រុមខាងកើត (កាន់, ចិន, ស៊ុន, លី)',
    zh: '东四命 (坎、震、巽、离)',
  },
  inspectionHouseGroupWest: {
    en: 'West Group (Qian, Kun, Gen, Dui)',
    km: 'ក្រុមខាងលិច (ឈៀន, គុន, ហ្គេន, ឌួយ)',
    zh: '西四命 (乾、坤、艮、兑)',
  },
  inspectionMainEntranceSector: {
    en: 'Main Entrance - Eight Mansions sector',
    km: 'ច្រកចូលចម្បង - ប្រាង្គប្រាំបីផ្ទះ (Eight Mansions)',
    zh: '主入口 - 八宅方位',
  },
  inspectionMainEntranceQuality: {
    en: 'Main Entrance - Quality',
    km: 'ច្រកចូលចម្បង - គុណភាព',
    zh: '主入口 - 吉凶',
  },
  inspectionManagerOfficeSector: {
    en: 'Manager/Owner Office - Sector',
    km: 'ការិយាល័យអ្នកគ្រប់គ្រង/ម្ចាស់ - ប្រាង្គ',
    zh: '经理/业主办公室 - 方位',
  },
  inspectionManagerOfficeQuality: {
    en: 'Manager/Owner Office - Quality',
    km: 'ការិយាល័យអ្នកគ្រប់គ្រង/ម្ចាស់ - គុណភាព',
    zh: '经理/业主办公室 - 吉凶',
  },
  inspectionCashierSector: {
    en: 'Cashier/Safe - Sector',
    km: 'ការិយាល័យទូរសារ/ធុងសុវត្ថិភាព - ប្រាង្គ',
    zh: '收银/保险柜 - 方位',
  },
  inspectionCashierQuality: {
    en: 'Cashier/Safe - Quality',
    km: 'ការិយាល័យទូរសារ/ធុងសុវត្ថិភាព - គុណភាព',
    zh: '收银/保险柜 - 吉凶',
  },
  inspectionToiletSector: {
    en: 'Toilet Location - Sector',
    km: 'ទីតាំងបន្ទប់ទឹក - ប្រាង្គ',
    zh: '厕所位置 - 方位',
  },
  inspectionToiletImpact: { en: 'Toilet Impact', km: 'ឥទ្ធិពលបន្ទប់ទឹក', zh: '厕所影响' },
  inspectionToiletAcceptable: {
    en: 'Acceptable (at unfavorable sector)',
    km: 'ទទួលយកបាន (នៅប្រាង្គមិនល្អ)',
    zh: '可接受（位于凶方）',
  },
  inspectionToiletPoor: {
    en: 'Poor (at favorable sector)',
    km: 'អាក្រក់ (នៅប្រាង្គល្អ)',
    zh: '不佳（位于吉方）',
  },
  inspectionClientFullName: {
    en: 'Primary Client/Owner - Full Name',
    km: 'អតិថិជន/ម្ចាស់ចម្បង - ឈ្មោះពេញ',
    zh: '主要客户/业主 - 全名',
  },
  inspectionClientRole: { en: 'Role', km: 'តួនាទី', zh: '角色' },
  inspectionRoleOwner: { en: 'Owner', km: 'ម្ចាស់', zh: '业主' },
  inspectionRoleMainTenant: { en: 'Main Tenant', km: 'អ្នកជួលចម្បង', zh: '主租户' },
  inspectionRoleCeo: { en: 'CEO', km: 'នាយកប្រតិបត្តិ', zh: '首席执行官' },
  inspectionRoleManager: { en: 'Manager', km: 'អ្នកគ្រប់គ្រង', zh: '经理' },
  inspectionBirthDate: { en: 'Birth Date', km: 'ថ្ងៃខែឆ្នាំកំណើត', zh: '出生日期' },
  inspectionBirthTime: { en: 'Birth Time', km: 'ម៉ោងកំណើត', zh: '出生时间' },
  inspectionPlaceOfBirth: { en: 'Place of Birth', km: 'ទីកន្លែងកំណើត', zh: '出生地' },
  inspectionDayMaster: { en: 'Day Master', km: 'ថ្ងៃមេ (Day Master)', zh: '日主' },
  inspectionFavorableElements: { en: 'Favorable Elements', km: 'ធាតុអំណោយផល', zh: '喜用神' },
  inspectionUnfavorableElements: { en: 'Unfavorable Elements', km: 'ធាតុមិនអំណោយផល', zh: '忌神' },
  inspectionElementWood: { en: 'Wood (木)', km: 'ឈើ (木)', zh: '木 (木)' },
  inspectionElementFire: { en: 'Fire (火)', km: 'ភ្លើង (火)', zh: '火 (火)' },
  inspectionElementEarth: { en: 'Earth (土)', km: 'ដី (土)', zh: '土 (土)' },
  inspectionElementMetal: { en: 'Metal (金)', km: 'លោហៈ (金)', zh: '金 (金)' },
  inspectionElementWater: { en: 'Water (水)', km: 'ទឹក (水)', zh: '水 (水)' },
  inspectionPersonalGuaLabel: {
    en: 'Personal Gua (Ming Gua)',
    km: 'គួរផ្ទាល់ខ្លួន (Ming Gua)',
    zh: '命卦 (命卦)',
  },
  inspectionPersonalGroup: { en: 'Personal Group', km: 'ក្រុមផ្ទាល់ខ្លួន', zh: '命组' },
  inspectionPersonalGroupEast: { en: 'East Group', km: 'ក្រុមខាងកើត', zh: '东四命' },
  inspectionPersonalGroupWest: { en: 'West Group', km: 'ក្រុមខាងលិច', zh: '西四命' },
  inspectionShengQiDirection: {
    en: 'Sheng Qi (Best) direction',
    km: 'ទិសសេងឈី (ល្អបំផុត)',
    zh: '生气（最佳）方位',
  },
  inspectionTianYiDirection: {
    en: 'Tian Yi (Health) direction',
    km: 'ទិសទៀនអ៊ី (សុខភាព)',
    zh: '天医（健康）方位',
  },
  inspectionYanNianDirection: {
    en: 'Yan Nian (Relationship) direction',
    km: 'ទិសយៀនញៀន (ទំនាក់ទំនង)',
    zh: '延年（人际）方位',
  },
  inspectionFuWeiDirection: {
    en: 'Fu Wei (Stability) direction',
    km: 'ទិសហ្វូវ៉េ (ស្ថិរភាព)',
    zh: '伏位（稳定）方位',
  },
  inspectionPerson2Name: { en: 'Person 2 - Name', km: 'អ្នកទី ២ - ឈ្មោះ', zh: '第二人 - 姓名' },
  inspectionPerson2Role: { en: 'Person 2 - Role', km: 'អ្នកទី ២ - តួនាទី', zh: '第二人 - 角色' },
  inspectionPerson2BirthDate: { en: 'Person 2 - Birth Date', km: 'អ្នកទី ២ - ថ្ងៃកំណើត', zh: '第二人 - 出生日期' },
  inspectionPerson2BirthTime: { en: 'Person 2 - Birth Time', km: 'អ្នកទី ២ - ម៉ោងកំណើត', zh: '第二人 - 出生时间' },
  inspectionPerson2Gua: {
    en: 'Person 2 - Personal Gua',
    km: 'អ្នកទី ២ - គួរផ្ទាល់ខ្លួន',
    zh: '第二人 - 命卦',
  },
  inspectionPerson3Name: { en: 'Person 3 - Name', km: 'អ្នកទី ៣ - ឈ្មោះ', zh: '第三人 - 姓名' },
  inspectionPerson3Role: { en: 'Person 3 - Role', km: 'អ្នកទី ៣ - តួនាទី', zh: '第三人 - 角色' },
  inspectionPerson3BirthDate: { en: 'Person 3 - Birth Date', km: 'អ្នកទី ៣ - ថ្ងៃកំណើត', zh: '第三人 - 出生日期' },
  inspectionPerson3BirthTime: { en: 'Person 3 - Birth Time', km: 'អ្នកទី ៣ - ម៉ោងកំណើត', zh: '第三人 - 出生时间' },
  inspectionPerson3Gua: {
    en: 'Person 3 - Personal Gua',
    km: 'អ្នកទី ៣ - គួរផ្ទាល់ខ្លួន',
    zh: '第三人 - 命卦',
  },
  inspectionBusinessGoals: { en: 'Primary Business Goals', km: 'គោលដៅអាជីវកម្មចម្បង', zh: '主要商业目标' },
  inspectionGoalWealth: { en: 'Wealth/profit maximization', km: 'បង្កើនទ្រព្យ/ប្រាក់ចំណេញ', zh: '财富/利润最大化' },
  inspectionGoalCustomerFlow: { en: 'Customer flow', km: 'លំហូរអតិថិជន', zh: '客流' },
  inspectionGoalStability: { en: 'Business stability', km: 'ស្ថិរភាពអាជីវកម្ម', zh: '业务稳定' },
  inspectionGoalStaffHarmony: { en: 'Staff harmony', km: 'សុខដមរបស់បុគ្គលិក', zh: '员工和谐' },
  inspectionGoalHealth: { en: 'Health and wellbeing', km: 'សុខភាព និងសុខុមាលភាព', zh: '健康与福祉' },
  inspectionGoalOther: { en: 'Other', km: 'ផ្សេងទៀត', zh: '其他' },
  inspectionSpecificConcerns: {
    en: 'Specific Concerns Raised',
    km: 'កង្វល់ជាក់លាក់ដែលបានលើកឡើង',
    zh: '提出的具体关切',
  },
  inspectionCurrentChallenges: { en: 'Current Challenges', km: 'បញ្ហាបច្ចុប្បន្ន', zh: '当前挑战' },
  inspectionChallengeFinancial: { en: 'Financial difficulties', km: 'ការលំបាកហិរញ្ញវត្ថុ', zh: '财务困难' },
  inspectionChallengeHealth: { en: 'Health issues', km: 'បញ្ហាសុខភាព', zh: '健康问题' },
  inspectionChallengeStaff: { en: 'Staff conflicts', km: 'ជម្លោះបុគ្គលិក', zh: '员工冲突' },
  inspectionChallengeLegal: { en: 'Legal problems', km: 'បញ្ហាផ្នែកច្បាប់', zh: '法律问题' },
  inspectionChallengeRelationship: { en: 'Relationship issues', km: 'បញ្ហាទំនាក់ទំនង', zh: '人际关系问题' },
  inspectionChallengeCustomerFlow: { en: 'Poor customer flow', km: 'លំហូរអតិថិជនខ្សោយ', zh: '客流不佳' },
  inspectionHealthIssuesSpecify: { en: 'Health issues (specify)', km: 'បញ្ហាសុខភាព (បញ្ជាក់)', zh: '健康问题（请注明）' },
  inspectionPlannedOpeningDate: { en: 'Planned Opening Date', km: 'ថ្ងៃបើកដំណើរដែលគ្រោង', zh: '计划开业日期' },
  inspectionPreferredDateFrom: { en: 'Preferred Date Range - From', km: 'ចន្លោះថ្ងៃពេញចិត្ត - ពី', zh: '首选日期范围 - 起' },
  inspectionPreferredDateTo: { en: 'Preferred Date Range - To', km: 'ចន្លោះថ្ងៃពេញចិត្ត - ដល់', zh: '首选日期范围 - 止' },
  inspectionActivitiesDateSelection: {
    en: 'Important Activities Requiring Date Selection',
    km: 'សកម្មភាពសំខាន់ដែលត្រូវការជ្រើសរើសថ្ងៃ',
    zh: '需要择日的重要活动',
  },
  inspectionActivityGrandOpening: { en: 'Grand opening ceremony', km: 'ពិធីបើកដំណើរដ៏ធំ', zh: '盛大开业典礼' },
  inspectionActivityRenovation: { en: 'Renovation commencement', km: 'ចាប់ផ្តើមកែលម្អ', zh: '装修开工' },
  inspectionActivityMovingIn: { en: 'Moving in/occupation', km: 'ចូលស្នាក់ការ/រស់នៅ', zh: '入伙/入驻' },
  inspectionActivitySignInstall: { en: 'Sign installation', km: 'ដំឡើងបដា', zh: '招牌安装' },
  inspectionActivityContract: { en: 'Contract signing', km: 'ចុះហត្ថលេខាកិច្ចសន្យា', zh: '签约' },
  inspectionActivityPurchases: { en: 'Major purchases', km: 'ការទិញធំ', zh: '重大采购' },
  inspectionSolarTerm: { en: 'Solar Term', km: 'វគ្គថ្ងៃ (Solar Term)', zh: '节气' },
  inspectionLunarDate: { en: 'Lunar Date', km: 'ថ្ងៃចន្លោះទុត្តិយគតិ', zh: '农历日期' },
  inspectionFavorablePalaces: {
    en: 'Favorable Palaces for This Date/Time',
    km: 'ប្រាង្គល្អសម្រាប់ថ្ងៃ/ម៉ោងនេះ',
    zh: '此日期/时辰的吉方',
  },
  inspectionUnfavorablePalaces: {
    en: 'Unfavorable Palaces for This Date/Time',
    km: 'ប្រាង្គមិនល្អសម្រាប់ថ្ងៃ/ម៉ោងនេះ',
    zh: '此日期/时辰的凶方',
  },
  inspectionGrandOpeningDate1: { en: 'For Grand Opening - Date option 1', km: 'សម្រាប់បើកដំណើរ - ជម្រើសថ្ងៃ ១', zh: '开业 - 日期选项 1' },
  inspectionGrandOpeningDate2: { en: 'For Grand Opening - Date option 2', km: 'សម្រាប់បើកដំណើរ - ជម្រើសថ្ងៃ ២', zh: '开业 - 日期选项 2' },
  inspectionGrandOpeningDate3: { en: 'For Grand Opening - Date option 3', km: 'សម្រាប់បើកដំណើរ - ជម្រើសថ្ងៃ ៣', zh: '开业 - 日期选项 3' },
  inspectionRenovationDate1: { en: 'For Renovation Start - Date option 1', km: 'សម្រាប់ចាប់ផ្តើមកែលម្អ - ជម្រើស ១', zh: '装修开工 - 日期选项 1' },
  inspectionRenovationDate2: { en: 'For Renovation Start - Date option 2', km: 'សម្រាប់ចាប់ផ្តើមកែលម្អ - ជម្រើស ២', zh: '装修开工 - 日期选项 2' },
  inspectionMustAvoid: { en: 'Must avoid', km: 'ត្រូវជៀសវាង', zh: '必须避开' },
  inspectionNumberOfMainEntrances: { en: 'Number of Main Entrances', km: 'ចំនួនច្រកចូលចម្បង', zh: '主入口数量' },
  inspectionMainDoorPosition: {
    en: 'Main Door Position (which palace/sector)',
    km: 'ទីតាំងទ្វារចម្បង (ប្រាង្គណា)',
    zh: '大门位置（宫位/方位）',
  },
  inspectionDoorConfiguration: { en: 'Door Configuration', km: 'ការកំណត់រចនាទ្វារ', zh: '门向配置' },
  inspectionDoorOpensInward: { en: 'Opens inward', km: 'បើកចូលក្នុង', zh: '向内开' },
  inspectionDoorOpensOutward: { en: 'Opens outward', km: 'បើកចេញក្រៅ', zh: '向外开' },
  inspectionDoorSliding: { en: 'Sliding door', km: 'ទ្វាររុញ', zh: '推拉门' },
  inspectionDoorAutomatic: { en: 'Automatic door', km: 'ទ្វារស្វ័យប្រវត្តិ', zh: '自动门' },
  inspectionEntranceIssues: { en: 'Issues', km: 'បញ្ហា', zh: '问题' },
  inspectionIssueBeamAboveDoor: { en: 'Beam directly above door', km: 'ធ្នឹមនៅពីលើទ្វារដោយផ្ទាល់', zh: '门上有横梁' },
  inspectionIssueThroughFlow: { en: 'Door opens to back door (through-flow)', km: 'ទ្វារបើកទៅទ្វារក្រោយ (លំហូរឆ្លង)', zh: '前后门直通' },
  inspectionIssueToStaircase: { en: 'Door opens to staircase', km: 'ទ្វារបើកទៅជណ្តើរគោល', zh: '门对楼梯' },
  inspectionIssueToToilet: { en: 'Door opens to toilet', km: 'ទ្វារបើកទៅបន្ទប់ទឹក', zh: '门对厕所' },
  inspectionIssueNarrowEntrance: { en: 'Narrow entrance/cramped', km: 'ច្រកចូលចង្អៀត/រឹតបន្តិច', zh: '入口狭窄' },
  inspectionIssueNone: { en: 'No issues observed', km: 'មិនមានបញ្ហាកត់សម្គាល់', zh: '未发现问题' },
  inspectionEntranceAssessment: { en: 'Assessment', km: 'ការវាយតម្លៃ', zh: '评估' },
  inspectionEntranceFavorable: { en: 'Favorable entrance', km: 'ច្រកចូលល្អ', zh: '吉门' },
  inspectionEntranceAcceptable: { en: 'Acceptable with minor adjustments', km: 'ទទួលយកបានជាមួយការកែតម្រូវតូច', zh: '可接受（微调即可）' },
  inspectionEntranceRemedial: { en: 'Requires remedial work', km: 'ត្រូវការការកែព្យាបាល', zh: '需要化解' },
  inspectionCeilingHeight: { en: 'Ceiling Height (m)', km: 'កម្ពស់ពិដាន (ម)', zh: '层高（米）' },
  inspectionNaturalLight: { en: 'Natural Light', km: 'ពន្លឺធម្មជាតិ', zh: '自然采光' },
  inspectionLightAbundant: { en: 'Abundant (large windows)', km: 'សម្បូរបែប (បង្អួចធំ)', zh: '充足（大窗）' },
  inspectionLightModerate: { en: 'Moderate', km: 'មធ្យម', zh: '适中' },
  inspectionLightDim: { en: 'Dim/insufficient', km: 'ងងឹត/មិនគ្រប់គ្រាន់', zh: '昏暗/不足' },
  inspectionAirCirculation: { en: 'Air Circulation', km: 'ការរំញ័រខ្យល់', zh: '空气流通' },
  inspectionAirGood: { en: 'Good ventilation', km: 'ការបរិសុទ្ធល្អ', zh: '通风良好' },
  inspectionAirPoor: { en: 'Poor/stagnant', km: 'អាក្រក់/ឈឺចាប់', zh: '差/停滞' },
  inspectionFloorPlanShape: { en: 'Floor Plan Shape', km: 'រាងប្លង់', zh: '平面形状' },
  inspectionShapeSquare: { en: 'Square/rectangular (ideal)', km: 'ការេ/ចតុកោណ (ល្អបំផុត)', zh: '方正（理想）' },
  inspectionShapeL: { en: 'L-shaped', km: 'រាង L', zh: 'L形' },
  inspectionShapeIrregular: { en: 'Irregular', km: 'មិនទៀង', zh: '不规则' },
  inspectionShapeTriangular: { en: 'Triangular sections', km: 'ផ្នែកត្រីកោណ', zh: '三角形区域' },
  inspectionReceptionSector: { en: 'Reception/Cashier - Sector', km: 'ទទួលភ្ញៀវ/ការិយាល័យទូរសារ - ប្រាង្គ', zh: '前台/收银 - 方位' },
  inspectionReceptionFlyingStar: { en: 'Reception - Flying Star', km: 'ទទួលភ្ញៀវ - តារាហោះហើរ', zh: '前台 - 飞星' },
  inspectionReception8Mansions: { en: 'Reception - Eight Mansions', km: 'ទទួលភ្ញៀវ - ប្រាំបីផ្ទះ', zh: '前台 - 八宅' },
  inspectionReceptionAssessment: { en: 'Reception - Assessment', km: 'ទទួលភ្ញៀវ - ការវាយតម្លៃ', zh: '前台 - 评估' },
  inspectionOfficeSector: { en: 'Office/Manager - Sector', km: 'ការិយាល័យ/អ្នកគ្រប់គ្រង - ប្រាង្គ', zh: '办公室/经理 - 方位' },
  inspectionOfficeFlyingStar: { en: 'Office - Flying Star', km: 'ការិយាល័យ - តារាហោះហើរ', zh: '办公室 - 飞星' },
  inspectionOffice8Mansions: { en: 'Office - Eight Mansions', km: 'ការិយាល័យ - ប្រាំបីផ្ទះ', zh: '办公室 - 八宅' },
  inspectionOfficeAssessment: { en: 'Office - Assessment', km: 'ការិយាល័យ - ការវាយតម្លៃ', zh: '办公室 - 评估' },
  inspectionToiletSectorInternal: { en: 'Toilet/Bathroom - Sector', km: 'បន្ទប់ទឹក - ប្រាង្គ', zh: '厕所/浴室 - 方位' },
  inspectionToiletFlyingStar: { en: 'Toilet - Flying Star', km: 'បន្ទប់ទឹក - តារាហោះហើរ', zh: '厕所 - 飞星' },
  inspectionToilet8Mansions: { en: 'Toilet - Eight Mansions', km: 'បន្ទប់ទឹក - ប្រាំបីផ្ទះ', zh: '厕所 - 八宅' },
  inspectionToiletIssues: { en: 'Toilet Issues', km: 'បញ្ហាបន្ទប់ទឹក', zh: '厕所问题' },
  inspectionToiletAtCenter: { en: 'At center palace', km: 'នៅប្រាង្គកណ្តាល', zh: '位于中宫' },
  inspectionToiletAtWealth: { en: 'At wealth sector', km: 'នៅប្រាង្គទ្រព្យ', zh: '位于财位' },
  inspectionToiletNoIssues: { en: 'No issues', km: 'មិនមានបញ្ហា', zh: '无问题' },
  inspectionStaircaseSector: { en: 'Staircase/Elevator - Sector', km: 'ជណ្តើរគោល/ឡិច - ប្រាង្គ', zh: '楼梯/电梯 - 方位' },
  inspectionStaircaseFlyingStar: { en: 'Staircase - Flying Star', km: 'ជណ្តើរគោល - តារាហោះហើរ', zh: '楼梯 - 飞星' },
  inspectionStaircase8Mansions: { en: 'Staircase - Eight Mansions', km: 'ជណ្តើរគោល - ប្រាំបីផ្ទះ', zh: '楼梯 - 八宅' },
  inspectionStaircaseAssessment: { en: 'Staircase - Assessment', km: 'ជណ្តើរគោល - ការវាយតម្លៃ', zh: '楼梯 - 评估' },
  inspectionRoom1Sector: { en: 'Room 1 - Sector', km: 'បន្ទប់ ១ - ប្រាង្គ', zh: '房间 1 - 方位' },
  inspectionRoom1FlyingStar: { en: 'Room 1 - Flying Star', km: 'បន្ទប់ ១ - តារាហោះហើរ', zh: '房间 1 - 飞星' },
  inspectionRoom1EightMansions: { en: 'Room 1 - Eight Mansions', km: 'បន្ទប់ ១ - ប្រាំបីផ្ទះ', zh: '房间 1 - 八宅' },
  inspectionRoom2Sector: { en: 'Room 2 - Sector', km: 'បន្ទប់ ២ - ប្រាង្គ', zh: '房间 2 - 方位' },
  inspectionRoom3Sector: { en: 'Room 3 - Sector', km: 'បន្ទប់ ៣ - ប្រាង្គ', zh: '房间 3 - 方位' },
  inspectionBestSectorMainEntrance: { en: 'Sectors Best for - Main entrance', km: 'ប្រាង្គល្អបំផុត - ច្រកចូលចម្បង', zh: '最佳方位 - 主入口' },
  inspectionBestSectorCashier: { en: 'Sectors Best for - Cashier/finance', km: 'ប្រាង្គល្អបំផុត - ការិយាល័យទូរសារ/ហិរញ្ញវត្ថុ', zh: '最佳方位 - 收银/财务' },
  inspectionBestSectorManager: { en: 'Sectors Best for - Manager office', km: 'ប្រាង្គល្អបំផុត - ការិយាល័យអ្នកគ្រប់គ្រង', zh: '最佳方位 - 经理办公室' },
  inspectionBestSectorStorage: { en: 'Sectors Best for - Storage', km: 'ប្រាង្គល្អបំផុត - ឃ្លាំង', zh: '最佳方位 - 仓储' },
  inspectionQualityStrong: { en: 'Strong', km: 'ខ្លាំង', zh: '强' },
  inspectionQualityWeak: { en: 'Weak', km: 'ខ្សោយ', zh: '弱' },
  inspectionQualityConflicting: { en: 'Conflicting', km: 'ប្រឆាំង', zh: '冲突' },
  inspectionPdfTitle: { en: 'Site Inspection Report', km: 'របាយការណ៍ពិនិត្យទីតាំង', zh: '现场勘察报告' },
};

function toKhmerNum(n) {
  const kmNum = '០១២៣៤៥៦៧៨៩';
  return String(n)
    .split('')
    .map((d) => kmNum[Number(d)])
    .join('');
}

// Solar terms, lunar days, flying stars
for (let i = 0; i < solarEn.length; i++) {
  const key = `solarTerm${String(i + 1).padStart(2, '0')}`;
  const en = solarEn[i];
  patches[key] = { en, km: en, zh: en };
}
for (let i = 1; i <= 30; i++) {
  const key = `lunarDay${String(i).padStart(2, '0')}`;
  const en = ordinals[i - 1];
  patches[key] = {
    en,
    km: `ថ្ងៃទី ${toKhmerNum(i)}`,
    zh: `第${i}日`,
  };
}
for (let i = 1; i <= 9; i++) {
  const key = `flyingStar${i}`;
  patches[key] = {
    en: `Star ${i}`,
    km: `ផ្កាយ ${toKhmerNum(i)}`,
    zh: `${i}星`,
  };
}

const enArb = loadArb('app_en.arb');
const kmArb = loadArb('app_km.arb');
const zhArb = loadArb('app_zh.arb');

let added = 0;
for (const [key, vals] of Object.entries(patches)) {
  if (!(key in enArb)) {
    enArb[key] = vals.en;
    kmArb[key] = vals.km;
    zhArb[key] = vals.zh;
    added++;
  }
}

saveArb('app_en.arb', enArb);
saveArb('app_km.arb', kmArb);
saveArb('app_zh.arb', zhArb);
console.log(`Added ${added} inspection l10n keys to EN/KM/ZH ARB files`);
