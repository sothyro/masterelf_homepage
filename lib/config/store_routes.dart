import 'book_store_content.dart';

/// Fragment IDs for the Apps page digital sections.
const String kAppsMasterElfFragment = 'master-elf';
const String kAppsPeriod9Fragment = 'period9';

/// Legacy talisman fragment (redirects to /talisman).
const String kLegacyTalismanFragment = 'talisman';

/// Whether [uri] should scroll past the page hero to an in-page target.
bool routeRequestsSectionScroll(Uri uri) {
  var path = uri.path;
  if (path.endsWith('/') && path.length > 1) {
    path = path.substring(0, path.length - 1);
  }

  final fragment = uri.fragment;
  switch (path) {
    case '/apps':
      return fragment == kAppsPeriod9Fragment;
    case '/books':
      if (fragment.isEmpty || fragment == kBookStoreSectionFragment) {
        return false;
      }
      return kBlessingBookIds.contains(fragment) ||
          fragment == kBlessingBundleId ||
          kPeriod9BookIds.contains(fragment);
    case '/consultations':
      final service = uri.queryParameters['service']?.trim();
      return service != null && service.isNotEmpty;
    default:
      return false;
  }
}

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
