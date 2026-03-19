import 'package:dartz/dartz.dart';

import '../../../errors/failure.dart';

/// Abstract contract for Hive local storage operations.

abstract class HiveConsumer {
  // ============= BASIC CRUD OPERATIONS =============

  /// Save a value to the specified box with given key
  Future<Either<Failure, void>> save<T>({
    required String boxName,
    required String key,
    required T value,
  });

  /// Save multiple key-value pairs to the specified box
  Future<Either<Failure, void>> saveAll<T>({
    required String boxName,
    required Map<String, T> entries,
  });

  /// Get a value from the specified box by key
  Future<Either<Failure, T?>> get<T>({
    required String boxName,
    required String key,
    required T Function(dynamic) converter,
  });

  /// Get a value with a default fallback if key doesn't exist
  Future<Either<Failure, T>> getOrDefault<T>({
    required String boxName,
    required String key,
    required T defaultValue,
    required T Function(dynamic) converter,
  });

  /// Get all values from the specified box
  Future<Either<Failure, List<T>>> getAll<T>({
    required String boxName,
    required T Function(dynamic) converter,
  });

  /// Get all entries (key-value pairs) from the specified box
  Future<Either<Failure, Map<String, T>>> getAllEntries<T>({
    required String boxName,
    required T Function(dynamic) converter,
  });

  /// Get all keys from the specified box
  Future<Either<Failure, List<String>>> getKeys({required String boxName});

  /// Get all values that match the filter predicate
  Future<Either<Failure, List<T>>> getWhere<T>({
    required String boxName,
    required T Function(dynamic) converter,
    required bool Function(T) filter,
  });

  /// Delete a value from the specified box by key
  Future<Either<Failure, void>> delete({
    required String boxName,
    required String key,
  });

  /// Delete multiple values from the specified box
  Future<Either<Failure, void>> deleteAll({
    required String boxName,
    required List<String> keys,
  });

  /// Check if a key exists in the specified box
  Future<Either<Failure, bool>> containsKey({
    required String boxName,
    required String key,
  });

  // ============= BOX MANAGEMENT =============

  /// Clear all data from the specified box
  Future<Either<Failure, void>> clearBox({required String boxName});

  /// Close the specified box
  Future<Either<Failure, void>> closeBox({required String boxName});

  /// Delete the specified box entirely (including the file)
  Future<Either<Failure, void>> deleteBox({required String boxName});

  /// Check if a box is currently open
  bool isBoxOpen({required String boxName});

  /// Get the number of entries in a box
  Future<Either<Failure, int>> getBoxLength({required String boxName});

  /// Check if a box is empty
  Future<Either<Failure, bool>> isBoxEmpty({required String boxName});

  // ============= UTILITY METHODS =============

  /// Compact the specified box (reduce file size)
  Future<Either<Failure, void>> compactBox({required String boxName});

  /// Get all currently open box names
  List<String> getOpenBoxNames();

  /// Close all open boxes
  Future<Either<Failure, void>> closeAllBoxes();
}
