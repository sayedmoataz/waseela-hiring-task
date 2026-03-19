import 'package:local_auth/local_auth.dart';

import '../contracts/biometric_consumer.dart';
import '../implementation/biometric_consumer_impl.dart';

class BiometricFactory {
  BiometricFactory._();

  static BiometricConsumer create({
    LocalAuthentication? localAuth,
    bool enableLogging = false,
  }) {
    return BiometricConsumerImpl(
      localAuth: localAuth,
      enableLogging: enableLogging,
    );
  }
}