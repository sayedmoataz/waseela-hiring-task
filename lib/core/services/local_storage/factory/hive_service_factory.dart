import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/hive_config.dart';
import '../contracts/hive_consumer.dart';
import '../implementation/hive_consumer_impl.dart';

/// Factory for creating configured HiveConsumer instances.
class HiveServiceFactory {
  static Future<HiveConsumer> create({
    required String storagePath,
    List<int>? encryptionKey,
    List<TypeAdapter> adapters = const [],
    List<String> boxesToPreload = const [],
    bool? enableLogging,
  }) async {
    // Create config with defaults
    var config = HiveConfig(
      storagePath: storagePath,
      encryptionKey: encryptionKey,
      adapters: adapters,
      boxesToPreload: boxesToPreload,
    );

    // Apply logging override if provided
    if (enableLogging != null) {
      config = config.copyWith(enableLogging: enableLogging);
    }

    // Validate config
    config.validate();

    // Initialize Hive
    await Hive.initFlutter(config.storagePath);

    // Register adapters
    for (var adapter in config.adapters) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    // Preload boxes if specified
    for (var boxName in config.boxesToPreload) {
      if (!Hive.isBoxOpen(boxName)) {
        if (config.encryptionKey != null) {
          await Hive.openBox(
            boxName,
            encryptionCipher: HiveAesCipher(config.encryptionKey!),
          );
        } else {
          await Hive.openBox(boxName);
        }
      }
    }

    if (config.enableLogging) {
      debugPrint('[HiveServiceFactory] Initialized Hive with config: $config');
    }

    // Return configured consumer
    return HiveConsumerImpl(config);
  }
}
