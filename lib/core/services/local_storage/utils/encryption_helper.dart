import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

/// Helper class for managing Hive encryption keys securely.
class EncryptionHelper {
  EncryptionHelper._();

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const _keyStorageKey = 'hive_encryption_master_key';

  /// Get existing encryption key or create a new one if it doesn't exist.
  static Future<List<int>> getOrCreateEncryptionKey() async {
    try {
      // Try to get existing key
      final existingKey = await _secureStorage.read(key: _keyStorageKey);

      if (existingKey != null && existingKey.isNotEmpty) {
        try {
          final decodedKey = base64Url.decode(existingKey);

          // Validate key length
          if (decodedKey.length == 32) {
            return decodedKey;
          } else {
            debugPrint(
              '[EncryptionHelper] Invalid key length (${decodedKey.length}), generating new key',
            );
          }
        } catch (e) {
          debugPrint('[EncryptionHelper] Failed to decode existing key: $e');
        }
      }

      final newKey = Hive.generateSecureKey();

      if (newKey.length != 32) {
        throw Exception(
          'Generated key has invalid length: ${newKey.length}, expected 32',
        );
      }

      // Store securely
      await _secureStorage.write(
        key: _keyStorageKey,
        value: base64UrlEncode(newKey),
      );

      debugPrint('[EncryptionHelper] New encryption key generated and stored ✅');

      return newKey;
    } catch (e) {
      throw Exception('Failed to get or create encryption key: $e');
    }
  }

  /// Delete the encryption key from secure storage.
  static Future<void> deleteEncryptionKey() async {
    try {
      await _secureStorage.delete(key: _keyStorageKey);
      debugPrint('[EncryptionHelper] Encryption key deleted ⚠️');
    } catch (e) {
      debugPrint('[EncryptionHelper] Failed to delete encryption key: $e');
      rethrow;
    }
  }

  /// Check if an encryption key exists in secure storage.
  static Future<bool> hasEncryptionKey() async {
    try {
      final key = await _secureStorage.read(key: _keyStorageKey);
      return key != null && key.isNotEmpty;
    } catch (e) {
      debugPrint('[EncryptionHelper] Failed to check encryption key: $e');
      return false;
    }
  }

  /// Validate an encryption key.
  static bool validateKey(List<int> key) {
    return key.length == 32;
  }

  /// Reset all encryption (delete key and close all boxes).
  static Future<void> resetEncryption() async {
    try {
      // Close all Hive boxes first
      await Hive.close();

      // Delete encryption key
      await deleteEncryptionKey();

      debugPrint('[EncryptionHelper] Encryption reset complete ⚠️');
    } catch (e) {
      throw Exception('Failed to reset encryption: $e');
    }
  }
}