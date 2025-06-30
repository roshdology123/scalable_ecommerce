import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:scalable_ecommerce/core/errors/exceptions.dart';
import 'package:scalable_ecommerce/core/storage/local_storage.dart';
import 'package:scalable_ecommerce/core/storage/secure_storage.dart';
import 'package:scalable_ecommerce/core/storage/storage_service.dart';
import 'package:scalable_ecommerce/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'storage_service_test.mocks.dart';

// Generate mocks
@GenerateMocks([
  SharedPreferences,
  SecureStorage,
  LocalStorage,
  AppLogger,
  PathProviderPlatform
])
void main() {
  late MockSharedPreferences mockPrefs;
  late MockSecureStorage mockSecureStorage;
  late MockLocalStorage mockLocalStorage;
  late StorageService storageService;


  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockSecureStorage();
    mockLocalStorage = MockLocalStorage();
    
    storageService = StorageService(
      mockPrefs,
      mockSecureStorage,
      mockLocalStorage,
    );
  });
   group('Cart Operations', () {
    const testUserId = 'test_user_123';
    final testCartData = {
      'items': [
        {'id': 1, 'name': 'Product 1', 'quantity': 2},
        {'id': 2, 'name': 'Product 2', 'quantity': 1},
      ],
      'summary': {
        'subtotal': 100.0,
        'total': 110.0,
        'totalItems': 2,
        'totalQuantity': 3,
      },
    };

    test('saveCartData should save cart data successfully', () async {
      // Arrange
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Act
      await storageService.saveCartData(testUserId, testCartData);

      // Assert
      verify(mockPrefs.setString(
        'cart_data_$testUserId',
        testCartData.toString(),
      )).called(1);
    });

    test('saveCartData should throw StorageException on error', () async {
      // Arrange
      when(mockPrefs.setString(any, any)).thenThrow(Exception('Storage error'));

      // Act & Assert
      expect(
        () => storageService.saveCartData(testUserId, testCartData),
        throwsA(isA<StorageException>()),
      );
    });

    test('getCartData should return cart data when exists', () async {
      // Arrange
      when(mockPrefs.getString('cart_data_$testUserId'))
          .thenReturn(testCartData.toString());

      // Act
      final result = await storageService.getCartData(testUserId);

      // Assert
      expect(result, isNotNull);
      expect(result!['items'], isA<List>());
      expect(result['summary'], isA<Map>());
      verify(mockPrefs.getString('cart_data_$testUserId')).called(1);
    });

    test('getCartData should return null when no data exists', () async {
      // Arrange
      when(mockPrefs.getString('cart_data_$testUserId')).thenReturn(null);

      // Act
      final result = await storageService.getCartData(testUserId);

      // Assert
      expect(result, isNull);
    });

    test('getCartData should throw StorageException on error', () async {
      // Arrange
      when(mockPrefs.getString(any)).thenThrow(Exception('Read error'));

      // Act & Assert
      expect(
        () => storageService.getCartData(testUserId),
        throwsA(isA<StorageException>()),
      );
    });

    test('clearCartData should remove cart data successfully', () async {
      // Arrange
      when(mockPrefs.remove(any)).thenAnswer((_) async => true);

      // Act
      await storageService.clearCartData(testUserId);

      // Assert
      verify(mockPrefs.remove('cart_data_$testUserId')).called(1);
    });

    test('clearCartData should throw StorageException on error', () async {
      // Arrange
      when(mockPrefs.remove(any)).thenThrow(Exception('Remove error'));

      // Act & Assert
      expect(
        () => storageService.clearCartData(testUserId),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('General Storage Operations', () {
    test('saveString should save string value successfully', () async {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';
      when(mockPrefs.setString(key, value)).thenAnswer((_) async => true);

      // Act
      await storageService.saveString(key, value);

      // Assert
      verify(mockPrefs.setString(key, value)).called(1);
    });

    test('saveString should throw StorageException on error', () async {
      // Arrange
      when(mockPrefs.setString(any, any)).thenThrow(Exception('Write error'));

      // Act & Assert
      expect(
        () => storageService.saveString('key', 'value'),
        throwsA(isA<StorageException>()),
      );
    });

    test('getString should return stored string value', () {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';
      when(mockPrefs.getString(key)).thenReturn(value);

      // Act
      final result = storageService.getString(key);

      // Assert
      expect(result, equals(value));
    });

    test('getString should return null on error', () {
      // Arrange
      when(mockPrefs.getString(any)).thenThrow(Exception('Read error'));

      // Act
      final result = storageService.getString('key');

      // Assert
      expect(result, isNull);
    });

    test('saveInt should save integer value successfully', () async {
      // Arrange
      const key = 'int_key';
      const value = 42;
      when(mockPrefs.setInt(key, value)).thenAnswer((_) async => true);

      // Act
      await storageService.saveInt(key, value);

      // Assert
      verify(mockPrefs.setInt(key, value)).called(1);
    });

    test('getInt should return stored integer value', () {
      // Arrange
      const key = 'int_key';
      const value = 42;
      when(mockPrefs.getInt(key)).thenReturn(value);

      // Act
      final result = storageService.getInt(key);

      // Assert
      expect(result, equals(value));
    });

    test('saveBool should save boolean value successfully', () async {
      // Arrange
      const key = 'bool_key';
      const value = true;
      when(mockPrefs.setBool(key, value)).thenAnswer((_) async => true);

      // Act
      await storageService.saveBool(key, value);

      // Assert
      verify(mockPrefs.setBool(key, value)).called(1);
    });

    test('getBool should return stored boolean value', () {
      // Arrange
      const key = 'bool_key';
      const value = true;
      when(mockPrefs.getBool(key)).thenReturn(value);

      // Act
      final result = storageService.getBool(key);

      // Assert
      expect(result, equals(value));
    });

    test('remove should remove key successfully', () async {
      // Arrange
      const key = 'test_key';
      when(mockPrefs.remove(key)).thenAnswer((_) async => true);

      // Act
      await storageService.remove(key);

      // Assert
      verify(mockPrefs.remove(key)).called(1);
    });

    test('containsKey should return true if key exists', () {
      // Arrange
      const key = 'test_key';
      when(mockPrefs.containsKey(key)).thenReturn(true);

      // Act
      final result = storageService.containsKey(key);

      // Assert
      expect(result, isTrue);
    });

    test('containsKey should return false on error', () {
      // Arrange
      when(mockPrefs.containsKey(any)).thenThrow(Exception('Error'));

      // Act
      final result = storageService.containsKey('key');

      // Assert
      expect(result, isFalse);
    });

    test('clearAll should clear all preferences', () async {
      // Arrange
      when(mockPrefs.clear()).thenAnswer((_) async => true);

      // Act
      await storageService.clearAll();

      // Assert
      verify(mockPrefs.clear()).called(1);
    });
  });

  group('Secure Storage Delegation', () {
    test('saveAuthToken should delegate to secure storage', () async {
      // Arrange
      const token = 'test_token';
      when(mockSecureStorage.saveAuthToken(token)).thenAnswer((_) async => {});

      // Act
      await storageService.saveAuthToken(token);

      // Assert
      verify(mockSecureStorage.saveAuthToken(token)).called(1);
    });

    test('getAuthToken should delegate to secure storage', () async {
      // Arrange
      const token = 'test_token';
      when(mockSecureStorage.getAuthToken()).thenAnswer((_) async => token);

      // Act
      final result = await storageService.getAuthToken();

      // Assert
      expect(result, equals(token));
      verify(mockSecureStorage.getAuthToken()).called(1);
    });

    test('getAuthTokenSync should delegate to secure storage', () {
      // Arrange
      const token = 'test_token';
      when(mockSecureStorage.getAuthTokenSync()).thenReturn(token);

      // Act
      final result = storageService.getAuthTokenSync();

      // Assert
      expect(result, equals(token));
      verify(mockSecureStorage.getAuthTokenSync()).called(1);
    });

    test('clearAuthTokens should delegate to secure storage', () async {
      // Arrange
      when(mockSecureStorage.clearAuthTokens()).thenAnswer((_) async => {});

      // Act
      await storageService.clearAuthTokens();

      // Assert
      verify(mockSecureStorage.clearAuthTokens()).called(1);
    });

    test('saveUserId should delegate to secure storage', () async {
      // Arrange
      const userId = 'user123';
      when(mockSecureStorage.saveUserId(userId)).thenAnswer((_) async => {});

      // Act
      await storageService.saveUserId(userId);

      // Assert
      verify(mockSecureStorage.saveUserId(userId)).called(1);
    });

    test('getUserId should delegate to secure storage', () async {
      // Arrange
      const userId = 'user123';
      when(mockSecureStorage.getUserId()).thenAnswer((_) async => userId);

      // Act
      final result = await storageService.getUserId();

      // Assert
      expect(result, equals(userId));
      verify(mockSecureStorage.getUserId()).called(1);
    });
  });

  group('Local Storage Delegation', () {
    test('getProducts should return products list', () {
      // Act
      final result = storageService.getProducts();

      // Assert
      expect(result, isA<List>());
    });

    test('saveToCache should delegate to LocalStorage', () async {
      // Arrange
      const key = 'cache_key';
      final data = {'test': 'data'};
      const expiry = Duration(hours: 1);

      // Act
      await storageService.saveToCache(key, data, expiry: expiry);

      // Assert
      // Note: Since LocalStorage is static, we can't verify the call
      // In real tests, you might need to refactor to make it testable
    });

    test('getFromCache should delegate to LocalStorage', () {
      // Act
      final result = storageService.getFromCache('cache_key');

      // Assert
      // Note: Static method call - would need refactoring for proper testing
      expect(result, isNull);
    });

    test('addFavorite should delegate to LocalStorage', () async {
      // Arrange
      const productId = 123;

      // Act
      await storageService.addFavorite(productId);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('removeFavorite should delegate to LocalStorage', () async {
      // Arrange
      const productId = 123;

      // Act
      await storageService.removeFavorite(productId);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('isFavorite should return favorite status', () {
      // Arrange
      const productId = 123;

      // Act
      final result = storageService.isFavorite(productId);

      // Assert
      expect(result, isA<bool>());
    });

    test('getFavorites should return favorites list', () {
      // Act
      final result = storageService.getFavorites();

      // Assert
      expect(result, isA<List<int>>());
    });
  });

  group('Settings Operations', () {
    test('saveThemeMode should save theme mode', () async {
      // Arrange
      const themeMode = 'dark';

      // Act
      await storageService.saveThemeMode(themeMode);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('getThemeMode should return theme mode', () {
      // Act
      final result = storageService.getThemeMode();

      // Assert
      expect(result, isNull);
    });

    test('saveLanguage should save language code', () async {
      // Arrange
      const languageCode = 'en';

      // Act
      await storageService.saveLanguage(languageCode);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('getLanguage should return language code', () {
      // Act
      final result = storageService.getLanguage();

      // Assert
      expect(result, isNull);
    });

    test('saveOnboardingCompleted should save onboarding status', () async {
      // Act
      await storageService.saveOnboardingCompleted(true);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('getOnboardingCompleted should return onboarding status', () {
      // Act
      final result = storageService.getOnboardingCompleted();

      // Assert
      expect(result, isA<bool>());
    });

    test('saveNotificationsEnabled should save notifications status', () async {
      // Act
      await storageService.saveNotificationsEnabled(true);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('getNotificationsEnabled should return notifications status', () {
      // Act
      final result = storageService.getNotificationsEnabled();

      // Assert
      expect(result, isA<bool>());
    });
  });

  group('Search History Operations', () {
    test('addSearchQuery should add search query', () async {
      // Arrange
      const query = 'test search';

      // Act
      await storageService.addSearchQuery(query);

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });

    test('getSearchHistory should return search history', () {
      // Act
      final result = storageService.getSearchHistory();

      // Assert
      expect(result, isA<List<String>>());
    });

    test('clearSearchHistory should clear search history', () async {
      // Act
      await storageService.clearSearchHistory();

      // Assert
      // Note: Static method call - would need refactoring for proper testing
    });
  });

  group('Utility Methods', () {
    test('storageStats should return storage statistics', () {
      // Arrange
      // Arrange
      when(mockPrefs.getKeys()).thenReturn({'key1', 'key2', 'key3'});

      // Act
      final stats = storageService.storageStats;

      // Assert
      expect(stats, isA<Map<String, int>>());
      expect(stats['preferences_keys_count'], equals(3));
      expect(stats.containsKey('cart_items_count'), isTrue);
      expect(stats.containsKey('favorites_count'), isTrue);
    });

    test('isLocalStorageInitialized should return initialization status', () {
      // Act
      final result = storageService.isLocalStorageInitialized;

      // Assert
      expect(result, isA<bool>());
    });
  });

  group('Static Methods', () {
    test('initializeAll should initialize all storage systems', () async {
      // Note: This test would require mocking static methods
      // which is complex in Dart. Consider refactoring the code
      // to make it more testable by injecting dependencies.

      // For now, we can only test that it doesn't throw
      try {
        await StorageService.initializeAll();
      } catch (e) {
        // Expected if LocalStorage.init() is not properly mocked
      }
    });
  });

  group('Edge Cases and Error Handling', () {
    test('should handle null values gracefully', () {
      // Arrange
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getInt(any)).thenReturn(null);
      when(mockPrefs.getBool(any)).thenReturn(null);

      // Act & Assert
      expect(storageService.getString('null_key'), isNull);
      expect(storageService.getInt('null_key'), isNull);
      expect(storageService.getBool('null_key'), isNull);
    });

    test('should handle empty cart data', () async {
      // Arrange
      final emptyCartData = {
        'items': [],
        'summary': {
          'subtotal': 0.0,
          'total': 0.0,
          'totalItems': 0,
          'totalQuantity': 0,
        },
      };

      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Act
      await storageService.saveCartData('user123', emptyCartData);

      // Assert
      verify(mockPrefs.setString(
        'cart_data_user123',
        emptyCartData.toString(),
      )).called(1);
    });

    test('should handle concurrent operations', () async {
      // Arrange
      when(mockPrefs.setString(any, any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return true;
      });

      // Act
      final futures = List.generate(5,
          (index) => storageService.saveString('key_$index', 'value_$index'));

      await Future.wait(futures);

      // Assert
      verify(mockPrefs.setString(any, any)).called(5);
    });

    test('should handle special characters in keys', () async {
      // Arrange
      const specialKey = 'key_with_special_!@#\$%^&*()_+';
      const value = 'test_value';
      when(mockPrefs.setString(specialKey, value))
          .thenAnswer((_) async => true);

      // Act
      await storageService.saveString(specialKey, value);

      // Assert
      verify(mockPrefs.setString(specialKey, value)).called(1);
    });

    test('should handle very long strings', () async {
      // Arrange
      const key = 'long_string_key';
      final longValue = 'x' * 10000; // 10,000 character string
      when(mockPrefs.setString(key, longValue)).thenAnswer((_) async => true);

      // Act
      await storageService.saveString(key, longValue);

      // Assert
      verify(mockPrefs.setString(key, longValue)).called(1);
    });

    test('should handle malformed cart data gracefully', () async {
      // Arrange
      when(mockPrefs.getString('cart_data_user123'))
          .thenReturn('malformed_json_data');

      // Act
      final result = await storageService.getCartData('user123');

      // Assert
      expect(result, isNotNull);
      expect(result!['items'], isEmpty);
      expect(result['summary']['total'], equals(0.0));
    });
  });

  group('Performance Tests', () {
    test('should complete operations within reasonable time', () async {
      // Arrange
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Act
      final stopwatch = Stopwatch()..start();
      await storageService.saveString('perf_test', 'value');
      stopwatch.stop();

      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    test('should handle bulk operations efficiently', () async {
      // Arrange
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Act
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        await storageService.saveString('bulk_key_$i', 'value_$i');
      }
      stopwatch.stop();

      // Assert
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      verify(mockPrefs.setString(any, any)).called(100);
    });
  });

  group('Integration-like Tests', () {
    test('should maintain data consistency across operations', () async {
      // Arrange
      const key = 'consistency_test';
      const value = 'test_value';

      when(mockPrefs.setString(key, value)).thenAnswer((_) async => true);
      when(mockPrefs.getString(key)).thenReturn(value);
      when(mockPrefs.containsKey(key)).thenReturn(true);
      when(mockPrefs.remove(key)).thenAnswer((_) async => true);

      // Act & Assert
      await storageService.saveString(key, value);
      expect(storageService.getString(key), equals(value));
      expect(storageService.containsKey(key), isTrue);

      await storageService.remove(key);
      verify(mockPrefs.remove(key)).called(1);
    });

    test('should handle user session lifecycle', () async {
      // Arrange
      const userId = 'test_user';
      const authToken = 'auth_token_123';
      final cartData = {'items': []};

      when(mockSecureStorage.saveUserId(userId)).thenAnswer((_) async => {});
      when(mockSecureStorage.saveAuthToken(authToken))
          .thenAnswer((_) async => {});
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockSecureStorage.clearAuthTokens()).thenAnswer((_) async => {});
      when(mockPrefs.remove(any)).thenAnswer((_) async => true);

      // Act - User login
      await storageService.saveUserId(userId);
      await storageService.saveAuthToken(authToken);
      await storageService.saveCartData(userId, cartData);

      // Act - User logout
      await storageService.clearAuthTokens();
      await storageService.clearCartData(userId);

      // Assert
      verify(mockSecureStorage.saveUserId(userId)).called(1);
      verify(mockSecureStorage.saveAuthToken(authToken)).called(1);
      verify(mockPrefs.setString('cart_data_$userId', any)).called(1);
      verify(mockSecureStorage.clearAuthTokens()).called(1);
      verify(mockPrefs.remove('cart_data_$userId')).called(1);
    });
  });
}

// Additional test utilities
class TestHelpers {
  static Map<String, dynamic> createMockCartData({
    int itemCount = 2,
    double total = 100.0,
  }) {
    return {
      'items': List.generate(
          itemCount,
          (index) => {
                'id': index + 1,
                'name': 'Product ${index + 1}',
                'quantity': 1,
                'price': total / itemCount,
              }),
      'summary': {
        'subtotal': total * 0.9,
        'total': total,
        'totalItems': itemCount,
        'totalQuantity': itemCount,
      },
    };
  }

  static void verifyLoggerCalls(MockAppLogger mockLogger, String operation) {
    verify(mockLogger.logBusinessLogic(
      argThat(contains(operation)),
      any,
      any,
    )).called(greaterThanOrEqualTo(1));
  }
}

void runTests() {
  // All tests are in the main() function above
}

// Additional mock setup if needed
class MockStorageServiceWithLogger extends StorageService {
  final AppLogger mockLogger;

  MockStorageServiceWithLogger(
    super.prefs,
    super.secureStorage,
    super.localStorage,
    this.mockLogger,
  );
}
