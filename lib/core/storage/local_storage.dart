import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../features/cart/data/models/cart_item_model.dart';
import '../../features/products/data/models/rating_model.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
// import '../../features/cart/data/models/cart_item_model.dart';
import '../../features/products/data/models/product_model.dart';

@singleton
class LocalStorage {
  static late Box<ProductModel> _productsBox;
  static late Box<CartItemModel> _cartBox;
  static late Box<int> _favoritesBox;
  static late Box<String> _settingsBox;
  static late Box<Map<dynamic, dynamic>> _cacheBox;
  static late Box<String> _userBox;
  static late Box<String> _searchBox;

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // Register adapters
      _registerAdapters();

      // Open boxes
      await _openBoxes();

      _isInitialized = true;
    } catch (e) {
      throw StorageException(
        message: 'Failed to initialize local storage',
        code: 'INIT_ERROR',
        data: e.toString(),
      );
    }
  }

  static void _registerAdapters() {
    // if (!Hive.isAdapterRegistered(0)) {
    //   Hive.registerAdapter(ProductModelAdapter());
    // }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CartItemModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RatingModelAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    _productsBox = await Hive.openBox<ProductModel>(AppConstants.boxProducts);
    _cartBox = await Hive.openBox<CartItemModel>(AppConstants.boxCart);
    _favoritesBox = await Hive.openBox<int>(AppConstants.boxFavorites);
    _settingsBox = await Hive.openBox<String>(AppConstants.boxSettings);
    _cacheBox = await Hive.openBox<Map<dynamic, dynamic>>(AppConstants.boxCache);
    _userBox = await Hive.openBox<String>(AppConstants.boxUser);
    _searchBox = await Hive.openBox<String>(AppConstants.boxSearch);
  }

  // Products Operations
  static Future<void> saveProducts(List<ProductModel> products) async {
    try {
      final productMap = {for (var product in products) product.id: product};
      await _productsBox.putAll(productMap);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> saveProduct(ProductModel product) async {
    try {
      await _productsBox.put(product.id, product);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static List<ProductModel> getProducts() {
    try {
      return _productsBox.values.toList();
    } catch (e) {
      throw StorageException.readError();
    }
  }

  static ProductModel? getProduct(int id) {
    try {
      return _productsBox.get(id);
    } catch (e) {
      throw StorageException.readError();
    }
  }

  static Future<void> clearProducts() async {
    try {
      await _productsBox.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Cart Operations
  static Future<void> saveCartItems(List<CartItemModel> cartItems) async {
    try {
      await _cartBox.clear();
      final cartMap = {for (var item in cartItems) item.productId: item};
      await _cartBox.putAll(cartMap);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> addCartItem(CartItemModel cartItem) async {
    try {
      await _cartBox.put(cartItem.productId, cartItem);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> removeCartItem(int productId) async {
    try {
      await _cartBox.delete(productId);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static List<CartItemModel> getCartItems() {
    try {
      return _cartBox.values.toList();
    } catch (e) {
      throw StorageException.readError();
    }
  }

  static CartItemModel? getCartItem(int productId) {
    try {
      return _cartBox.get(productId);
    } catch (e) {
      throw StorageException.readError();
    }
  }

  static Future<void> clearCart() async {
    try {
      await _cartBox.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Favorites Operations
  static Future<void> addFavorite(int productId) async {
    try {
      await _favoritesBox.put(productId, productId);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> removeFavorite(int productId) async {
    try {
      await _favoritesBox.delete(productId);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static List<int> getFavorites() {
    try {
      return _favoritesBox.values.toList();
    } catch (e) {
      throw StorageException.readError();
    }
  }

  static bool isFavorite(int productId) {
    try {
      return _favoritesBox.containsKey(productId);
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearFavorites() async {
    try {
      await _favoritesBox.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Settings Operations
  static Future<void> saveThemeMode(String themeMode) async {
    try {
      await _settingsBox.put(AppConstants.keyThemeMode, themeMode);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static String? getThemeMode() {
    try {
      return _settingsBox.get(AppConstants.keyThemeMode);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveLanguage(String languageCode) async {
    try {
      await _settingsBox.put(AppConstants.keyLanguageCode, languageCode);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static String? getLanguage() {
    try {
      return _settingsBox.get(AppConstants.keyLanguageCode);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveOnboardingCompleted(bool completed) async {
    try {
      await _settingsBox.put(AppConstants.keyOnboardingCompleted, completed.toString());
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static bool getOnboardingCompleted() {
    try {
      final value = _settingsBox.get(AppConstants.keyOnboardingCompleted);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  static Future<void> saveNotificationsEnabled(bool enabled) async {
    try {
      await _settingsBox.put(AppConstants.keyNotificationsEnabled, enabled.toString());
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static bool getNotificationsEnabled() {
    try {
      final value = _settingsBox.get(AppConstants.keyNotificationsEnabled);
      return value != 'false'; // Default to true
    } catch (e) {
      return true;
    }
  }

  // Cache Operations
  static Future<void> saveToCache(String key, Map<String, dynamic> data, {Duration? expiry}) async {
    try {
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': expiry?.inMilliseconds,
      };
      await _cacheBox.put(key, cacheData);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Map<String, dynamic>? getFromCache(String key) {
    try {
      final cacheData = _cacheBox.get(key);
      if (cacheData == null) return null;

      final timestamp = cacheData['timestamp'] as int;
      final expiry = cacheData['expiry'] as int?;

      if (expiry != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - timestamp > expiry) {
          _cacheBox.delete(key); // Remove expired data
          return null;
        }
      }

      return Map<String, dynamic>.from(cacheData['data']);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearCache() async {
    try {
      await _cacheBox.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> removeFromCache(String key) async {
    try {
      await _cacheBox.delete(key);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // Search History Operations
  static Future<void> addSearchQuery(String query) async {
    try {
      final history = getSearchHistory();
      history.remove(query); // Remove if exists
      history.insert(0, query); // Add to beginning

      // Keep only recent searches
      if (history.length > AppConstants.maxSearchHistoryItems) {
        history.removeRange(AppConstants.maxSearchHistoryItems, history.length);
      }

      await _searchBox.clear();
      for (int i = 0; i < history.length; i++) {
        await _searchBox.put(i, history[i]);
      }
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static List<String> getSearchHistory() {
    try {
      return _searchBox.values.toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearSearchHistory() async {
    try {
      await _searchBox.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // User Data Operations
  static Future<void> saveUserData(String key, String value) async {
    try {
      await _userBox.put(key, value);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static String? getUserData(String key) {
    try {
      return _userBox.get(key);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUserData() async {
    try {
      await _userBox.clear();
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  // General Operations
  static Future<void> clearAll() async {
    try {
      await Future.wait([
        _productsBox.clear(),
        // _cartBox.clear(),
        _favoritesBox.clear(),
        _settingsBox.clear(),
        _cacheBox.clear(),
        _userBox.clear(),
        _searchBox.clear(),
      ]);
    } catch (e) {
      throw StorageException.writeError();
    }
  }

  static Future<void> dispose() async {
    try {
      await Future.wait([
        _productsBox.close(),
        // _cartBox.close(),
        _favoritesBox.close(),
        _settingsBox.close(),
        _cacheBox.close(),
        _userBox.close(),
        _searchBox.close(),
      ]);
    } catch (e) {
      throw StorageException(
        message: 'Failed to dispose local storage',
        code: 'DISPOSE_ERROR',
        data: e.toString(),
      );
    }
  }

  // Helper methods
  static bool get isInitialized => _isInitialized;

  static int get productsCount => _productsBox.length;
  static int get cartItemsCount => _cartBox.length;
  static int get favoritesCount => _favoritesBox.length;
}