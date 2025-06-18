import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

@singleton
class SecureStorage {
  // Cache for sync access (optional optimization)
  static String? _cachedAuthToken;

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );


  Future<String?> getAuthToken() async {
    try {
      final token = await _storage.read(key: AppConstants.keyAuthToken);
      _cachedAuthToken = token; // Cache for sync access
      return token;
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Add this method for synchronous access in Dio interceptor
  String? getAuthTokenSync() {
    return _cachedAuthToken;
  }

  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: AppConstants.keyAuthToken, value: token);
      _cachedAuthToken = token;
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<void> clearAuthTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: AppConstants.keyAuthToken),
        _storage.delete(key: AppConstants.keyRefreshToken),
      ]);
      _cachedAuthToken = null;
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: AppConstants.keyRefreshToken, value: token);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppConstants.keyRefreshToken);
    } catch (e) {
      throw StorageException.readError();
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: AppConstants.keyUserId, value: userId);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: AppConstants.keyUserId);
    } catch (e) {
      throw StorageException.readError();
    }
  }

  Future<void> saveUserCredentials(String email, String password) async {
    try {
      await Future.wait([
        _storage.write(key: 'user_email', value: email),
        _storage.write(key: 'user_password', value: password),
      ]);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<Map<String, String?>> getUserCredentials() async {
    try {
      final email = await _storage.read(key: 'user_email');
      final password = await _storage.read(key: 'user_password');
      return {'email': email, 'password': password};
    } catch (e) {
      throw StorageException.readError();
    }
  }

  Future<void> clearUserCredentials() async {
    try {
      await Future.wait([
        _storage.delete(key: 'user_email'),
        _storage.delete(key: 'user_password'),
      ]);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Biometric settings
  Future<void> saveBiometricsEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: AppConstants.keyBiometricsEnabled,
        value: enabled.toString(),
      );
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<bool> getBiometricsEnabled() async {
    try {
      final value = await _storage.read(key: AppConstants.keyBiometricsEnabled);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  // PIN/Passcode
  Future<void> savePasscode(String passcode) async {
    try {
      await _storage.write(key: 'user_passcode', value: passcode);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getPasscode() async {
    try {
      return await _storage.read(key: 'user_passcode');
    } catch (e) {
      throw StorageException.readError();
    }
  }

  Future<void> clearPasscode() async {
    try {
      await _storage.delete(key: 'user_passcode');
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Session data
  Future<void> saveSessionData(String key, String value) async {
    try {
      await _storage.write(key: 'session_$key', value: value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getSessionData(String key) async {
    try {
      return await _storage.read(key: 'session_$key');
    } catch (e) {
      throw StorageException.readError();
    }
  }

  Future<void> clearSessionData() async {
    try {
      final allKeys = await _storage.readAll();
      final sessionKeys = allKeys.keys.where((key) => key.startsWith('session_'));

      for (final key in sessionKeys) {
        await _storage.delete(key: key);
      }
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Device information
  Future<void> saveDeviceId(String deviceId) async {
    try {
      await _storage.write(key: 'device_id', value: deviceId);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getDeviceId() async {
    try {
      return await _storage.read(key: 'device_id');
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // FCM Token
  Future<void> saveFCMToken(String token) async {
    try {
      await _storage.write(key: 'fcm_token', value: token);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getFCMToken() async {
    try {
      return await _storage.read(key: 'fcm_token');
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Payment information (if needed for checkout flow)
  Future<void> savePaymentToken(String token) async {
    try {
      await _storage.write(key: 'payment_token', value: token);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<String?> getPaymentToken() async {
    try {
      return await _storage.read(key: 'payment_token');
    } catch (e) {
      throw StorageException.readError();
    }
  }

  Future<void> clearPaymentData() async {
    try {
      await _storage.delete(key: 'payment_token');
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Security settings
  Future<void> saveAutoLockEnabled(bool enabled) async {
    try {
      await _storage.write(key: 'auto_lock_enabled', value: enabled.toString());
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<bool> getAutoLockEnabled() async {
    try {
      final value = await _storage.read(key: 'auto_lock_enabled');
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> saveAutoLockTimeout(int minutes) async {
    try {
      await _storage.write(key: 'auto_lock_timeout', value: minutes.toString());
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  Future<int> getAutoLockTimeout() async {
    try {
      final value = await _storage.read(key: 'auto_lock_timeout');
      return int.tryParse(value ?? '5') ?? 5; // Default 5 minutes
    } catch (e) {
      return 5;
    }
  }

  // Check if any sensitive data exists
  Future<bool> hasStoredCredentials() async {
    try {
      final email = await _storage.read(key: 'user_email');
      final token = await _storage.read(key: AppConstants.keyAuthToken);
      return email != null || token != null;
    } catch (e) {
      return false;
    }
  }

  // Clear all stored data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Get all stored keys (for debugging)
  Future<Map<String, String>> getAllData() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      throw StorageException.readError();
    }
  }

  // Check if storage is available
  Future<bool> isStorageAvailable() async {
    try {
      await _storage.write(key: '_test_key', value: 'test');
      await _storage.delete(key: '_test_key');
      return true;
    } catch (e) {
      return false;
    }
  }
}