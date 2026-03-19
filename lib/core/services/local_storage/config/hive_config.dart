import 'package:hive_flutter/hive_flutter.dart';

import '../../../config/app_config.dart';

/// Configuration class for Hive initialization and setup.
class HiveConfig {
  final String storagePath;
  final List<int>? encryptionKey;
  final List<TypeAdapter> adapters;
  final bool enableLogging;
  final List<String> boxesToPreload;

  HiveConfig({
    required this.storagePath,
    this.encryptionKey,
    this.adapters = const [],
    this.boxesToPreload = const [],
    bool? enableLogging,
  }) : enableLogging = enableLogging ?? AppConfig.enableLogging;

  /// Validate the configuration
  void validate() {
    if (storagePath.isEmpty) {
      throw ArgumentError('storagePath cannot be empty');
    }

    // Validate encryption key length if provided
    if (encryptionKey != null) {
      if (encryptionKey!.length != 32) {
        throw ArgumentError(
          'Encryption key must be exactly 32 bytes long, got ${encryptionKey!.length}',
        );
      }
    }

    // Validate adapter type IDs are unique
    final typeIds = adapters.map((a) => a.typeId).toList();
    final uniqueTypeIds = typeIds.toSet();
    if (typeIds.length != uniqueTypeIds.length) {
      throw ArgumentError('Type adapter IDs must be unique');
    }
  }

  /// Create a copy with modified parameters
  HiveConfig copyWith({
    String? storagePath,
    List<int>? encryptionKey,
    List<TypeAdapter>? adapters,
    bool? enableLogging,
    List<String>? boxesToPreload,
  }) {
    return HiveConfig(
      storagePath: storagePath ?? this.storagePath,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      adapters: adapters ?? this.adapters,
      enableLogging: enableLogging ?? this.enableLogging,
      boxesToPreload: boxesToPreload ?? this.boxesToPreload,
    );
  }

  @override
  String toString() {
    return 'HiveConfig('
        'storagePath: $storagePath, '
        'hasEncryption: ${encryptionKey != null}, '
        'adaptersCount: ${adapters.length}, '
        'enableLogging: $enableLogging, '
        'boxesToPreload: ${boxesToPreload.length}'
        ')';
  }
}
