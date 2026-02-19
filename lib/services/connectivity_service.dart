import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for checking network connectivity with caching for performance.
/// Connectivity status is cached for 5 seconds to avoid excessive checks.
class ConnectivityService {
  ConnectivityService._();

  static final Connectivity _connectivity = Connectivity();
  static bool? _cachedStatus;
  static DateTime? _lastCheck;
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Cache duration for connectivity status (5 seconds).
  static const Duration _cacheDuration = Duration(seconds: 5);

  /// Initialize connectivity monitoring. Call this once at app startup.
  static void initialize() {
    // Listen to connectivity changes and update cache
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _cachedStatus = _hasConnection(results);
      _lastCheck = DateTime.now();
    });
  }

  /// Dispose connectivity monitoring. Call this when app is closing.
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Check if device is online. Uses cached value if available.
  /// Returns true if online, false if offline.
  static Future<bool> isOnline() async {
    // Use cached value if recent
    if (_cachedStatus != null &&
        _lastCheck != null &&
        DateTime.now().difference(_lastCheck!) < _cacheDuration) {
      return _cachedStatus!;
    }

    // Perform fresh check
    try {
      final results = await _connectivity.checkConnectivity();
      _cachedStatus = _hasConnection(results);
      _lastCheck = DateTime.now();
      return _cachedStatus!;
    } catch (_) {
      // If check fails, assume offline for safety
      _cachedStatus = false;
      _lastCheck = DateTime.now();
      return false;
    }
  }

  /// Check if any of the connectivity results indicate a connection.
  static bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) =>
        result != ConnectivityResult.none &&
        result != ConnectivityResult.bluetooth);
  }

  /// Get current connectivity status synchronously (uses cache).
  /// Returns null if cache is not available, otherwise returns cached status.
  static bool? getCachedStatus() {
    if (_cachedStatus == null || _lastCheck == null) {
      return null;
    }

    // Check if cache is still valid
    if (DateTime.now().difference(_lastCheck!) >= _cacheDuration) {
      return null;
    }

    return _cachedStatus;
  }

  /// Force refresh connectivity status (bypasses cache).
  static Future<bool> refresh() async {
    _cachedStatus = null;
    _lastCheck = null;
    return await isOnline();
  }
}
