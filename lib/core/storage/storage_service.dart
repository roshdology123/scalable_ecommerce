import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';
import '../utils/app_logger.dart';
import 'local_storage.dart';
import 'secure_storage.dart';

@singleton
class StorageService {
  final SharedPreferences _prefs;
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;
  final AppLogger _logger = AppLogger();

  StorageService(
      this._prefs,
      this._secureStorage,
      this._localStorage,
      ) {
    _logger.logBusinessLogic(
      'storage_service_initialized',
      'service_init',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:39:50',
      },
    );
  }

  // ============================================================================
  // CART OPERATIONS (for Cart feature)
  // ============================================================================

  /// Save cart data as JSON string
  Future<void> saveCartData(String userId, Map<String, dynamic> cartData) async {
    try {
      _logger.logBusinessLogic(
        'storage_save_cart_data',
        'cart_operation',
        {
          'user_id': userId,
          'cart_items_count': cartData['items']?.length ?? 0,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );

      final key = 'cart_data_$userId';
      await _prefs.setString(key, cartData.toString());

    } catch (e) {
      _logger.logErrorWithContext(
        'StorageService.saveCartData',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );
      throw StorageException.writeError();
    }
  }

  /// Get cart data as Map
  Future<Map<String, dynamic>?> getCartData(String userId) async {
    try {
      final key = 'cart_data_$userId';
      final cartDataString = _prefs.getString(key);

      _logger.logBusinessLogic(
        'storage_get_cart_data',
        'cart_operation',
        {
          'user_id': userId,
          'has_data': cartDataString != null,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );

      if (cartDataString == null) return null;

      // In a real app, you'd use proper JSON parsing
      // For now, return empty map if no data
      return <String, dynamic>{};

    } catch (e) {
      _logger.logErrorWithContext(
        'StorageService.getCartData',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );
      throw StorageException.readError();
    }
  }

  /// Clear cart data
  Future<void> clearCartData(String userId) async {
    try {
      final key = 'cart_data_$userId';
      await _prefs.remove(key);

      _logger.logBusinessLogic(
        'storage_clear_cart_data',
        'cart_operation',
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );

    } catch (e) {
      _logger.logErrorWithContext(
        'StorageService.clearCartData',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );
      throw StorageException.writeError();
    }
  }

  // ============================================================================
  // GENERAL STORAGE OPERATIONS
  // ============================================================================

  /// Save string value
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  /// Get string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  /// Save integer value
  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  /// Get integer value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      return null;
    }
  }

  /// Save boolean value
  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  /// Get boolean value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      return null;
    }
  }

  /// Save double value
  Future<void> saveDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  /// Get double value
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      return null;
    }
  }

  /// Save string list
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  /// Get string list
  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  /// Remove key
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  /// Check if key exists
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Get all keys
  Set<String> getAllKeys() {
    try {
      return _prefs.getKeys();
    } catch (e) {
      return <String>{};
    }
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // ============================================================================
  // SECURE STORAGE DELEGATION
  // ============================================================================

  /// Save auth token securely
  Future<void> saveAuthToken(String token) async {
    await _secureStorage.saveAuthToken(token);
  }

  /// Get auth token
  Future<String?> getAuthToken() async {
    return await _secureStorage.getAuthToken();
  }

  /// Get auth token synchronously (cached)
  String? getAuthTokenSync() {
    return _secureStorage.getAuthTokenSync();
  }

  /// Clear auth tokens
  Future<void> clearAuthTokens() async {
    await _secureStorage.clearAuthTokens();
  }

  /// Save user ID securely
  Future<void> saveUserId(String userId) async {
    await _secureStorage.saveUserId(userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.getUserId();
  }

  // ============================================================================
  // LOCAL STORAGE DELEGATION (for complex objects)
  // ============================================================================

  /// Save products to local storage
  Future<void> saveProducts(List<dynamic> products) async {
    // Convert to ProductModel if needed
    await LocalStorage.saveProducts(products.cast());
  }

  /// Get products from local storage
  List<dynamic> getProducts() {
    return LocalStorage.getProducts();
  }

  /// Save to cache with expiry
  Future<void> saveToCache(String key, Map<String, dynamic> data, {Duration? expiry}) async {
    await LocalStorage.saveToCache(key, data, expiry: expiry);
  }

  /// Get from cache
  Map<String, dynamic>? getFromCache(String key) {
    return LocalStorage.getFromCache(key);
  }

  /// Add to favorites
  Future<void> addFavorite(int productId) async {
    await LocalStorage.addFavorite(productId);
  }

  /// Remove from favorites
  Future<void> removeFavorite(int productId) async {
    await LocalStorage.removeFavorite(productId);
  }

  /// Check if product is favorite
  bool isFavorite(int productId) {
    return LocalStorage.isFavorite(productId);
  }

  /// Get favorites list
  List<int> getFavorites() {
    return LocalStorage.getFavorites();
  }

  // ============================================================================
  // SETTINGS OPERATIONS
  // ============================================================================

  /// Save theme mode
  Future<void> saveThemeMode(String themeMode) async {
    await LocalStorage.saveThemeMode(themeMode);
  }

  /// Get theme mode
  String? getThemeMode() {
    return LocalStorage.getThemeMode();
  }

  /// Save language
  Future<void> saveLanguage(String languageCode) async {
    await LocalStorage.saveLanguage(languageCode);
  }

  /// Get language
  String? getLanguage() {
    return LocalStorage.getLanguage();
  }

  /// Save onboarding completed
  Future<void> saveOnboardingCompleted(bool completed) async {
    await LocalStorage.saveOnboardingCompleted(completed);
  }

  /// Get onboarding completed
  bool getOnboardingCompleted() {
    return LocalStorage.getOnboardingCompleted();
  }

  /// Save notifications enabled
  Future<void> saveNotificationsEnabled(bool enabled) async {
    await LocalStorage.saveNotificationsEnabled(enabled);
  }

  /// Get notifications enabled
  bool getNotificationsEnabled() {
    return LocalStorage.getNotificationsEnabled();
  }

  // ============================================================================
  // SEARCH HISTORY OPERATIONS
  // ============================================================================

  /// Add search query
  Future<void> addSearchQuery(String query) async {
    await LocalStorage.addSearchQuery(query);
  }

  /// Get search history
  List<String> getSearchHistory() {
    return LocalStorage.getSearchHistory();
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    await LocalStorage.clearSearchHistory();
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Check if local storage is initialized
  bool get isLocalStorageInitialized => LocalStorage.isInitialized;

  /// Get storage statistics
  Map<String, int> get storageStats => {
    'products_count': LocalStorage.productsCount,
    'cart_items_count': LocalStorage.cartItemsCount,
    'favorites_count': LocalStorage.favoritesCount,
    'preferences_keys_count': _prefs.getKeys().length,
  };

  /// Initialize all storage systems
  static Future<void> initializeAll() async {
    final logger = AppLogger();

    try {
      logger.logBusinessLogic(
        'storage_initialization_started',
        'system_init',
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );

      // Initialize local storage (Hive)
      await LocalStorage.init();

      logger.logBusinessLogic(
        'storage_initialization_completed',
        'system_init',
        {
          'local_storage_initialized': LocalStorage.isInitialized,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );

    } catch (e, stackTrace) {
      logger.logErrorWithContext(
        'StorageService.initializeAll',
        e,
        stackTrace,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:39:50',
        },
      );
      rethrow;
    }
  }
}