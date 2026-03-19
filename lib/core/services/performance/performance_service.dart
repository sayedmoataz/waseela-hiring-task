import 'package:flutter/foundation.dart';
import 'package:performance_monitor/performance_monitor.dart';

/// Performance Service
/// A wrapper service for performance monitoring and smart caching.
/// Provides simplified API for timing operations and optional caching layer.
class PerformanceService {
  PerformanceService._();

  static final PerformanceService _instance = PerformanceService._();

  /// Singleton instance
  static PerformanceService get instance => _instance;

  /// Performance optimization service for caching
  final PerformanceOptimizationService _cacheService =
      PerformanceOptimizationService.instance;

  bool _isInitialized = false;

  /// Initialize the performance service
  /// Call this once at app startup if you want to use caching features
  Future<void> initialize() async {
    if (_isInitialized) return;
    await _cacheService.initialize();
    _isInitialized = true;
  }

  /// Start timing an operation
  /// Use with [endOperation] to measure duration
  void startOperation(String name) {
    PerformanceMonitor.startTimer(name);
  }

  /// End timing an operation
  /// Returns the duration in milliseconds
  void endOperation(String name) {
    PerformanceMonitor.endTimer(name);
  }

  /// Measure an async operation
  /// Automatically times the operation and logs the result
  Future<T> measureAsync<T>(String name, Future<T> Function() operation) async {
    return await PerformanceMonitor.measureAsync(name, operation);
  }

  /// Measure a synchronous operation
  /// Automatically times the operation and logs the result
  T measure<T>(String name, T Function() operation) {
    startOperation(name);
    try {
      final result = operation();
      return result;
    } finally {
      endOperation(name);
    }
  }

  /// Get the slowest operation above a threshold (in ms)
  /// Returns null if no operations exceed the threshold
  String? getSlowestOperation([int thresholdMs = 100]) {
    return PerformanceMonitor.getSlowestOperation(thresholdMs);
  }

  /// Get all operations slower than a threshold (in ms)
  List<String> getSlowOperations([int thresholdMs = 100]) {
    return PerformanceMonitor.getSlowOperations(thresholdMs);
  }

  /// Print a detailed timing report
  /// Shows all measured operations with their durations and percentages
  void printReport() {
    if (kDebugMode) {
      PerformanceMonitor.printTimingReport();
    }
  }

  // ==================== Caching Layer ====================

  /// Get cached data or load it if not cached
  /// Uses smart caching with deduplication for expensive operations
  Future<T> getCachedOrLoad<T>(String key, Future<T> Function() loader) async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _cacheService.getCachedOrLoad(key, loader);
  }

  /// Clear a specific cache entry
  void clearCache(String key) {
    _cacheService.clearCache(key);
  }

  /// Clear all cache entries
  void clearAllCache() {
    _cacheService.clearAllCache();
  }
}
