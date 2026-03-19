import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' as auth;
import 'package:local_auth_android/local_auth_android.dart' hide BiometricType;
import 'package:local_auth_ios/local_auth_ios.dart' hide BiometricType;

import '../../../errors/error_handler.dart';
import '../../../errors/failure.dart';
import '../contracts/biometric_consumer.dart';

class BiometricConsumerImpl implements BiometricConsumer {
  final auth.LocalAuthentication _localAuth;
  final bool _enableLogging;

  BiometricConsumerImpl({
    auth.LocalAuthentication? localAuth,
    bool enableLogging = false,
  }) : _localAuth = localAuth ?? auth.LocalAuthentication(),
       _enableLogging = enableLogging;

  @override
  Future<Either<Failure, bool>> isBiometricAvailable() async {
    try {
      _log('Checking if biometric is available');
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      final result = isAvailable || isDeviceSupported;
      _log('Biometric available: $result');

      return Right(result);
    } catch (e, stackTrace) {
      _log('Error checking biometric availability: $e');
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, bool>> hasBiometricEnrolled() async {
    try {
      _log('Checking if biometric is enrolled');
      final biometrics = await _localAuth.getAvailableBiometrics();

      final hasEnrolled = biometrics.isNotEmpty;
      _log('Biometric enrolled: $hasEnrolled');

      return Right(hasEnrolled);
    } catch (e, stackTrace) {
      _log('Error checking biometric enrollment: $e');
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometric({
    required String reason,
  }) async {
    try {
      _log('Starting biometric authentication');

      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Confirm Your Order',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            lockOut:
                'Biometric authentication is locked. Please try again later.',
            goToSettingsButton: 'Settings',
            goToSettingsDescription:
                'Please enable biometric authentication in Settings.',
            cancelButton: 'Cancel',
          ),
        ],
        biometricOnly: true,
      );

      _log('Biometric authentication result: $authenticated');
      return Right(authenticated);
    } on PlatformException catch (e, stackTrace) {
      if (e.code == 'NotAvailable' || e.code == 'PasscodeNotSet') {
        return const Right(false);
      }
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<BiometricType>>> getAvailableBiometrics() async {
    try {
      _log('Getting available biometrics');
      final biometrics = await _localAuth.getAvailableBiometrics();

      final types = biometrics.map((b) {
        return switch (b) {
          auth.BiometricType.face => BiometricType.face,
          auth.BiometricType.fingerprint => BiometricType.fingerprint,
          auth.BiometricType.iris => BiometricType.iris,
          auth.BiometricType.weak => BiometricType.weak,
          auth.BiometricType.strong => BiometricType.strong,
        };
      }).toList();

      _log('Available biometrics: $types');
      return Right(types);
    } catch (e, stackTrace) {
      _log('Error getting available biometrics: $e');
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }

  void _log(String message) {
    if (_enableLogging) {
      debugPrint('[BiometricConsumer] $message');
    }
  }
}
