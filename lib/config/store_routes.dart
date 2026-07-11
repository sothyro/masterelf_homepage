import 'book_store_content.dart';

/// Fragment IDs for the Apps page digital sections.
const String kAppsMasterElfFragment = 'master-elf';
const String kAppsPeriod9Fragment = 'period9';

/// Legacy talisman fragment (redirects to /talisman).
const String kLegacyTalismanFragment = 'talisman';

/// Redirect target when /apps is visited with a book-related legacy fragment.
String? redirectLegacyAppsFragment(String fragment) {
  if (fragment.isEmpty) return null;
  if (fragment == kLegacyTalismanFragment) return '/talisman';
  if (fragment == kBookStoreSectionFragment ||
      kBlessingBookIds.contains(fragment) ||
      fragment == kBlessingBundleId ||
      kPeriod9BookIds.contains(fragment)) {
    return fragment == kBookStoreSectionFragment ? '/books' : '/books#$fragment';
  }
  return null;
}
