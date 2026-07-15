import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/utils/carousel_row_preloader.dart';

void main() {
  setUp(CarouselRowPreloader.resetForTesting);

  test('preloadRow deduplicates paths', () async {
    const paths = [
      'assets/images/testimonials/sokha.png',
      'assets/images/testimonials/hena.png',
    ];
    await CarouselRowPreloader.preloadRow(
      ownerKey: 'test',
      paths: paths,
      cardsPerPage: 2,
    );
    expect(CarouselRowPreloader.loadedPathCount, 2);
    await CarouselRowPreloader.preloadRow(
      ownerKey: 'test',
      paths: paths,
      cardsPerPage: 2,
    );
    expect(CarouselRowPreloader.loadedPathCount, 2);
  });

  test('cancel prevents further loads from stale generation', () async {
    CarouselRowPreloader.cancel('test');
    await CarouselRowPreloader.preloadRow(
      ownerKey: 'test',
      paths: const ['assets/images/testimonials/sokha.png'],
      cardsPerPage: 1,
    );
    expect(CarouselRowPreloader.loadedPathCount, 1);
  });

  test('preloadNextRow loads only one row slice', () async {
    final paths = List<String>.generate(
      6,
      (i) => 'assets/images/testimonials/t$i.png',
    );
    await CarouselRowPreloader.preloadNextRow(
      ownerKey: 'rows',
      allPaths: paths,
      rowIndex: 1,
      cardsPerPage: 2,
    );
    expect(CarouselRowPreloader.loadedPathCount, 2);
  });
}
