/// Core Services Barrel Export
/// Export all services for easy imports
library;

// ========== Biometric ==========
export 'biometric/contracts/biometric_consumer.dart';
export 'biometric/factory/biometric_factory.dart';
export 'biometric/implementation/biometric_consumer_impl.dart';
export 'biometric/utils/biometric_preferences.dart';
// ========== Crashlytics ==========
export 'crashlytics/crashlytics_logger.dart';
// ========== Navigation ==========
export 'navigation/navigation_extensions.dart';
export 'navigation/navigation_service.dart';
export 'navigation/route_aware_mixin.dart';
export 'navigation/route_generator.dart';
// ========== General ==========
export 'performance/performance_service.dart';
