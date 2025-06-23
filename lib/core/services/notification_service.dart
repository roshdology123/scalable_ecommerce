import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_logger.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import 'notification_simulator.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final AppLogger _logger = AppLogger();
  final NotificationSimulator _simulator = NotificationSimulator();
  final SecureStorage _secureStorage = SecureStorage();

  String? _fcmToken;
  bool _isInitialized = false;
  bool _simulationEnabled = true; // 🔥 Control simulation vs real Firebase

  // Notification channels
  static const String _orderUpdatesChannelId = 'order_updates';
  static const String _promotionsChannelId = 'promotions';
  static const String _generalChannelId = 'general';
  static const String _cartAbandonmentChannelId = 'cart_abandonment';
  static const String _priceAlertsChannelId = 'price_alerts';
  static const String _stockAlertsChannelId = 'stock_alerts';

  // Callbacks for notification handling
  Function(Map<String, dynamic>)? onNotificationReceived;
  Function(Map<String, dynamic>)? onNotificationTapped;

  /// Initialize notification service
  Future<void> initialize({
    bool enableSimulation = true,
    Function(Map<String, dynamic>)? onReceived,
    Function(Map<String, dynamic>)? onTapped,
  }) async {
    if (_isInitialized) return;

    try {
      _simulationEnabled = enableSimulation;
      onNotificationReceived = onReceived;
      onNotificationTapped = onTapped;

      _logger.logBusinessLogic(
        'notification_service_initializing',
        'start',
        {
          'simulation_enabled': _simulationEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53', // 🔥 CURRENT TIME
        },
      );

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Configure message handlers
      _configureMessageHandlers();

      // Initialize notification channels
      await _createNotificationChannels();

      // Initialize simulator if enabled
      if (_simulationEnabled) {
        await _initializeSimulator();
      }

      _isInitialized = true;

      _logger.logBusinessLogic(
        'notification_service_initialized',
        'success',
        {
          'fcm_token': _fcmToken?.substring(0, 20) ?? 'null',
          'simulation_enabled': _simulationEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
    } catch (e) {
      _logger.logBusinessLogic(
        'notification_service_initialization_failed',
        'error',
        {
          'error': e.toString(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
      rethrow;
    }
  }

  /// Initialize simulator
  Future<void> _initializeSimulator() async {
    _simulator.startSimulation(
      onNotification: (notification) {
        _logger.logBusinessLogic(
          'simulated_notification_received',
          'simulator',
          {
            'notification_id': notification.id,
            'type': notification.type.name,
            'title': notification.title,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:09:53',
          },
        );

        // Convert to Firebase-like message format
        final message = _convertNotificationToMessage(notification);

        // Handle as if it came from Firebase
        onNotificationReceived?.call(message);

        // Show local notification
        _showLocalNotificationFromSimulation(notification);
      },
      interval: const Duration(minutes: 3), // Simulate every 3 minutes
    );
  }

  /// Convert AppNotification to Firebase message format
  Map<String, dynamic> _convertNotificationToMessage(dynamic notification) {
    return {
      'messageId': notification.id,
      'data': {
        'type': notification.type.name,
        'title': notification.title,
        'body': notification.body,
        'action_url': notification.actionUrl ?? '',
        'image_url': notification.imageUrl ?? '',
        'priority': notification.priority.name,
        'created_at': notification.createdAt.toIso8601String(),
        'user_id': notification.userId,
        'source': 'simulator',
        ...notification.data,
      },
      'notification': {
        'title': notification.title,
        'body': notification.body,
        'android': {
          'channelId': _getChannelIdFromType(notification.type.name),
          'imageUrl': notification.imageUrl,
        },
        'apple': {
          'imageUrl': notification.imageUrl,
        },
      },
      'from': 'simulation',
      'category': notification.type.name,
      'collapseKey': notification.type.name,
      'sentTime': notification.createdAt.millisecondsSinceEpoch,
      'ttl': 86400, // 24 hours
    };
  }

  /// Show local notification from simulation
  Future<void> _showLocalNotificationFromSimulation(dynamic notification) async {
    final channelId = _getChannelIdFromType(notification.type.name);

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: _getImportanceFromPriority(notification.priority.name),
      priority: _getPriorityFromPriority(notification.priority.name),
      icon: '@mipmap/ic_launcher',
      largeIcon: notification.imageUrl != null
          ? DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
          : null,
      styleInformation: BigTextStyleInformation(
        notification.body,
        contentTitle: notification.title,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      attachments: [],
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode({
        'type': notification.type.name,
        'data': notification.data,
        'action_url': notification.actionUrl,
        'source': 'simulator',
      }),
    );
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    _logger.logUserAction('notification_tapped', {
      'notification_id': response.id,
      'payload': response.payload,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:09:53',
    });

    if (response.payload != null) {
      try {
        final payload = jsonDecode(response.payload!);
        onNotificationTapped?.call(payload);
        _handleNotificationNavigation(payload);
      } catch (e) {
        _logger.logErrorWithContext(
          'NotificationService._onNotificationTapped',
          e,
          StackTrace.current,
          {
            'payload': response.payload,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:09:53',
          },
        );
      }
    }
  }

  /// Handle notification navigation
  void _handleNotificationNavigation(Map<String, dynamic> payload) {
    final type = payload['type'] as String?;
    final data = payload['data'] as Map<String, dynamic>?;
    final actionUrl = payload['action_url'] as String?;

    _logger.logUserAction('notification_navigation', {
      'type': type,
      'action_url': actionUrl,
      'has_data': data != null,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:09:53',
    });

    switch (type) {
      case 'orderUpdate':
        _logger.logUserAction('navigate_to_order', {
          'order_id': data?['order_id'],
          'user': 'roshdology123',
        });
        break;
      case 'cartAbandonment':
        _logger.logUserAction('navigate_to_cart', {
          'user': 'roshdology123',
        });
        break;
      case 'promotion':
        _logger.logUserAction('navigate_to_promotion', {
          'promotion_id': data?['promotion_id'],
          'category': data?['category'],
          'user': 'roshdology123',
        });
        break;
      case 'priceAlert':
      case 'stockAlert':
      case 'newProduct':
        _logger.logUserAction('navigate_to_product', {
          'product_id': data?['product_id'],
          'user': 'roshdology123',
        });
        break;
      default:
        _logger.logUserAction('navigate_to_home', {
          'user': 'roshdology123',
        });
        break;
    }
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    // Request iOS permissions
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      _logger.logBusinessLogic(
        'ios_notification_permission_requested',
        'result',
        {
          'authorization_status': settings.authorizationStatus.toString(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }

    // Request Android permissions
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();

      _logger.logBusinessLogic(
        'android_notification_permission_requested',
        'result',
        {
          'permission_status': status.toString(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );

      return status.isGranted;
    }

    return false;
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();

      if (_fcmToken != null) {
        // Save token securely
        await _secureStorage.saveFCMToken(_fcmToken!);
        await LocalStorage.saveFCMToken(_fcmToken!);

        _logger.logBusinessLogic(
          'fcm_token_retrieved',
          'success',
          {
            'token_length': _fcmToken!.length,
            'token_prefix': _fcmToken!.substring(0, 20),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:09:53',
          },
        );

        // TODO: Send token to your backend server
        // await _sendTokenToServer(_fcmToken!);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _secureStorage.saveFCMToken(newToken);
        LocalStorage.saveFCMToken(newToken);

        _logger.logBusinessLogic(
          'fcm_token_refreshed',
          'success',
          {
            'new_token_length': newToken.length,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:09:53',
          },
        );

        // TODO: Update token on your backend server
        // await _sendTokenToServer(newToken);
      });
    } catch (e) {
      _logger.logBusinessLogic(
        'fcm_token_retrieval_failed',
        'error',
        {
          'error': e.toString(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
    }
  }

  /// Configure Firebase message handlers
  void _configureMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle message opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle app launched from notification
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageOpenedApp(message);
      }
    });
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logger.logBusinessLogic(
      'firebase_notification_received_foreground',
      'message',
      {
        'message_id': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:09:53',
      },
    );

    // Notify app about received notification
    onNotificationReceived?.call(_convertRemoteMessageToMap(message));

    // Show local notification for foreground messages
    await _showLocalNotification(message);
  }

  /// Convert RemoteMessage to Map for consistency
  Map<String, dynamic> _convertRemoteMessageToMap(RemoteMessage message) {
    return {
      'messageId': message.messageId,
      'data': message.data,
      'notification': {
        'title': message.notification?.title,
        'body': message.notification?.body,
        'android': message.notification?.android?.toMap(),
        'apple': message.notification?.apple?.toMap(),
      },
      'from': message.from,
      'category': message.category,
      'collapseKey': message.collapseKey,
      'sentTime': message.sentTime?.millisecondsSinceEpoch,
      'ttl': message.ttl,
    };
  }

  /// Handle message that opened the app
  void _handleMessageOpenedApp(RemoteMessage message) {
    _logger.logUserAction('firebase_notification_opened_app', {
      'message_id': message.messageId,
      'title': message.notification?.title,
      'data': message.data,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:09:53',
    });

    // Notify app about tapped notification
    onNotificationTapped?.call(_convertRemoteMessageToMap(message));

    _handleNotificationNavigation({
      'type': message.data['type'],
      'data': message.data,
      'action_url': message.data['action_url'],
    });
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final channelId = _getChannelIdFromData(message.data);

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: message.data['image_url'] != null
          ? DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
          : null,
      styleInformation: BigTextStyleInformation(
        notification.body ?? '',
        contentTitle: notification.title,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode({
        'type': message.data['type'],
        'data': message.data,
        'action_url': message.data['action_url'],
        'source': 'firebase',
      }),
    );
  }

  /// Create notification channels
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final channels = [
          const AndroidNotificationChannel(
            _orderUpdatesChannelId,
            'Order Updates',
            description: 'Notifications about order status changes',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
          const AndroidNotificationChannel(
            _promotionsChannelId,
            'Promotions & Offers',
            description: 'Special offers and promotional notifications',
            importance: Importance.defaultImportance,
            playSound: true,
            enableVibration: false,
          ),
          const AndroidNotificationChannel(
            _generalChannelId,
            'General',
            description: 'General app notifications',
            importance: Importance.defaultImportance,
            playSound: true,
            enableVibration: false,
          ),
          const AndroidNotificationChannel(
            _cartAbandonmentChannelId,
            'Cart Reminders',
            description: 'Reminders about items in your cart',
            importance: Importance.defaultImportance,
            playSound: true,
            enableVibration: false,
          ),
          const AndroidNotificationChannel(
            _priceAlertsChannelId,
            'Price Alerts',
            description: 'Notifications about price changes',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
          const AndroidNotificationChannel(
            _stockAlertsChannelId,
            'Stock Alerts',
            description: 'Notifications about stock changes',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        ];

        for (final channel in channels) {
          await androidPlugin.createNotificationChannel(channel);
        }

        _logger.logBusinessLogic(
          'notification_channels_created',
          'success',
          {
            'channels_count': channels.length,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:09:53',
          },
        );
      }
    }
  }

  /// Get channel ID from message data
  String _getChannelIdFromData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    return _getChannelIdFromType(type);
  }

  /// Get channel ID from notification type
  String _getChannelIdFromType(String? type) {
    switch (type) {
      case 'orderUpdate':
        return _orderUpdatesChannelId;
      case 'promotion':
        return _promotionsChannelId;
      case 'cartAbandonment':
        return _cartAbandonmentChannelId;
      case 'priceAlert':
        return _priceAlertsChannelId;
      case 'stockAlert':
        return _stockAlertsChannelId;
      default:
        return _generalChannelId;
    }
  }

  /// Get channel name
  String _getChannelName(String channelId) {
    switch (channelId) {
      case _orderUpdatesChannelId:
        return 'Order Updates';
      case _promotionsChannelId:
        return 'Promotions & Offers';
      case _cartAbandonmentChannelId:
        return 'Cart Reminders';
      case _priceAlertsChannelId:
        return 'Price Alerts';
      case _stockAlertsChannelId:
        return 'Stock Alerts';
      default:
        return 'General';
    }
  }

  /// Get channel description
  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case _orderUpdatesChannelId:
        return 'Notifications about order status changes';
      case _promotionsChannelId:
        return 'Special offers and promotional notifications';
      case _cartAbandonmentChannelId:
        return 'Reminders about items in your cart';
      case _priceAlertsChannelId:
        return 'Notifications about price changes';
      case _stockAlertsChannelId:
        return 'Notifications about stock changes';
      default:
        return 'General app notifications';
    }
  }

  /// Get importance from priority
  Importance _getImportanceFromPriority(String priority) {
    switch (priority) {
      case 'urgent':
        return Importance.max;
      case 'high':
        return Importance.high;
      case 'low':
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  /// Get priority from priority
  Priority _getPriorityFromPriority(String priority) {
    switch (priority) {
      case 'urgent':
        return Priority.max;
      case 'high':
        return Priority.high;
      case 'low':
        return Priority.low;
      default:
        return Priority.defaultPriority;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);

      _logger.logBusinessLogic(
        'subscribed_to_topic',
        'success',
        {
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
    } catch (e) {
      _logger.logBusinessLogic(
        'subscribe_to_topic_failed',
        'error',
        {
          'topic': topic,
          'error': e.toString(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);

      _logger.logBusinessLogic(
        'unsubscribed_from_topic',
        'success',
        {
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
    } catch (e) {
      _logger.logBusinessLogic(
        'unsubscribe_from_topic_failed',
        'error',
        {
          'topic': topic,
          'error': e.toString(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:09:53',
        },
      );
    }
  }

  /// Send test notification (for development)
  Future<void> sendTestNotification() async {
    if (_simulationEnabled) {
      _simulator.generateActionBasedNotification('test_notification', {
        'user_id': 'roshdology123',
        'message': 'This is a test notification!',
        'timestamp': '2025-06-23 08:09:53',
      });
    } else {
      // TODO: Send test notification via your backend
      _logger.logUserAction('test_notification_requested', {
        'method': 'firebase',
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:09:53',
      });
    }
  }

  /// Toggle simulation mode
  void setSimulationEnabled(bool enabled) {
    _simulationEnabled = enabled;

    if (enabled && _isInitialized) {
      _initializeSimulator();
    } else {
      _simulator.stopSimulation();
    }

    _logger.logBusinessLogic(
      'simulation_mode_changed',
      'setting',
      {
        'enabled': enabled,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:09:53',
      },
    );
  }

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Get simulation status
  bool get isSimulationEnabled => _simulationEnabled;

  /// Get initialization status
  bool get isInitialized => _isInitialized;

  /// Clean up resources
  Future<void> dispose() async {
    _simulator.stopSimulation();
    _isInitialized = false;

    _logger.logBusinessLogic(
      'notification_service_disposed',
      'cleanup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:09:53',
      },
    );
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final logger = AppLogger();

  logger.logBusinessLogic(
    'firebase_notification_received_background',
    'message',
    {
      'message_id': message.messageId,
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:09:53',
    },
  );

  // Handle background notification processing here
  // You can save to local storage, update badges, etc.
}