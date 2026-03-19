import 'package:dartz/dartz.dart';
import '../../../errors/failure.dart';

/// Contract for biometric authentication operations
abstract class BiometricConsumer {
  /// Check if biometric authentication is available on device
  Future<Either<Failure, bool>> isBiometricAvailable();
  
  /// Check if user has enrolled biometric credentials
  Future<Either<Failure, bool>> hasBiometricEnrolled();
  
  /// Authenticate using biometric
  /// 
  /// [reason] Message shown to user during authentication
  /// Returns true if authentication successful
  Future<Either<Failure, bool>> authenticateWithBiometric({
    required String reason,
  });
  
  /// Get available biometric types
  Future<Either<Failure, List<BiometricType>>> getAvailableBiometrics();
}

enum BiometricType {
  face,
  fingerprint,
  iris,
  weak,
  strong,
}