#!/usr/bin/env node
/**
 * Applies contextual Khmer translations to lib/l10n/app_km.arb
 * Run: node tools/apply_khmer_translations.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const arbPath = path.join(__dirname, '..', 'lib', 'l10n', 'app_km.arb');
const km = JSON.parse(fs.readFileSync(arbPath, 'utf8'));

/** @type {Record<string, string>} */
const patches = {
  // --- Apps & Store (Batch F) ---
  appsAndStore: 'កម្មវិធី និងហាង',
  period9MobileApp: 'កម្មវិធីយុគទី ៩ (Period 9)',
  appsPageTitle: 'កម្មវិធី ស្តេចយ័ន្ត និងសៀវភៅ',
  appsPageSubline: 'ឧបករណ៍ឌីជីថល សៀវភៅ និងស្តេចយ័ន្ត—ទិញបានក្នុងទីតាំងតែមួយ។',
  appsPageDescription:
    'ទីផ្សាររបស់យើងរួមបញ្ចូលការជាវ កម្មវិធី សៀវភៅ និងស្តេចយ័ន្តដែលជ្រើសរើស។ ជាវ ទាញយក ឬបន្ថែមទៅកន្ត្រក—យើងនឹងជួយអ្នកបញ្ចប់ការបញ្ជាទិញ។',
  appsPageDescriptionHighlight: 'ទីផ្សារ',
  appsFeatureShowcaseHeading: 'ទិញតាមប្រភេទ',
  appsFeatureShowcaseMarketingDesc:
    'រុករកការជាវឌីជីថល ការទិញម្តង និងផលិតផលដែលជ្រើសរើស។ បន្ថែមទៅកន្ត្រក ឬជាវ ហើយយើងនឹងទាក់ទងអ្នកដើម្បីបញ្ចប់ការបញ្ជាទិញ។',
  appsFeatureShowcaseMarketingHighlight: 'បន្ថែមទៅកន្ត្រក ឬជាវ',
  masterElfSystemSpotlightDesc:
    'វេទិកាប៉ាជឺ (BaZi) និងរូបវិទ្យាចិនបុរាណពេញលេញ។ គូរក្រាប វិភាគពេលវេលា និងចូលប្រើប្រព័ន្ធ Master Elf តាមអនឡាញ។',
  period9SpotlightTitle: 'កម្មវិធីយុគទី ៩ (Period 9)',
  period9SpotlightDesc:
    'យកចំណេះដឹងហុងស៊ុយ (Feng Shui) និងពេលវេលាយុគទី ៩ ទៅជាមួយអ្នក។ មានលើ iOS និង Android។',
  talismanStoreSpotlightDesc:
    'ស្តេចយ័ន្ត និងថ្នាំបន្ថយដែលជ្រើសរើស។ បន្ថែមទៅកន្ត្រក ហើយយើងនឹងទាក់ទងអ្នកដើម្បីបញ្ចប់ការបញ្ជាទិញ។',
  marketplaceAddedToCart: 'បានបន្ថែមទៅកន្ត្រកហើយ។ យើងនឹងទាក់ទងអ្នកដើម្បីបញ្ចប់ការបញ្ជាទិញ។',
  bookStoreAddToCart: 'បន្ថែមទៅកន្ត្រក',
  bookStoreAddedToCart: 'បានបន្ថែមទៅកន្ត្រកហើយ។ យើងនឹងទាក់ទងអ្នកដើម្បីបញ្ចប់ការបញ្ជាទិញ។',
  bookStoreSectionMarketing:
    'ស្វែងយល់ជ្រៅទៅក្នុងហុងស៊ុយ (Feng Shui) យុគទី ៩ (Period 9) និងរូបវិទ្យាចិនបុរាណ ជាមួយសៀវភៅដែលយើងជ្រើសរើស។ ល្អសម្រាប់អ្នកអនុវត្ត និងអ្នកចូលចិត្ត—ជាវឥឡូវ ហើយផ្លាស់ប្តូរការយល់ឃើញរបស់អ្នក។',
  bookStoreBook1Title: 'ហុងស៊ុយ (Feng Shui) យុគទី ៩ — ភាគ ១',
  bookStoreBook2Title: 'ហុងស៊ុយ (Feng Shui) យុគទី ៩ — ភាគ ២',
  appFeatureQiMen: 'ឈីមិនទុនជា (Qi Men Dunjia)',
  appFeatureBaziLife: 'ប៉ាជឺ (BaZi) ជីវិត',
  appFeatureBaziReport: 'របាយការណ៍ប៉ាជឺ (BaZi)',
  appFeatureBaziAge: 'អាយុប៉ាជឺ (BaZi)',
  appFeatureBaziStars: 'តារាប៉ាជឺ (BaZi)',
  appFeatureBaziKhmer: 'ប៉ាជឺ (BaZi) ខ្មែរ',
  appFeatureBaziChart: 'ក្រាបប៉ាជឺ (BaZi)',
  appFeatureDateSelection: 'ការជ្រើសរើសថ្ងៃ (Date Selection)',

  // --- Academy (Batch C) ---
  academyQiMen: 'ឈីមិនទុនជា (Qi Men Dunjia) Mastery™',
  academyQiMenDesc: 'ទទួលបានអត្ថប្រយោជន៍យុទ្ធសាស្ត្រ ដើម្បីបង្កើនភាពជោគជ័យរបស់អ្នក។ ផ្លូវទៅរកជ័យជម្នះរបស់អ្នក!',
  academyBaZi: 'ប៉ាជឺ (BaZi) Harmony™',
  academyBaZiDesc: 'បង្ហាញវាសនារបស់អ្នក និងអំណាចកំបាំង។ បង្កើនសក្តានុពលអតិបរមា។',
  academyFengShui: 'ហុងស៊ុយ (Feng Shui) Charter™',
  academyFengShuiDesc: 'ម៉ាស្ទ័រនៃលំហូរឈី (Qi)។ កំណត់ហុងស៊ុយល្អបំផុតសម្រាប់ផ្ទះ និងការិយាល័យរបស់អ្នក។',
  academyDateSelection: 'ការជ្រើសរើសថ្ងៃ (Date Selection)™',
  academyDateSelectionAbout:
    'ជ្រើសរើសថ្ងៃ និងម៉ោងហេងដោយប្រើប្រតិទិន ប៉ាជឺ (BaZi) និងឈីមិនទុនជា (Qi Men Dunjia)។ ប្រើសម្រាប់អាពាហ៍ពិពាហ៍ ការបើកដំណើរ ការធ្វើដំណើរ និងការសម្រេចចិត្តសំខាន់ៗ។',
  academyDateSelectionTopics: 'តុងស៊ូ (Tung Shu) • ម៉ោងហេង • ព្រឹត្តិការណ៍ និងហេតុសំខាន់ៗ',
  academyIChing: 'អ៊ីជីង (I Ching)™',
  academyIChingDesc: 'បញ្ញាបុរាណនៃសៀវភៅការផ្លាស់ប្តូរ សម្រាប់ភាពច្បាស់ និងទិសដៅ។',
  academyIChingAbout:
    'តម្រាអ៊ីជីង ៦៤ ផ្តល់នូវចម្លើយអំពីការផ្លាស់ប្តូរ និងលទ្ធផល។ រៀនពិគ្រោះអ៊ីជីង (I Ching) សម្រាប់ការសម្រេចចិត្ត យុទ្ធសាស្ត្រ និងការណែនាំផ្ទាល់ខ្លួន។',
  academyMaoShan: 'ម៉ៅសាន (Mao Shan)™',
  academyMaoShanAbout:
    'វិធីសាស្ត្រ និងពិធីការម៉ៅសាន (Mao Shan) ក្នុងរូបវិទ្យាចិនបុរាណ។ យល់ពីមូលដ្ឋាន និងការអនុវត្តសម្រាប់ប្រើប្រាស់ផ្លូវវិញ្ញាណ និងជាក់ស្តែង។',

  // --- Consultations (Batch C) ---
  consult1Category: 'ការអានប៉ាជឺ (BaZi)',
  consult1Method: 'ប៉ាជឺ (BaZi)',
  consult1Desc:
    'ក្រាបកំណើតរបស់អ្នកផ្ទុកគន្លឹះទៅរកចំណុចខ្លាំង ការប្រឈម និងពេលវេលា។ ការអានប៉ាជឺ (BaZi) បង្ហាញសក្តានុពលពិតរបស់អ្នក និងជួយអ្នកសម្របជម្រើសជាមួយថាមពលដែលអ្នកកើតមកជាមួយ—ដើម្បីឱ្យអ្នកសម្រេចចិត្តដោយច្បាស់ និងជឿជាក់។',
  consult2Category: 'សេវាហុងស៊ុយ (Feng Shui)',
  consult2Method: 'ហុងស៊ុយ (Feng Shui)',
  consult2Desc:
    'បរិស្ថានរបស់អ្នកកំណត់សុខភាព និងភាពជោគជ័យ។ យល់ពីរបៀបប្រើប្រាស់ថាមពលវិជ្ជមាននៃទីកន្លែង—នៅផ្ទះ ឬការងារ—ដើម្បីឱ្យជុំវិញគាំទ្រគោលដៅរបស់អ្នក ជំនួសឱ្យធ្វើប្រឆាំង។',
  consult3Category: 'ការជ្រើសរើសថ្ងៃ (Date Selection)',
  consult3Method: 'ស៊ួនកុង (Xuan Kong)',
  consult3Desc:
    'ការជ្រើសថ្ងៃ និងពេលវេលាត្រឹមត្រូវអាចប្តូរជំហានធម្មតាទៅជាជំហានហេង។ យើងប្រើវិធីបុរាណដើម្បីជួយអ្នកកំណត់ព្រឹត្តិការណ៍សំខាន់—ពីការបើកដំណើរ និងចុះហត្ថលេខា ដល់ហេតុសំខាន់ផ្ទាល់ខ្លួន—សម្រាប់លទ្ធផលល្អបំផុត។',
  consult4Category: 'ឈីមិនទុនជា (Qi Men Dunjia) និងអ៊ីជីង (I Ching)',
  consult4Method: 'ឈីមិនទុនជា (Qi Men Dunjia) និងអ៊ីជីង (I Ching)',
  consult4Desc:
    'ប្រឈមមុខនឹងការសម្រេចចិត្តស្មុយស្មាញជាមួយបញ្ញាបុរាណ។ ឈីមិនទុនជា (Qi Men Dunjia) និងអ៊ីជីង (I Ching) ផ្តល់នូវការយល់ដឹងយុទ្ធសាស្ត្រ និងភាពច្បាស់—ដើម្បីឱ្យអ្នកឃើញជម្រើសច្បាស់ ព្យាករណ៍លទ្ធផល និងជ្រើសជំហានដែលសមនឹងគោលដៅរបស់អ្នក។',
  consult5Category: 'ពិធីការម៉ៅសាន (Mao Shan)',
  consult5Method: 'ម៉ៅសាន (Mao Shan)',
  consult5Desc:
    'ម៉ៅសាន (Mao Shan) រួមបញ្ចូលពិធីការតាវ និងការអនុវត្តរូបវិទ្យាចិន។ សម្រាប់ការលូតលាស់ផ្លូវវិញ្ញាណ ឬរយៈពេលផ្លាស់ប្តូរជីវិត វិធីសាស្ត្រទាំងនេះផ្តល់ផ្លូវរចនាសម្ព័ន្ធទៅការផ្លាស់ប្តូរ និងការភ្ជាប់ជ្រៅជាងជាមួយប្រពៃណី។',
  consult6Desc:
    'ស្វែងយល់ជ្រៅទៅក្នុងស្នាដៃដែល Master Elf បោះពុម្ភផ្សាយអំពីហុងស៊ុយ (Feng Shui) ប៉ាជឺ (BaZi) និងរូបវិទ្យាចិនបុរាណ។ សៀវភៅ និងធនធានរបស់យើងរចនាដើម្បីគាំទ្រការរៀន និងអនុវត្តរបស់អ្នកក្រៅពីបន្ទប់ពិគ្រោះ។',

  // --- Method pages (Batch C/G) ---
  methodBaZiTitle: 'ប៉ាជឺ (BaZi) — សសរបួននៃវាសនា',
  methodQimenTitle: 'ឈីមិនទុនជា (Qi Men Dunjia)',
  methodQimenBody:
    'ឈីមិនទុនជា (Qi Men Dunjia) សាងសង់លើក្រឡា ៣×៣ ប្រាង្គប្រាំបួនដែលផ្លាស់ប្តូរជាមួយកាលបរិច្ឆេទ និងម៉ោងទ្វេ។ យើងកំណត់ក្រាហ្វសម្រាប់ពេលវេលាសំណួរ ឬព្រឹត្តិការណ៍ ដាក់ផ្កាយបីអវធម៌ (អ៊ី ប៊ីង ឌីង) ច្រកប្រាំបួន និងទេវតាប្រាំបួន ហើយបកស្រាយដោយប្រើយិន ឬយ៉ាងទុនជា។ រូបមន្តរស្មីពេលវេលា និងប្រើសម្រាប់យុទ្ធសាស្ត្រ ការជ្រើសរើសថ្ងៃ និងការវិភាគស្ថានភាព។',
  methodIChingTitle: 'អ៊ីជីង (I Ching) — សៀវភៅការផ្លាស់ប្តូរ',
  methodIChingBody:
    'អ៊ីជីង (I Ching) ត្រូវបានពិគ្រោះដើម្បីទទួលហិកសាក្រាម (ប្រាំមួយបន្ទាត់) ដែលឆ្លុះបញ្ចាំងស្ថានភាព។ យើងប្រើវិធីកាក់បី ឬដើមយ៉ារ៉ូបុរាណ៖ រៀងរាល់បន្ទាត់ត្រូវបានសាងពីក្រោមឡើងលើ (៦ = យិនផ្លាស់ប្តូរ, ៧ = យ៉ាងថ្លៃ, ៨ = យិនថ្លៃ, ៩ = យ៉ាងផ្លាស់ប្តូរ)។ ហិកសាក្រាមលទ្ធផល និងបន្ទាត់ផ្លាស់ប្តូរណាមួយត្រូវបានបកស្រាយដោយប្រើអត្ថបទបុរាណ និងគោលការណ៍របស់ Master Elf។',
  methodDateSelectionTitle: 'ការជ្រើសរើសថ្ងៃ (Date Selection)',
  methodDateSelectionBody:
    'ថ្ងៃ និងម៉ោងហេងត្រូវបានជ្រើសរើសដោយប្រើប្រតិទិនចិន (តុងស៊ូ) ភាពឆបគ្នាប៉ាជឺ (BaZi) ជាមួយព្រឹត្តិការណ៍ និងអ្នកគ្រប់គ្រង និងឈីមិនទុនជា (Qi Men Dunjia) សម្រាប់ពេលវេលាយុទ្ធសាស្ត្រ។ យើងជៀសវាងថ្ងៃអាក្រក់ និងសម្របជាមួយថាមពលអំណោយផលសម្រាប់ការបើកដំណើរ អាពាហ៍ពិពាហ៍ ការធ្វើដំណើរ និងការប្តេជ្ញាសំខាន់ៗ។',
  methodFengShuiTitle: 'ហុងស៊ុយ (Feng Shui) — តារាហោះហើរស៊ួនកុង (Xuan Kong)',
  methodFengShuiBody:
    'យើងប្រើហុងស៊ុយ (Feng Shui) តារាហោះហើរស៊ួនកុង (Xuan Kong Fei Xing)។ រយៈកាលអាគារ (ផ្អែកលើឆ្នាំបញ្ចប់; ឆ្នាំហុងស៊ុយចាប់ផ្តើម ៤ កុម្ភៈ) និងទិសដៅមុខ (២៤ ភ្នំ) កំណត់ក្រាហ្វតារាហោះហើរ។ ប្រាង្គប្រាំបួនទទួលផ្កាយដែលរួមបញ្ចូលជាមួយប្លង់ Lo Shu។ យើងវាយតម្លៃផ្កាយភ្នំ និងទឹក តុល្យភាពធាតុ និងការកែតម្រូវយុគទី ៩ ដើម្បីណែនាំការដាក់ និងថ្នាំបន្ថយ។',
  methodMaoShanTitle: 'ម៉ៅសាន (Mao Shan)',
  methodMaoShanBody:
    'បែបបទម៉ៅសាន (Mao Shan) ត្រូវបានរួមបញ្ចូលកន្លែងដែលសមរម្យសម្រាប់ពិធីការ និងការអនុវត្តក្នុងប្រព័ន្ធ Master Elf។ វិធីសាស្ត្រត្រូវបានអនុវត្តដោយគោរពទម្រង់ និងគោលបំណងបុរាណ គាំទ្រទាំងវិមាត្រខាងព្រលឹង និងជាក់ស្តែងនៃរូបវិទ្យាចិន។',

  // --- Popup / events ---
  popupDescription: 'ឆ្នាំសេះភ្លើង ២០២៦',
  eventsWhyAttend3: 'កៅអីមានកំណត់។ ណាត់កៅអីរបស់អ្នក និងចូលរួមព្រឹត្តិការណ៍ពិសេស!',
  eventsUpcomingSubline: 'ជ្រើសរើសព្រឹត្តិការណ៍របស់អ្នក និងណាត់កៅអីរបស់អ្នក។ យើងនឹងរង់ចាំជួបអ្នក។',
  secureYourSeat: 'ណាត់កៅអីរបស់អ្នក',
  eventRegEmail: 'អ៊ីមែល',
  eventRegSuccessNote: 'យើងនឹងបញ្ជាក់កៅអីរបស់អ្នកតាមអ៊ីមែល ឬទូរស័ព្ទ។ ជួបគ្នានៅព្រឹត្តិការណ៍!',

  // --- Contact (Batch D) ---
  contactFormEmail: 'អ៊ីមែល',
  contactError: 'មានបញ្ហាកើតឡើង។ សូមព្យាយាមម្តងទៀត ឬផ្ញើអ៊ីមែលយើងដោយផ្ទាល់។',
  contactSubjectDestiny: 'វាសនា / ការអានផ្ទាល់ខ្លួន (ប៉ាជឺ BaZi)',
  contactSubjectBusiness: 'ការរៀបចំអាជីវកម្ម និងយុទ្ធសាស្ត្រ (ឈីមិនទុនជា Qi Men / ជ្រើសថ្ងៃអាជីវកម្ម)',
  contactSubjectFengShui: 'ហុងស៊ុយ (Feng Shui) — ការសម្របផ្ទះ / ការិយាល័យ',
  contactSubjectDateSelection: 'ការជ្រើសរើសថ្ងៃ (Date Selection) — ព័ត៌មានបណ្តុះបណ្តល់',

  // --- Booking flow (Batch B) — unify ណាត់ជួប ---
  stepGuideYourDetails: 'បំពេញឈ្មោះ និងលេខទូរស័ព្ទរបស់អ្នក ដើម្បីឱ្យយើងអាចបញ្ជាក់ការណាត់ជួបរបស់អ្នក។',
  stepGuideConfirm: 'ពិនិត្យការណាត់ជួបរបស់អ្នក និងបញ្ជាក់ដើម្បីទទួល SMS។',
  confirmAndBook: 'បញ្ជាក់ និងណាត់ជួប',
  bookingSuccessTitle: 'បានបញ្ជាក់ការណាត់ជួប',
  bookingSuccessMessage: 'ការពិគ្រោះរបស់អ្នកត្រូវបានណាត់ហើយ។',
  bookAnother: 'ណាត់ជួបមួយទៀត',
  viewYourBookings: 'មើលការណាត់ជួបរបស់អ្នក',
  viewYourBookingsIntro: 'បញ្ចូលលេខទូរស័ព្ទដើម្បីមើលការណាត់ជួបឡើងវិញ និងកន្លងមក។',
  findMyBookings: 'រកការណាត់ជួបរបស់ខ្ញុំ',
  noBookingsFound: 'រកមិនឃើញការណាត់ជួបសម្រាប់លេខនេះទេ។',
  cancelBookingConfirm: 'បោះបង់ការណាត់ជួបនេះ?',
  bookingCancelled: 'បានបោះបង់ការណាត់ជួប។',
  loginSectionIntro: 'ចូលដើម្បីចូលប្រើផ្ទាំងគ្រប់គ្រងការណាត់ជួប និងគ្រប់គ្រងការណាត់ជួបទាំងអស់។',
  dashboardSubtitle: 'មើល និងគ្រប់គ្រងការណាត់ជួបទាំងអស់',
  createBooking: 'បង្កើតការណាត់ជួប',
  createBookingFor: 'បង្កើតការណាត់ជួបជូនអតិថិជន',
  bookingCreated: 'ការណាត់ជួបបានបង្កើតដោយជោគជ័យ។',
  errorCreatingBooking: 'បង្កើតការណាត់ជួបមិនបាន។',
  addBooking: 'បន្ថែមការណាត់ជួប',
  noteHint: 'កំណត់សម្គាល់ជម្រើសអំពីការណាត់ជួបនេះ…',
  slotsEstimateWarning:
    'បង្ហាញពេលប៉ាន់ស្មាន — មិនអាចទាញយកពេលវេលាជាក់ស្តែងបានទេ។ សូមបញ្ជាក់ជាមួយយើងបន្ទាប់ពីណាត់ជួប។',
  slotsFetchFailed:
    'មិនអាចភ្ជាប់ទៅម៉ាស៊ីនមេកក់បានទេ។ ពេលវេលាដែលបង្ហាញគឺជាការប៉ាន់ស្មាន — សូមបញ្ជាក់ជាមួយយើងបន្ទាប់ពីណាត់ជួប។',

  // --- Auth / validation (Batch A) ---
  loginEmail: 'អ៊ីមែល',
  loginError: 'អ៊ីមែល ឬលេខសម្ងាត់មិនត្រឹមត្រូវ។',
  errorUserNotFound: 'រកមិនឃើញគណនីជាមួយអ៊ីមែលនេះទេ។',
  errorEmailInUse: 'អ៊ីមែលនេះបានចុះឈ្មោះរួចហើយ។',
  errorInvalidEmail: 'អាសយដ្ឋានអ៊ីមែលមិនត្រឹមត្រូវ។',
  validationEmailRequired: 'ត្រូវការអ៊ីមែល',
  validationEmailInvalid: 'សូមបញ្ចូលអាសយដ្ឋានអ៊ីមែលដែលត្រឹមត្រូវ',
  tooltipEmail: 'អ៊ីមែល',

  // --- Journey / marketing (Batch E) ---
  journeyPeriod9Title: 'យុគទី ៩ (Period 9) និងយុគសម័យថ្មី',
  journeyPeriod9Body:
    'យើងឥឡូវនៅយុគទី ៩ (Period 9) (២០២៤–២០៤៣) យុគភ្លើង Li ក្នុងវដ្តរយៈកាលប្រាំបួនស៊ួនកុង (Xuan Kong)។ ដំណាក់កាល ២០ ឆ្នាំនេះផ្តោតលើថាមពលធាតុភ្លើង ទិសខាងត្បូង និងចំណុចភាពឃើញ ការរីកចម្រើន និងភាពច្បាស់ខាងក្នុង។',
  journeyPhoenixBody:
    'ការកើនឡើងរបស់មយូរ៉ា គឺជាការបង្ហាញរបស់ Master Elf និងឈ្មោះប្រព័ន្ធរបស់គាត់។ វាសម្គាល់ការធ្វើឱ្យបរិសុទ្ធ ការផ្លាស់ប្តូរ និងពេលវេលាដែលការយល់ដឹងនាំទៅរកសកម្មភាព។ ក្នុងយុគទី ៩ ភ្និកស័រកើនឡើង—ហើយជាមួយចំណេះដឹងត្រឹមត្រូវ អ្នកក៏អាចធ្វើបានដែរ។ គោលការណ៍របស់គាត់រួមបញ្ចូលប៉ាជឺ (BaZi) ឈីមិនទុនជា (Qi Men Dunjia) អ៊ីជីង (I Ching) ការជ្រើសរើសថ្ងៃ (Date Selection) ហុងស៊ុយ (Feng Shui) និងម៉ៅសាន (Mao Shan) ជាវិធីសាស្ត្រជាប់លាប់សម្រាប់អ្នកដែលត្រៀមរួចកើនឡើង។',
  heroSubline: 'សេវាហុងស៊ុយ (Feng Shui) និងរៀបចំជីវិត',
  eventsDescription:
    'ជួបបទពិសោធហុងស៊ុយ (Feng Shui) រូបវិទ្យាចិនបុរាណ និងហាស្ត្រូឡូហ្គីដែលល្អបំផុតនៅកម្ពុជា—ការបង្រៀនផ្ទាល់ ការយល់ដឹងអ្នកជំនាញ និងសហគមន៍ត្រៀមរួចរីកចម្រើនជាមួយអ្នក។',
  eventsDescriptionHighlight: 'ព្រឹត្តិការណ៍ហុងស៊ុយ (Feng Shui) រូបវិទ្យាចិនបុរាណ និងហាស្ត្រូឡូហ្គី ដ៏ល្អបំផុតនៅកម្ពុជា',

  // --- Inspection (Batch F) ---
  inspectionSection9: 'ផ្នែក ៩៖ តារាហោះហើរស៊ួនកុង (Xuan Kong Flying Star)',
  inspectionSection10: 'ផ្នែក ១០៖ ការវិភាគប្រាំបីផ្ទះ (Eight Mansions)',
  inspectionSection11: 'ផ្នែក ១១៖ ប៉ាជឺ (BaZi) អតិថិជន និងអ្នករស់',
  inspectionSection12: 'ផ្នែក ១២៖ ឈីមិនទុនជា (Qi Men Dun Jia) ជ្រើសរើសថ្ងៃ',
  inspectionNoiseNightclub: 'ក្លឹបរាត្រី/កន្លែងកម្សាន្ត',
  inspectionMajorHighways: 'ផ្លូវហោវយូរសំខាន់',
  inspectionBridgesDirection: 'ស្ពាន/ផ្លូវហោវយូ — ទិស',
  inspectionShaBridge: 'ស្ពាន/ផ្លូវហោវយូ កាត់រូប',
  inspectionShaHighway: 'ផ្លូវហោវយូខ្ពស់ ឬ MRT ធ្វើឱ្យរំខាន/សម្ពាធ',

  // --- Book store / events (Batch A–D) ---
  appTitle: 'Master Elf ហុងស៊ុយ (Feng Shui)',
  bookStoreBook1Title: 'ហុងស៊ុយ (Feng Shui) ទំនើប',
  bookStoreBook2Title: 'ឈីមិនទុនជា (Qi Men Dun Jia) អនុវត្ត',
  bookStoreBook3Title: 'អ៊ីជីង (I Ching) យុទ្ធសាស្ត្រ',
  bookStoreBook4Title: 'ផ្លូវម៉ៅសាន (Mao Shan)',
  earlyBirdEnds: 'តម្លៃបញ្ចុះតម្លៃដំណើរការដំបូង',
  eventsGoat2027Title: 'Master Elf — ខិតខំសម្រាប់ឆ្នាំពពែភ្លើង ២០២៧',
  eventsZodiacStripPhoenix: 'មយូរ៉ា ២០២៦',
  eventsZodiacStripGoat: 'ពពែភ្លើង ២០២៧',
  event1Title: 'Master Elf - ការកើនឡើងរបស់មយូរ៉ា ២០២៦',
  event2Location: 'Resorts World Sentosa សិង្ហបុរី',
  event3Location: 'Resorts World សិង្ហបុរី',
  event4Title: 'ថ្នាក់ជ្រើសរើសថ្ងៃ (Date Selection Masterclass)',
  tooltipWhatsApp: 'WhatsApp',
  tooltipFacebook: 'Facebook',
  tooltipInstagram: 'Instagram',
  tooltipTikTok: 'TikTok',
  tooltipTelegram: 'Telegram',
};

// Global replacements
function globalReplace(s) {
  return s
    .replace(/អ៉ីមែល/g, 'អ៊ីមែល')
    .replace(/រទេះ/g, 'កន្ត្រក')
    .replace(/មិះ/g, 'មួយ');
}

let applied = 0;
for (const [key, value] of Object.entries(patches)) {
  if (key in km) {
    km[key] = value;
    applied++;
  } else {
    console.warn('Missing key in arb:', key);
  }
}

for (const key of Object.keys(km)) {
  if (key.startsWith('@') || key === '@@locale') continue;
  if (typeof km[key] === 'string') {
    const next = globalReplace(km[key]);
    if (next !== km[key]) {
      km[key] = next;
      applied++;
    }
  }
}

fs.writeFileSync(arbPath, JSON.stringify(km, null, 2) + '\n', 'utf8');
console.log(`Applied ${applied} updates to ${arbPath}`);
