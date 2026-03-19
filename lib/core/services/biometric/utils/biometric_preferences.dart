import 'package:dartz/dartz.dart';
import '../../../errors/failure.dart';
import '../../local_storage/contracts/hive_consumer.dart';
import '../../local_storage/config/box_names.dart';

/// Helper for managing biometric preferences
class BiometricPreferences {
  final HiveConsumer _hiveConsumer;
  
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _lastBiometricCheckKey = 'last_biometric_check';

  BiometricPreferences(this._hiveConsumer);

  /// Check if user has enabled biometric login
  Future<Either<Failure, bool>> isBiometricEnabled() async {
    return await _hiveConsumer.getOrDefault(
      boxName: BoxNames.authData,
      key: _biometricEnabledKey,
      defaultValue: false,
      converter: (data) => data as bool,
    );
  }

  /// Enable/disable biometric login
  Future<Either<Failure, void>> setBiometricEnabled(bool enabled) async {
    final result = await _hiveConsumer.save(
      boxName: BoxNames.authData,
      key: _biometricEnabledKey,
      value: enabled,
    );
    
    // Save timestamp
    if (result.isRight()) {
      await _hiveConsumer.save(
        boxName: BoxNames.authData,
        key: _lastBiometricCheckKey,
        value: DateTime.now().toIso8601String(),
      );
    }
    
    return result;
  }

  /// Get last biometric check timestamp
  Future<Either<Failure, DateTime?>> getLastBiometricCheck() async {
    final result = await _hiveConsumer.get(
      boxName: BoxNames.authData,
      key: _lastBiometricCheckKey,
      converter: (data) => DateTime.parse(data as String),
    );
    
    return result;
  }

  /// Clear biometric preferences (on logout)
  Future<Either<Failure, void>> clearBiometricPreferences() async {
    final result1 = await _hiveConsumer.delete(
      boxName: BoxNames.authData,
      key: _biometricEnabledKey,
    );
    
    final result2 = await _hiveConsumer.delete(
      boxName: BoxNames.authData,
      key: _lastBiometricCheckKey,
    );
    
    // Return first error or success
    return result1.isLeft() ? result1 : result2;
  }
}