class AppConstants {
  // App Information
  static const String appName = 'Scalable E-Commerce';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Storage Keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguageCode = 'language_code';
  static const String keyCountryCode = 'country_code';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyBiometricsEnabled = 'biometrics_enabled';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyCartItems = 'cart_items';
  static const String keyFavoriteItems = 'favorite_items';
  static const String keySearchHistory = 'search_history';
  static const String keyRecentlyViewed = 'recently_viewed';

  // Hive Box Names
  static const String boxProducts = 'products_box';
  static const String boxCart = 'cart_box';
  static const String boxFavorites = 'favorites_box';
  static const String boxSettings = 'settings_box';
  static const String boxCache = 'cache_box';
  static const String boxUser = 'user_box';
  static const String boxSearch = 'search_box';

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  static const Duration animationDurationSplash = Duration(milliseconds: 2000);

  // Debounce Durations
  static const Duration debounceDurationSearch = Duration(milliseconds: 500);
  static const Duration debounceDurationFilter = Duration(milliseconds: 300);

  // Cache Durations
  static const Duration cacheDurationShort = Duration(minutes: 5);
  static const Duration cacheDurationMedium = Duration(minutes: 30);
  static const Duration cacheDurationLong = Duration(hours: 24);
  static const Duration cacheDurationProducts = Duration(hours: 1);
  static const Duration cacheDurationCategories = Duration(hours: 12);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int preloadThreshold = 3; // Load more when 3 items from end

  // Image Sizes
  static const double imageQualityLow = 0.5;
  static const double imageQualityMedium = 0.7;
  static const double imageQualityHigh = 0.9;
  static const int imageCacheWidth = 300;
  static const int imageCacheHeight = 300;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;
  static const double listItemHeight = 80.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;

  // Grid Constants
  static const int gridCrossAxisCountPortrait = 2;
  static const int gridCrossAxisCountLandscape = 3;
  static const double gridChildAspectRatio = 0.75;
  static const double gridSpacing = 16.0;

  // Search Constants
  static const int maxSearchHistoryItems = 10;
  static const int minSearchLength = 2;
  static const int maxSearchSuggestions = 5;

  // Cart Constants
  static const int maxCartItems = 99;
  static const int minQuantity = 1;
  static const int maxQuantity = 10;

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your connection.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorNotFound = 'The requested resource was not found.';
  static const String errorUnauthorized = 'You are not authorized to perform this action.';
  static const String errorValidation = 'Please check your input and try again.';
  static const String errorCacheExpired = 'Data is outdated. Refreshing...';

  // Success Messages
  static const String successLogin = 'Welcome back!';
  static const String successLogout = 'You have been logged out successfully.';
  static const String successSignup = 'Account created successfully!';
  static const String successAddToCart = 'Item added to cart.';
  static const String successRemoveFromCart = 'Item removed from cart.';
  static const String successAddToFavorites = 'Added to favorites.';
  static const String successRemoveFromFavorites = 'Removed from favorites.';
  static const String successProfileUpdate = 'Profile updated successfully.';
  static const String successPasswordChange = 'Password changed successfully.';

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'ar'];
  static const String defaultLanguage = 'en';

  // Supported Countries
  static const List<String> supportedCountries = ['US', 'EG', 'SA', 'AE'];
  static const String defaultCountry = 'US';

  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$';

  // External URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://example.com/terms-of-service';
  static const String supportUrl = 'https://example.com/support';
  static const String githubUrl = 'https://github.com/roshdology123/scalable-ecommerce';

  // Push Notification Topics
  static const String notificationTopicAll = 'all_users';
  static const String notificationTopicOffers = 'offers';
  static const String notificationTopicNewProducts = 'new_products';
  static const String notificationTopicOrderUpdates = 'order_updates';

  // Feature Flags
  static const bool enableBiometrics = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableOfflineMode = true;
  static const bool enableDarkMode = true;
  static const bool enableMultiLanguage = true;

  // Environment
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  static const bool isProduction = environment == 'production';
  static const bool isDevelopment = environment == 'development';
  static const bool isStaging = environment == 'staging';

  // Logging
  static const bool enableLogging = !isProduction;
  static const String logFileName = 'app_logs.txt';
  static const int maxLogFileSize = 5 * 1024 * 1024; // 5MB


// Profile Cache Keys
  static const String keyCachedProfile = 'cached_profile';
  static const String keyCachedUserPreferences = 'cached_user_preferences';
  static const String keyCachedProfileStats = 'cached_profile_stats';

  // Profile Settings Keys
  static const String keyProfileImageUrl = 'profile_image_url';
  static const String keyProfileBio = 'profile_bio';
  static const String keyProfileCompleted = 'profile_completed';

  // User Session Keys
  static const String keyCurrentUserId = 'current_user_id';
  static const String keyCurrentUsername = 'current_username';
  static const String keyLastProfileUpdate = 'last_profile_update';

  // Profile Cache Expiry
  static const Duration profileCacheExpiry = Duration(hours: 24);
  static const Duration preferencesCacheExpiry = Duration(days: 7);
  static const Duration statsCacheExpiry = Duration(hours: 6);

  // Current User Info (roshdology123)
  static const String currentUserId = '11';
  static const String currentUsername = 'roshdology123';
  static const String currentUserEmail = 'roshdology123@example.com';
}