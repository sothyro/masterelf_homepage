import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mobile_web_performance.dart';

/// Row-scoped carousel image warm-up: one visible row at a time, with optional
/// lookahead for auto-loop prefetch.
class CarouselRowPreloader {
  CarouselRowPreloader._();

  static final Map<String, int> _ownerGeneration = {};
  static final Set<String> _loadedPaths = {};

  @visibleForTesting
  static void resetForTesting() {
    _ownerGeneration.clear();
    _loadedPaths.clear();
  }

  @visibleForTesting
  static int get loadedPathCount => _loadedPaths.length;

  /// Cancels in-flight work for [ownerKey] (e.g. when section leaves viewport).
  static void cancel(String ownerKey) {
    _ownerGeneration[ownerKey] = (_ownerGeneration[ownerKey] ?? 0) + 1;
  }

  /// Warms asset bytes for one carousel row.
  ///
  /// [cardsPerPage] is 1 on mobile. On mobile web images load strictly one at
  /// a time; desktop loads up to [cardsPerPage] in parallel per row.
  static Future<void> preloadRow({
    required String ownerKey,
    required List<String> paths,
    required int cardsPerPage,
    bool mobileSequential = false,
  }) async {
    if (paths.isEmpty || cardsPerPage <= 0) return;

    final generation = (_ownerGeneration[ownerKey] ?? 0) + 1;
    _ownerGeneration[ownerKey] = generation;

    final rowPaths = paths.take(cardsPerPage).toList();
    final pending = rowPaths.where((p) => !_loadedPaths.contains(p)).toList();
    if (pending.isEmpty) return;

    if (mobileSequential || MobileWebPerformance.isMobileWebViewport()) {
      for (final path in pending) {
        if (_ownerGeneration[ownerKey] != generation) return;
        _loadedPaths.add(path);
        try {
          await rootBundle.load(path);
        } catch (_) {}
      }
      return;
    }

    for (final path in pending) {
      _loadedPaths.add(path);
    }
    if (_ownerGeneration[ownerKey] != generation) return;
    await Future.wait(
      pending.map((path) async {
        try {
          await rootBundle.load(path);
        } catch (_) {}
      }),
    );
  }

  /// Prefetch the next carousel row (auto-loop lookahead).
  static Future<void> preloadNextRow({
    required String ownerKey,
    required List<String> allPaths,
    required int rowIndex,
    required int cardsPerPage,
    bool mobileSequential = false,
  }) async {
    if (allPaths.isEmpty || cardsPerPage <= 0) return;
    final start = rowIndex * cardsPerPage;
    if (start >= allPaths.length) return;
    final end = (start + cardsPerPage).clamp(0, allPaths.length);
    await preloadRow(
      ownerKey: ownerKey,
      paths: allPaths.sublist(start, end),
      cardsPerPage: cardsPerPage,
      mobileSequential: mobileSequential,
    );
  }
}
