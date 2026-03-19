import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../errors/error_handler.dart';
import '../../../errors/failure.dart';
import '../config/hive_config.dart';
import '../contracts/hive_consumer.dart';

/// Hive-based implementation of HiveConsumer.
class HiveConsumerImpl implements HiveConsumer {
  final HiveConfig _config;
  final Map<String, Box> _openBoxes = {};

  HiveConsumerImpl(this._config) {
    _config.validate();
  }

  /// Helper to get or open a box
  Future<Either<Failure, Box>> _getBox(String boxName) async {
    try {
      // Return if already open
      if (_openBoxes.containsKey(boxName)) {
        return Right(_openBoxes[boxName]!);
      }

      // Check if box is already open in Hive
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        _openBoxes[boxName] = box;
        return Right(box);
      }

      // Open the box
      final box = _config.encryptionKey != null
          ? await Hive.openBox(
              boxName,
              encryptionCipher: HiveAesCipher(_config.encryptionKey!),
            )
          : await Hive.openBox(boxName);

      _openBoxes[boxName] = box;

      if (_config.enableLogging) {
        debugPrint('[HiveConsumer] Opened box: $boxName');
      }

      return Right(box);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  /// Core operation handler with error mapping
  Future<Either<Failure, T>> _execute<T>({
    required Future<T> Function() operation,
    String? boxName,
  }) async {
    try {
      final result = await operation();

      if (_config.enableLogging && boxName != null) {
        debugPrint('[HiveConsumer] Operation completed on box: $boxName');
      }

      return Right(result);
    } catch (e, stackTrace) {
      if (_config.enableLogging) {
        debugPrint('[HiveConsumer] Error: $e');
      }
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> save<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute(operation: () => box.put(key, value), boxName: boxName),
    );
  }

  @override
  Future<Either<Failure, void>> saveAll<T>({
    required String boxName,
    required Map<String, T> entries,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute(operation: () => box.putAll(entries), boxName: boxName),
    );
  }

  @override
  Future<Either<Failure, T?>> get<T>({
    required String boxName,
    required String key,
    required T Function(dynamic) converter,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<T?>(
        operation: () async {
          final value = box.get(key);
          if (value == null) return Future.value();
          return converter(value);
        },
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, T>> getOrDefault<T>({
    required String boxName,
    required String key,
    required T defaultValue,
    required T Function(dynamic) converter,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<T>(
        operation: () async {
          final value = box.get(key);
          if (value == null) return Future.value(defaultValue);
          return converter(value);
        },
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, List<T>>> getAll<T>({
    required String boxName,
    required T Function(dynamic) converter,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<List<T>>(
        operation: () async {
          return box.values.map((value) => converter(value)).toList();
        },
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, T>>> getAllEntries<T>({
    required String boxName,
    required T Function(dynamic) converter,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<Map<String, T>>(
        operation: () async {
          final map = <String, T>{};
          for (var key in box.keys) {
            map[key.toString()] = converter(box.get(key));
          }
          return map;
        },
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getKeys({
    required String boxName,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<List<String>>(
        operation: () async {
          return box.keys.map((key) => key.toString()).toList();
        },
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, List<T>>> getWhere<T>({
    required String boxName,
    required T Function(dynamic) converter,
    required bool Function(T) filter,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<List<T>>(
        operation: () async {
          return box.values
              .map((value) => converter(value))
              .where(filter)
              .toList();
        },
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> delete({
    required String boxName,
    required String key,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute(operation: () => box.delete(key), boxName: boxName),
    );
  }

  @override
  Future<Either<Failure, void>> deleteAll({
    required String boxName,
    required List<String> keys,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute(operation: () => box.deleteAll(keys), boxName: boxName),
    );
  }

  @override
  Future<Either<Failure, bool>> containsKey({
    required String boxName,
    required String key,
  }) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<bool>(
        operation: () => Future.value(box.containsKey(key)),
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> clearBox({required String boxName}) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute(operation: () => box.clear(), boxName: boxName),
    );
  }

  @override
  Future<Either<Failure, void>> closeBox({required String boxName}) async {
    try {
      if (_openBoxes.containsKey(boxName)) {
        await _openBoxes[boxName]!.close();
        _openBoxes.remove(boxName);
      } else if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }

      if (_config.enableLogging) {
        debugPrint('[HiveConsumer] Closed box: $boxName');
      }

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBox({required String boxName}) async {
    try {
      // Close the box if it's open
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
        _openBoxes.remove(boxName);
      }

      // Delete the box
      await Hive.deleteBoxFromDisk(boxName);

      if (_config.enableLogging) {
        debugPrint('[HiveConsumer] Deleted box: $boxName');
      }

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  bool isBoxOpen({required String boxName}) {
    return Hive.isBoxOpen(boxName);
  }

  @override
  Future<Either<Failure, int>> getBoxLength({required String boxName}) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<int>(
        operation: () => Future.value(box.length),
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> isBoxEmpty({required String boxName}) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute<bool>(
        operation: () => Future.value(box.isEmpty),
        boxName: boxName,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> compactBox({required String boxName}) async {
    final boxResult = await _getBox(boxName);

    return boxResult.fold(
      Left.new,
      (box) => _execute(operation: () => box.compact(), boxName: boxName),
    );
  }

  @override
  List<String> getOpenBoxNames() {
    return _openBoxes.keys.toList();
  }

  @override
  Future<Either<Failure, void>> closeAllBoxes() async {
    try {
      await Hive.close();
      _openBoxes.clear();

      if (_config.enableLogging) {
        debugPrint('[HiveConsumer] Closed all boxes');
      }

      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }
}
