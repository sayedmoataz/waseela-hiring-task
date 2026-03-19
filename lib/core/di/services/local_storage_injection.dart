import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waseela/core/services/services.dart';

import '../../services/local_storage/config/box_names.dart';
import '../../services/local_storage/contracts/hive_consumer.dart';
import '../../services/local_storage/factory/hive_service_factory.dart';
import '../../services/local_storage/utils/encryption_helper.dart';

final sl = GetIt.instance;

/// Initialize Hive local storage service with encryption.
Future<void> initLocalStorage() async {
  try {
    // Get storage path
    final appDocDir = await getApplicationDocumentsDirectory();
    final storagePath = '${appDocDir.path}/hive_storage';

    // Get or create encryption key (SECURITY CRITICAL!)
    final encryptionKey = await EncryptionHelper.getOrCreateEncryptionKey();

    // Validate encryption key
    if (!EncryptionHelper.validateKey(encryptionKey)) {
      throw Exception('Invalid encryption key length: ${encryptionKey.length}');
    }

    // Create Hive consumer with encryption
    final hiveConsumer = await HiveServiceFactory.create(
      storagePath: storagePath,
      encryptionKey: encryptionKey,
      adapters: [],
      boxesToPreload: BoxNames.preloadBoxes,
    );

    // Register as lazy singleton
    sl.registerLazySingleton<HiveConsumer>(() => hiveConsumer);
  } catch (e, stackTrace) {
    CrashlyticsLogger.logError(
      e,
      stackTrace,
      reason: 'Error in local storage initialization',
      feature: 'local_storage',
    );
    rethrow;
  }
}
