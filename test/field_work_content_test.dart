import 'package:flutter_test/flutter_test.dart';

import 'package:masterelf_homepage/config/field_work_content.dart';

void main() {
  group('getFieldWorkPosts', () {
    test('returns all posts sorted newest first', () {
      final posts = getFieldWorkPosts();
      expect(posts.length, kFieldWorkPosts.length);
      for (var i = 0; i < posts.length - 1; i++) {
        expect(
          posts[i].date.isAfter(posts[i + 1].date) ||
              posts[i].date.isAtSameMomentAs(posts[i + 1].date),
          isTrue,
        );
      }
    });

    test('filters by office realm', () {
      final posts = getFieldWorkPosts(realm: FieldWorkRealm.office);
      expect(posts, isNotEmpty);
      expect(posts.every((p) => p.realm == FieldWorkRealm.office), isTrue);
    });

    test('filters by ritual realm', () {
      final posts = getFieldWorkPosts(realm: FieldWorkRealm.ritual);
      expect(posts, isNotEmpty);
      expect(posts.every((p) => p.realm == FieldWorkRealm.ritual), isTrue);
    });

    test('filters by site realm', () {
      final posts = getFieldWorkPosts(realm: FieldWorkRealm.site);
      expect(posts, isNotEmpty);
      expect(posts.every((p) => p.realm == FieldWorkRealm.site), isTrue);
    });

    test('videosOnly returns empty when no video posts', () {
      final posts = getFieldWorkPosts(videosOnly: true);
      expect(posts.every((p) => p.hasVideo), isTrue);
    });
  });

  group('FieldWorkRealm.fromQuery', () {
    test('parses realm query values', () {
      expect(FieldWorkRealm.fromQuery('office'), FieldWorkRealm.office);
      expect(FieldWorkRealm.fromQuery('ritual'), FieldWorkRealm.ritual);
      expect(FieldWorkRealm.fromQuery('site'), FieldWorkRealm.site);
      expect(FieldWorkRealm.fromQuery('all'), isNull);
      expect(FieldWorkRealm.fromQuery(null), isNull);
      expect(FieldWorkRealm.fromQuery('unknown'), isNull);
    });
  });

  group('getFieldWorkPostBySlug', () {
    test('finds post by slug', () {
      final post = getFieldWorkPostBySlug('feng-shui-shophouse-audit-phnom-penh');
      expect(post, isNotNull);
      expect(post!.featured, isTrue);
    });

    test('returns null for unknown slug', () {
      expect(getFieldWorkPostBySlug('does-not-exist'), isNull);
    });
  });

  group('getHomeFieldWorkPosts', () {
    test('returns up to six cards across realms', () {
      final cards = getHomeFieldWorkPosts();
      expect(cards.length, lessThanOrEqualTo(6));
      expect(cards, isNotEmpty);
    });
  });
}
