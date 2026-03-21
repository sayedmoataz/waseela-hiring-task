/// Box names constants for Hive storage.
///
/// Centralized constants to ensure consistency and avoid magic strings.
/// Similar to ResponseCode in the API layer.
class BoxNames {
  BoxNames._();

  // Biometric preference
  static const String authData = 'auth_data_box';

  // BNPL Offline Cache (Bonus feature)
  static const String bnplCache = 'bnpl_cache_box';

  // App settings
  static const String settings = 'settings_box';

  // ============= GROUPS =============
  static const List<String> allBoxNames = [authData, bnplCache, settings];

  static const List<String> encryptedBoxes = [authData, bnplCache];

  static const List<String> preloadBoxes = [authData, settings];

  static const List<String> cacheBoxes = [bnplCache];

  /// Check if a box name is valid
  static bool isValidBoxName(String boxName) {
    return allBoxNames.contains(boxName);
  }

  /// Check if a box requires encryption
  static bool requiresEncryption(String boxName) {
    return encryptedBoxes.contains(boxName);
  }

  /// Check if a box should be preloaded
  static bool shouldPreload(String boxName) {
    return preloadBoxes.contains(boxName);
  }

  /// Check if a box is cache (can be cleared)
  static bool isCache(String boxName) {
    return cacheBoxes.contains(boxName);
  }

  /// Get all box names that match a predicate
  static List<String> getBoxesWhere(bool Function(String) predicate) {
    return allBoxNames.where(predicate).toList();
  }
}
