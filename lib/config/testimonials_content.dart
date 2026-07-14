import 'app_content.dart';

/// Client voice card shown in [TestimonialsSection].
class TestimonialItem {
  const TestimonialItem({
    required this.quote,
    required this.name,
    required this.location,
    this.imagePath,
    this.imageTopInset = 0,
  });

  final String quote;
  final String name;
  final String location;

  /// Portrait image. Falls back to profile/participant alternates when null.
  final String? imagePath;

  /// Pushes the portrait down inside the image frame (pixels from card top).
  final double imageTopInset;

  bool get isBlank => quote == '—' && name == '—' && location == '—';
}

/// Curated testimonials for the homepage carousel (display-trimmed, voice preserved).
List<TestimonialItem> buildCuratedTestimonials() => const [
  TestimonialItem(
    quote:
        'អរគុណលោកគ្រូ បើកមុខឲ្យខ្ញុំលក់ដីដាច់! ខ្ញុំលែងលំបាកហើយ',
    name: 'Sieng Vanna',
    location: 'Kandal',
    imagePath: AppContent.assetTestimonialVanna,
  ),
  TestimonialItem(
    quote:
        'ពេលបានអានសំណេរលោកគ្រូរួចធូរចិត្តច្រើន លោកគ្រូពិតជាពូកែខ្លាំងមែនទែន តាមដានតាំងពីដើមដល់ឥឡូវ',
    name: 'Phart Sanit',
    location: 'Siem Reap, Cambodia',
    imagePath: AppContent.assetTestimonial8,
  ),
  TestimonialItem(
    quote:
        'អោយតែឃើញផុសលោកគ្រូ ភាពតានតឹងបាត់អស់ — អរគុណលោកគ្រូ',
    name: 'Sreylin Khan',
    location: 'Siem Reap, Cambodia',
    imagePath: AppContent.assetTestimonial10,
  ),
  TestimonialItem(
    quote:
        'ចាំតែអានការវិភាគរបស់លោកគ្រូ អានលើកណាក៏ជក់ចិត្តដែរ',
    name: 'Juary Mith',
    location: 'Phnom Penh, Cambodia',
    imagePath: AppContent.assetTestimonial11,
  ),
  TestimonialItem(
    quote:
        'Thank you Master, for sharing the most powerful Qi Men Dun Jia strategy.',
    name: 'Suon Mardy',
    location: 'Phnom Penh, Cambodia',
    imagePath: AppContent.assetTestimonial18,
  ),
  TestimonialItem(
    quote:
        'តាមដានលោកគ្រូហុងស៊ុយហើយក្លាយជាការពិត — ទាំងអស់សប្បាយចិត្ត',
    name: 'Taa',
    location: 'Phnom Penh, Cambodia',
    imagePath: AppContent.assetTestimonial13,
  ),
  TestimonialItem(
    quote:
        'ខ្ញុំជឿជាក់លើលោកគ្រូ លោកគ្រូមិះក់មិនដែលខុសទេ',
    name: 'Mo Ly',
    location: 'Phnom Penh, Cambodia',
    imagePath: AppContent.assetTestimonial15,
  ),
  TestimonialItem(
    quote:
        'អរគុណលោកគ្រូណាស់ — always by my side. Lucky to know you, Master. អាចថាជាអំណោយធំបំផុតក្នុងជីវិត 🙏',
    name: 'Ya Nara',
    location: 'Takhmao, Cambodia',
    imagePath: AppContent.assetTestimonial7,
  ),
  TestimonialItem(
    quote:
        'កូនសិស្សមានកត្តិយសណាស់ បានចូលរួមកម្មវិធីម្សិលមិញ។\nសង្ឃឹមថាបានស្គាល់លោកគ្រូ នឹងបានកែប្រែវាសនា 🙏',
    name: 'Panha Leakhena',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialPanhaLeakhena,
  ),
  TestimonialItem(
    quote:
        'ខ្ញុំតាមដានផុសលោកគ្រូរហូតពិតជាឆុតមែន',
    name: 'Mey In',
    location: 'Siem Reap, Cambodia',
    imagePath: AppContent.assetTestimonial16,
  ),
  // hena — Qi Men fire-element strategy (Cambodia / Vietnam)
  TestimonialItem(
    quote:
        'អរគុណ លោកគ្រូ Thank you for your advise and strategy... I will use the fire element as a weapon. Thank you Master 🙏',
    name: 'Leak Hena (Hena Gaming)',
    location: 'Cambodia · Vietnam',
    imagePath: AppContent.assetTestimonialHena,
  ),
  // sokha — house blessing ceremony (Borei Peng Hout, Phnom Penh)
  TestimonialItem(
    quote:
        'I got my houses blessed with proper ceremony. I wish to live in happiness. Good that we have master — we spent the whole morning for this event, but worth it.',
    name: 'Sokha',
    location: 'Borei Peng Hout, Phnom Penh',
    imagePath: AppContent.assetTestimonialSokha,
  ),
  // pisey — destiny connection abroad (Preah Sihanouk)
  TestimonialItem(
    quote:
        'The love of my life is abroad. Meeting him is a destiny. Thanks — សូមឲ្យជោគជ័យក្នុងជីវិត!',
    name: 'Mey Kesorpisey',
    location: 'Preah Sihanouk',
    imagePath: AppContent.assetTestimonialPisey,
  ),
  // aiichen — Period 9 business / AI fire element (Phnom Penh)
  TestimonialItem(
    quote:
        'New business in period 9 is a different game. AI and technology are the fire element. We need to be proactive and align with the changes.',
    name: 'Aii Chen',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialAiichen,
  ),
  // hengyang — house warming & blessing (Phnom Penh)
  TestimonialItem(
    quote:
        'Thanks master for house warming and blessing. Feeling bliss. 🙏',
    name: 'Heng Yang',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialHengyang,
  ),
  // chanra — way forward after Master’s guidance (Phnom Penh)
  TestimonialItem(
    quote:
        'ជូនពរហេហេង លោកគ្រូ! I know the way forward now. May I be blessed. 🙏',
    name: 'Prom Chanra',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialChanra,
  ),
  // moon — event night thanksgiving (Preah Sihanouk)
  TestimonialItem(
    quote:
        'អរគុណលោកគ្រូ — សិស្សបានចូលរួមកម្មវិធីកាលយប់។ សង្ឃឹមថាការទទួលការណែនាំនឹងប្តូរផ្លូវជីវិត។ 🙏',
    name: 'Moon Pichnil',
    location: 'Preah Sihanouk',
    imagePath: AppContent.assetTestimonialMoon,
  ),
  // rithy — reunion gifts & gratitude (International)
  TestimonialItem(
    quote:
        'សូមគោរពអរគុណលោកគ្រូ ដែលចែកកាដូរពិសេសក្នុងថ្ងៃជួបជុំ — ពរពីលោកគ្រូ ក្រដាស់ចិត្តពិត។ 🙏',
    name: 'Sereyrath Aumrith',
    location: 'International',
    imagePath: AppContent.assetTestimonialRithy,
  ),
  // thida — Cai Shen / wealth blessing
  TestimonialItem(
    quote:
        'Caishen awakens with Master Elf — when timing and strategy align, wealth has a clear path. 🙏',
    name: 'Phum Thida',
    location: 'Cambodia',
    imagePath: AppContent.assetTestimonialThida,
  ),
  // zeiitey — devotion & gratitude
  TestimonialItem(
    quote:
        'Master Elf changed how I see my path. Grateful beyond words — thank you, Master. 🙏',
    name: 'Zeii Tey',
    location: 'Cambodia',
    imagePath: AppContent.assetTestimonialZeiitey,
  ),
  // 9 — Ah Pich, follows closely (Poipet)
  TestimonialItem(
    quote:
        'តាមដានលោកគ្រូច្បាស់ៗម៉ង — រៀងរាល់ផុសគឺជាទិសដៅដែលខ្ញុំត្រូវទៅ។',
    name: 'Ah Pich',
    location: 'Poipet, Cambodia',
    imagePath: AppContent.assetTestimonial9,
  ),
  // 12 — Veth Raksmey, warmth from Master’s posts (Phnom Penh)
  TestimonialItem(
    quote:
        'I love to read Master’s posts — ពេលលោកគ្រូមិះ មានអារម្មណ៍កក់ក្ដៅ ហើយច្បាស់ផ្លូវ។',
    name: 'Veth Raksmey',
    location: 'Phnom Penh, Cambodia',
    imagePath: AppContent.assetTestimonial12,
  ),
  // 14 — Da Na, accuracy of Master’s forecasts (Phnom Penh)
  TestimonialItem(
    quote:
        'តាមដានលោកគ្រូគ្រប់ផុស — មិះមិនដែលខុសទេ។ ទំនុកចិត្តពិតៗ។',
    name: 'Da Na',
    location: 'Phnom Penh, Cambodia',
    imagePath: AppContent.assetTestimonial14,
  ),
  // 17 — Chantrea Smile, words that go viral (Tbong Khmoum)
  TestimonialItem(
    quote:
        'Master Elf និយាយបាន ១ ថ្ងៃ — ផ្ទុះពេញ Facebook។ ពាក្យពិតមានថាមពល។',
    name: 'Chantrea Smile',
    location: 'Tbong Khmoum, Cambodia',
    imagePath: AppContent.assetTestimonial17,
  ),
  // deth — BaZi reading readiness (Phnom Penh)
  TestimonialItem(
    quote: 'Thank you master for Bazi reading. I am ready. 🙏',
    name: 'Mss Deth',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialDeth,
  ),
  // linger — house Qi uplift & auspicious timing for child (Phnom Penh)
  TestimonialItem(
    quote:
        'សូមអរគុណណាស់ លោកគ្រូដែលបានលើករាសីផ្ទះ និងរៀបចំវេលាល្អជូនកូនខ្ញុំ — Thank you 🙏',
    name: 'Ling Err',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialLinger,
  ),
  // ounnpovv — path to repay debt (Phnom Penh)
  TestimonialItem(
    quote:
        'អរគុណលោកគ្រូ ដែលបង្ហាញផ្លូវ ឲ្យគេសងបំណុល — ហេងហេង. 🙏',
    name: 'Ounn Povv',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialOunnpovv,
  ),
  // muysorng — gratitude to Master (Phnom Penh)
  TestimonialItem(
    quote: 'អរគុណលោកគ្រូ — សូមអរគុណ. 🙏',
    name: 'Seng Muysorng',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialMuysorng,
  ),
  // sokunna — business path guidance (Banteay Meanchey)
  TestimonialItem(
    quote:
        'អរគុណលោកគ្រូ ជួយបង្ហាញផ្លូវសម្រាក់ការរកសុី — Thank you master. 🙏',
    name: 'Sokunna ដេប៉ូសែនសុខ',
    location: 'បន្ទាយមានជ័យ',
    imagePath: AppContent.assetTestimonialSokunna,
  ),
  // saly — Bazi reading (Phnom Penh)
  TestimonialItem(
    quote: 'Love the Bazi reading. — Thank you. 🙏',
    name: 'Prasoeu Saly',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialSaly,
  ),
  // rina — Bazi reading for love of life (Phnom Penh)
  TestimonialItem(
    quote: 'I done the Bazi reading for love of life. 🙏',
    name: 'Sodarina',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialRina,
  ),
  // chung — business and life Bazi reading (Phnom Penh)
  TestimonialItem(
    quote: 'Business and life reading through Bazi — Thank you.',
    name: 'Mr. Chung',
    location: 'Phnom Penh',
    imagePath: AppContent.assetTestimonialChung,
  ),
];

/// Portrait assets for below-fold homepage preload.
List<String> testimonialImageAssetsForPreload() => [
  AppContent.assetTestimonialProfile,
  AppContent.assetTestimonialParticipant,
  for (final item in buildCuratedTestimonials())
    if (item.imagePath != null) item.imagePath!,
];
