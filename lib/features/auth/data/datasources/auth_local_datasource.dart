import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();

  Future<AuthTokensModel?> getAuthTokens();
  Future<void> saveAuthTokens(AuthTokensModel tokens);
  Future<void> clearAuthTokens();

  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool isLoggedIn);

  Future<void> saveUserCredentials(String email, String password);
  Future<Map<String, String?>> getUserCredentials();
  Future<void> clearUserCredentials();

  Future<bool> isBiometricsEnabled();
  Future<void> setBiometricsEnabled(bool enabled);

  Future<bool> isRememberMeEnabled();
  Future<void> setRememberMeEnabled(bool enabled);

  Future<void> clearAllAuthData();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = LocalStorage.getUserData(AppConstants.keyUserData);
      if (userJson != null) {
        final userMap = Map<String, dynamic>.from(
          Uri.decodeFull(userJson).split('&').fold<Map<String, dynamic>>(
            {},
                (map, item) {
              final split = item.split('=');
              if (split.length == 2) {
                map[split[0]] = split[1];
              }
              return map;
            },
          ),
        );
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException.readError();
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      // Convert user to JSON string and encode
      final userJson = user.toJson().entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');

      await LocalStorage.saveUserData(AppConstants.keyUserData, userJson);
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await LocalStorage.clearUserData();
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<AuthTokensModel?> getAuthTokens() async {
    try {
      final accessToken = await _secureStorage.getAuthToken();
      final refreshToken = await _secureStorage.getRefreshToken();

      if (accessToken != null) {
        // Get expiry from cache or default to 1 hour
        final expiryString = LocalStorage.getUserData('token_expiry');
        final expiresAt = expiryString != null
            ? DateTime.parse(expiryString)
            : DateTime.now().add(const Duration(hours: 1));

        return AuthTokensModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
          tokenType: 'Bearer',
        );
      }
      return null;
    } catch (e) {
      throw StorageException.readError();
    }
  }

  @override
  Future<void> saveAuthTokens(AuthTokensModel tokens) async {
    try {
      await Future.wait([
        _secureStorage.saveAuthToken(tokens.accessToken),
        if (tokens.refreshToken != null)
          _secureStorage.saveRefreshToken(tokens.refreshToken!),
        LocalStorage.saveUserData(
          'token_expiry',
          tokens.expiresAt.toIso8601String(),
        ),
      ]);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<void> clearAuthTokens() async {
    try {
      await Future.wait([
        _secureStorage.clearAuthTokens(),
        LocalStorage.saveUserData('token_expiry', ''),
      ]);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final tokens = await getAuthTokens();
      return tokens != null && !tokens.isExpired;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await LocalStorage.saveUserData(
        'is_logged_in',
        isLoggedIn.toString(),
      );
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<void> saveUserCredentials(String email, String password) async {
    try {
      await _secureStorage.saveUserCredentials(email, password);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<Map<String, String?>> getUserCredentials() async {
    try {
      return await _secureStorage.getUserCredentials();
    } catch (e) {
      throw StorageException.readError();
    }
  }

  @override
  Future<void> clearUserCredentials() async {
    try {
      await _secureStorage.clearUserCredentials();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    try {
      return await _secureStorage.getBiometricsEnabled();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    try {
      await _secureStorage.saveBiometricsEnabled(enabled);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<bool> isRememberMeEnabled() async {
    try {
      final value = LocalStorage.getUserData('remember_me');
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setRememberMeEnabled(bool enabled) async {
    try {
      await LocalStorage.saveUserData('remember_me', enabled.toString());
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  @override
  Future<void> clearAllAuthData() async {
    try {
      await Future.wait([
        clearCachedUser(),
        clearAuthTokens(),
        clearUserCredentials(),
        setBiometricsEnabled(false),
        setRememberMeEnabled(false),
        setLoggedIn(false),
      ]);
    } catch (e) {
      throw StorageException.writeError();
    }
  }
}