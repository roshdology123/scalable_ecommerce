import 'dart:async';
import 'dart:math';

import '../utils/app_logger.dart';
import '../../features/notifications/domain/entities/notification.dart';

class NotificationSimulator {
  static final NotificationSimulator _instance = NotificationSimulator._internal();
  factory NotificationSimulator() => _instance;
  NotificationSimulator._internal();

  final AppLogger _logger = AppLogger();
  final Random _random = Random();

  Timer? _simulationTimer;
  bool _isSimulating = false;

  // Callback to handle generated notifications
  Function(AppNotification)? onNotificationGenerated;

  /// Start simulating notifications
  void startSimulation({
    Function(AppNotification)? onNotification,
    Duration interval = const Duration(minutes: 3),
  }) {
    if (_isSimulating) return;

    onNotificationGenerated = onNotification;
    _isSimulating = true;

    _logger.logBusinessLogic(
      'notification_simulation_started',
      'simulator',
      {
        'interval_minutes': interval.inMinutes,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:13:54', // 🔥 UPDATED TO CURRENT TIME
      },
    );

    // Generate an initial welcome notification
    Timer(const Duration(seconds: 5), () => _generateWelcomeNotification());

    // Start periodic simulation
    _simulationTimer = Timer.periodic(interval, (timer) {
      _generateRandomNotification();
    });

    // Generate some scheduled notifications for testing
    Timer(const Duration(seconds: 30), () => _generateCartAbandonmentNotification());
    Timer(const Duration(minutes: 1), () => _generatePromotionalNotification());
    Timer(const Duration(minutes: 2), () => _generateNewProductNotification());
    Timer(const Duration(minutes: 4), () => _generatePriceAlertNotification());
  }

  /// Stop simulation
  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _isSimulating = false;
    onNotificationGenerated = null;

    _logger.logBusinessLogic(
      'notification_simulation_stopped',
      'simulator',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:13:54',
      },
    );
  }

  /// Generate welcome notification with Firebase-like structure
  void _generateWelcomeNotification() {
    final notification = AppNotification(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      title: '🎉 Welcome to FakeStore!',
      body: 'Thanks for joining us, roshdology123! Explore our amazing products and exclusive deals.',
      type: NotificationType.general,
      priority: NotificationPriority.normal,
      data: {
        'action': 'navigate_to_products',
        'category': 'welcome',
        'user_id': 'roshdology123',
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'welcome_series',
        'firebase_tracking': {
          'message_id': 'welcome_msg_001',
          'campaign_id': 'new_user_onboarding',
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=👋',
      actionUrl: '/products',
    );

    _sendNotification(notification);
  }

  /// Generate promotional notification
  void _generatePromotionalNotification() {
    final promotions = [
      {
        'title': '🔥 Flash Sale Alert!',
        'body': '50% OFF on Electronics! Limited time offer ending in 6 hours. Shop now!',
        'category': 'electronics',
        'discount': 50,
        'icon': '🔥',
        'urgency': 'high',
        'campaign_id': 'flash_sale_electronics',
      },
      {
        'title': '👗 Fashion Week Special',
        'body': 'Get 30% OFF on all clothing items. Trendy styles await! Free shipping included.',
        'category': "women's clothing",
        'discount': 30,
        'icon': '👗',
        'urgency': 'medium',
        'campaign_id': 'fashion_week_2025',
      },
      {
        'title': '💎 Jewelry Collection Sale',
        'body': 'Exclusive 40% discount on premium jewelry. Shine bright with our latest collection!',
        'category': 'jewelery',
        'discount': 40,
        'icon': '💎',
        'urgency': 'medium',
        'campaign_id': 'jewelry_summer_sale',
      },
      {
        'title': '📱 Tech Deals of the Day',
        'body': 'Massive savings on smartphones, laptops, and gadgets. Don\'t miss out!',
        'category': 'electronics',
        'discount': 25,
        'icon': '📱',
        'urgency': 'high',
        'campaign_id': 'tech_daily_deals',
      },
    ];

    final promo = promotions[_random.nextInt(promotions.length)];

    final notification = AppNotification(
      id: 'promo_${DateTime.now().millisecondsSinceEpoch}',
      title: promo['title'] as String,
      body: promo['body'] as String,
      type: NotificationType.promotion,
      priority: (promo['urgency'] as String) == 'high'
          ? NotificationPriority.high
          : NotificationPriority.normal,
      data: {
        'action': 'navigate_to_category',
        'category': promo['category'],
        'discount': promo['discount'],
        'promotion_id': 'promo_${_random.nextInt(10000)}',
        'campaign_id': promo['campaign_id'],
        'expires_at': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': promo['campaign_id'],
        'firebase_tracking': {
          'message_id': 'promo_${promo['campaign_id']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': promo['campaign_id'],
          'ab_test_group': _random.nextBool() ? 'A' : 'B',
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/FF5722/FFFFFF?text=${promo['icon']}',
      actionUrl: '/products/category/${promo['category']}',
    );

    _sendNotification(notification);
  }

  /// Generate cart abandonment notification
  void _generateCartAbandonmentNotification() {
    final messages = [
      {
        'title': '🛒 Forgot Something?',
        'body': 'You have 3 items waiting in your cart. Complete your purchase now and save 10%!',
        'items': 3,
        'incentive': 'save_10_percent',
      },
      {
        'title': '⏰ Your Cart is Waiting',
        'body': 'Don\'t miss out! Your selected items might sell out soon. Only 2 left in stock!',
        'items': 2,
        'incentive': 'stock_warning',
      },
      {
        'title': '💔 Your Cart Misses You',
        'body': 'Complete your order and get FREE shipping on orders over \$50! Current total: \$67.99',
        'items': 1,
        'incentive': 'free_shipping',
      },
    ];

    final message = messages[_random.nextInt(messages.length)];

    final notification = AppNotification(
      id: 'cart_abandonment_${DateTime.now().millisecondsSinceEpoch}',
      title: message['title'] as String,
      body: message['body'] as String,
      type: NotificationType.cartAbandonment,
      priority: NotificationPriority.normal,
      data: {
        'action': 'navigate_to_cart',
        'cart_items_count': message['items'],
        'incentive_type': message['incentive'],
        'minimum_order': 50.0,
        'current_total': 67.99,
        'discount_code': 'COMEBACK10',
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'cart_abandonment',
        'firebase_tracking': {
          'message_id': 'cart_abandonment_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'cart_recovery_campaign',
          'user_segment': 'cart_abandoners',
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/2196F3/FFFFFF?text=🛒',
      actionUrl: '/cart',
    );

    _sendNotification(notification);
  }

  /// Generate new product notification
  void _generateNewProductNotification() {
    final products = [
      {
        'title': '🆕 New iPhone 15 Pro Max',
        'body': 'The latest iPhone with titanium design is now available! Pre-order yours today.',
        'category': 'electronics',
        'price': 1199.99,
        'product_id': 21,
        'sku': 'IPH15PM-128-TIT',
      },
      {
        'title': '👟 Nike Air Jordan Collection',
        'body': 'Fresh kicks just dropped! Limited edition sneakers available now. Get yours before they\'re gone!',
        'category': "men's clothing",
        'price': 179.99,
        'product_id': 22,
        'sku': 'NIKE-AJ-LE-2025',
      },
      {
        'title': '💍 Tiffany Diamond Ring',
        'body': 'Exquisite new jewelry piece added to our premium collection. Perfect for special occasions.',
        'category': 'jewelery',
        'price': 2899.99,
        'product_id': 23,
        'sku': 'TIF-DMD-RNG-001',
      },
    ];

    final product = products[_random.nextInt(products.length)];

    final notification = AppNotification(
      id: 'new_product_${DateTime.now().millisecondsSinceEpoch}',
      title: product['title'] as String,
      body: product['body'] as String,
      type: NotificationType.newProduct,
      priority: NotificationPriority.normal,
      data: {
        'action': 'navigate_to_product',
        'product_id': product['product_id'],
        'category': product['category'],
        'price': product['price'],
        'sku': product['sku'],
        'is_new': true,
        'launch_date': DateTime.parse('2025-06-23 08:13:54').toIso8601String(),
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'new_product_launch',
        'firebase_tracking': {
          'message_id': 'new_product_${product['product_id']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'new_product_notifications',
          'product_category': product['category'],
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=🆕',
      actionUrl: '/products/${product['product_id']}',
    );

    _sendNotification(notification);
  }

  /// Generate price alert notification
  void _generatePriceAlertNotification() {
    final alerts = [
      {
        'title': '📉 Price Drop Alert!',
        'body': 'MacBook Pro M3 is now 15% cheaper! Was \$1999, now \$1699.15. Limited time offer!',
        'product_id': 9,
        'old_price': 1999.00,
        'new_price': 1699.15,
        'discount': 15,
        'sku': 'MBP-M3-16-512',
        'category': 'electronics',
      },
      {
        'title': '💰 Great Deal Found!',
        'body': 'Samsung 65" QLED TV price dropped by \$300! Was \$1299, now \$999. Don\'t miss out!',
        'product_id': 10,
        'old_price': 1299.00,
        'new_price': 999.00,
        'discount': 23,
        'sku': 'SAM-QLED-65-2025',
        'category': 'electronics',
      },
    ];

    final alert = alerts[_random.nextInt(alerts.length)];

    final notification = AppNotification(
      id: 'price_alert_${DateTime.now().millisecondsSinceEpoch}',
      title: alert['title'] as String,
      body: alert['body'] as String,
      type: NotificationType.priceAlert,
      priority: NotificationPriority.high,
      data: {
        'action': 'navigate_to_product',
        'product_id': alert['product_id'],
        'old_price': alert['old_price'],
        'new_price': alert['new_price'],
        'discount_percentage': alert['discount'],
        'savings_amount': (alert['old_price'] as double) - (alert['new_price'] as double),
        'sku': alert['sku'],
        'category': alert['category'],
        'price_drop_date': DateTime.parse('2025-06-23 08:13:54').toIso8601String(),
        'expires_at': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'price_alerts',
        'firebase_tracking': {
          'message_id': 'price_alert_${alert['product_id']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'price_drop_alerts',
          'product_category': alert['category'],
          'alert_type': 'price_drop',
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/FF9800/FFFFFF?text=📉',
      actionUrl: '/products/${alert['product_id']}',
    );

    _sendNotification(notification);
  }

  /// 🔥 MISSING METHOD: Generate stock alert notification
  void _generateStockAlertNotification() {
    final alerts = [
      {
        'title': '⚠️ Low Stock Alert',
        'body': 'Only 3 units left of iPhone 14 Pro! Order now before it\'s sold out.',
        'product_id': 5,
        'stock_level': 3,
        'urgency': 'high',
        'alert_type': 'low_stock',
        'category': 'electronics',
      },
      {
        'title': '🔄 Back in Stock',
        'body': 'Good news! Nike Air Max Sneakers are back in stock. Get yours now!',
        'product_id': 12,
        'stock_level': 25,
        'urgency': 'medium',
        'alert_type': 'back_in_stock',
        'category': "men's clothing",
      },
      {
        'title': '📢 Final Stock Alert',
        'body': 'Last chance! Only 1 unit left of the Diamond Necklace. Don\'t miss out!',
        'product_id': 8,
        'stock_level': 1,
        'urgency': 'urgent',
        'alert_type': 'final_stock',
        'category': 'jewelery',
      },
      {
        'title': '🎯 Wishlist Item Available',
        'body': 'Great news! The Sony Headphones from your wishlist are back in stock.',
        'product_id': 15,
        'stock_level': 10,
        'urgency': 'medium',
        'alert_type': 'wishlist_available',
        'category': 'electronics',
      },
    ];

    final alert = alerts[_random.nextInt(alerts.length)];

    final notification = AppNotification(
      id: 'stock_alert_${DateTime.now().millisecondsSinceEpoch}',
      title: alert['title'] as String,
      body: alert['body'] as String,
      type: NotificationType.stockAlert,
      priority: _getPriorityFromUrgency(alert['urgency'] as String),
      data: {
        'action': 'navigate_to_product',
        'product_id': alert['product_id'],
        'stock_level': alert['stock_level'],
        'urgency': alert['urgency'],
        'alert_type': alert['alert_type'],
        'category': alert['category'],
        'is_back_in_stock': alert['alert_type'] == 'back_in_stock',
        'is_low_stock': alert['alert_type'] == 'low_stock',
        'is_final_stock': alert['alert_type'] == 'final_stock',
        'stock_updated_at': DateTime.parse('2025-06-23 08:13:54').toIso8601String(),
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'stock_alerts',
        'firebase_tracking': {
          'message_id': 'stock_alert_${alert['product_id']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'stock_notifications',
          'product_category': alert['category'],
          'alert_type': alert['alert_type'],
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/F44336/FFFFFF?text=⚠️',
      actionUrl: '/products/${alert['product_id']}',
    );

    _sendNotification(notification);
  }

  /// Generate order update notification (simulated)
  void _generateOrderUpdateNotification() {
    final updates = [
      {
        'title': '📦 Order Shipped!',
        'body': 'Great news! Your order #FS2025001 has been shipped via FedEx Express.',
        'status': 'shipped',
        'tracking': 'FDX123456789001',
        'eta': '2 business days',
        'carrier': 'FedEx',
        'order_id': 'FS2025001',
      },
      {
        'title': '✅ Order Delivered',
        'body': 'Your order #FS2025002 has been delivered successfully! Hope you love your new items.',
        'status': 'delivered',
        'tracking': 'UPS987654321002',
        'eta': 'completed',
        'carrier': 'UPS',
        'order_id': 'FS2025002',
      },
      {
        'title': '🔄 Order Processing',
        'body': 'Your order #FS2025003 is being carefully prepared for shipment. Estimated ship date: Tomorrow.',
        'status': 'processing',
        'tracking': null,
        'eta': '1-2 business days',
        'carrier': null,
        'order_id': 'FS2025003',
      },
    ];

    final update = updates[_random.nextInt(updates.length)];

    final notification = AppNotification(
      id: 'order_update_${DateTime.now().millisecondsSinceEpoch}',
      title: update['title'] as String,
      body: update['body'] as String,
      type: NotificationType.orderUpdate,
      priority: NotificationPriority.high,
      data: {
        'action': 'navigate_to_order',
        'order_id': update['order_id'],
        'status': update['status'],
        'tracking_number': update['tracking'],
        'estimated_delivery': update['eta'],
        'carrier': update['carrier'],
        'can_track': update['tracking'] != null,
        'order_date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'utm_source': 'push_notification',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'order_updates',
        'firebase_tracking': {
          'message_id': 'order_${update['order_id']}_${update['status']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'order_status_notifications',
          'order_status': update['status'],
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/673AB7/FFFFFF?text=📦',
      actionUrl: '/orders/${update['order_id']}',
    );

    _sendNotification(notification);
  }

  /// Generate a random notification
  void _generateRandomNotification() {
    final notificationTypes = [
      _generatePromotionalNotification,
      _generatePriceAlertNotification,
      _generateStockAlertNotification,
      _generateNewProductNotification,
      _generateCartAbandonmentNotification,
      _generateOrderUpdateNotification,
    ];

    final randomGenerator = notificationTypes[_random.nextInt(notificationTypes.length)];
    randomGenerator();
  }

  /// Send notification through callback
  void _sendNotification(AppNotification notification) {
    _logger.logBusinessLogic(
      'notification_generated',
      'simulator',
      {
        'notification_id': notification.id,
        'type': notification.type.name,
        'title': notification.title,
        'priority': notification.priority.name,
        'has_firebase_tracking': notification.data.containsKey('firebase_tracking'),
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:13:54',
      },
    );

    onNotificationGenerated?.call(notification);
  }

  /// Generate notification based on user action
  void generateActionBasedNotification(String action, Map<String, dynamic> context) {
    switch (action) {
      case 'cart_item_added':
        _generateCartItemAddedNotification(context);
        break;
      case 'product_viewed':
        _generateProductViewedNotification(context);
        break;
      case 'user_login':
        _generateLoginNotification();
        break;
      case 'wishlist_item_sale':
        _generateWishlistSaleNotification(context);
        break;
      case 'test_notification':
        _generateTestNotification(context);
        break;
    }
  }

  /// 🔥 MISSING METHOD: Generate cart item added confirmation
  void _generateCartItemAddedNotification(Map<String, dynamic> context) {
    final productTitle = context['product_title'] ?? 'Product';
    final quantity = context['quantity'] ?? 1;
    final price = context['price'] ?? 0.0;

    final notification = AppNotification(
      id: 'cart_added_${DateTime.now().millisecondsSinceEpoch}',
      title: '✅ Added to Cart',
      body: '$quantity x $productTitle added successfully! Total: \$${(price * quantity).toStringAsFixed(2)}',
      type: NotificationType.general,
      priority: NotificationPriority.low,
      data: {
        'action': 'navigate_to_cart',
        'product_id': context['product_id'],
        'product_title': productTitle,
        'quantity': quantity,
        'price': price,
        'total_price': price * quantity,
        'auto_dismiss': true,
        'dismiss_after': 3000, // 3 seconds
        'utm_source': 'app_action',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'cart_confirmations',
        'firebase_tracking': {
          'message_id': 'cart_add_${context['product_id']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'cart_action_confirmations',
          'product_id': context['product_id'],
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=✅',
      actionUrl: '/cart',
    );

    _sendNotification(notification);
  }

  /// 🔥 MISSING METHOD: Generate product viewed recommendation
  void _generateProductViewedNotification(Map<String, dynamic> context) {
    Timer(const Duration(minutes: 5), () {
      final productCategory = context['category'] ?? 'general';
      final productTitle = context['product_title'] ?? 'Product';

      final notification = AppNotification(
        id: 'recommendation_${DateTime.now().millisecondsSinceEpoch}',
        title: '💡 You Might Also Like',
        body: 'Based on viewing "$productTitle", check out similar $productCategory items with great deals!',
        type: NotificationType.general,
        priority: NotificationPriority.low,
        data: {
          'action': 'navigate_to_recommendations',
          'based_on_product': context['product_id'],
          'category': productCategory,
          'viewed_product_title': productTitle,
          'recommendation_type': 'viewed_based',
          'utm_source': 'app_behavior',
          'utm_medium': 'mobile_app',
          'utm_campaign': 'product_recommendations',
          'firebase_tracking': {
            'message_id': 'recommendation_${context['product_id']}_${DateTime.now().millisecondsSinceEpoch}',
            'campaign_id': 'behavioral_recommendations',
            'trigger_product_id': context['product_id'],
          },
        },
        createdAt: DateTime.parse('2025-06-23 08:13:54'),
        userId: 'roshdology123',
        imageUrl: 'https://via.placeholder.com/100x100/9C27B0/FFFFFF?text=💡',
        actionUrl: '/recommendations?based_on=${context['product_id']}',
      );

      _sendNotification(notification);
    });
  }

  /// 🔥 MISSING METHOD: Generate login notification
  void _generateLoginNotification() {
    final hour = DateTime.now().hour;
    String greeting = '🌅 Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = '☀️ Good Afternoon';
    } else if (hour >= 17) {
      greeting = '🌙 Good Evening';
    }

    final notification = AppNotification(
      id: 'login_${DateTime.now().millisecondsSinceEpoch}',
      title: '$greeting, roshdology123!',
      body: 'Welcome back! Check out new arrivals and exclusive deals waiting for you.',
      type: NotificationType.general,
      priority: NotificationPriority.low,
      data: {
        'action': 'navigate_to_home',
        'login_time': DateTime.parse('2025-06-23 08:13:54').toIso8601String(),
        'greeting_type': greeting,
        'auto_dismiss': true,
        'dismiss_after': 4000, // 4 seconds
        'utm_source': 'login_action',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'login_welcome',
        'firebase_tracking': {
          'message_id': 'login_welcome_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'login_confirmations',
          'login_hour': hour,
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/2196F3/FFFFFF?text=🔐',
      actionUrl: '/home',
    );

    _sendNotification(notification);
  }

  /// 🔥 MISSING METHOD: Generate wishlist sale notification
  void _generateWishlistSaleNotification(Map<String, dynamic> context) {
    final productTitle = context['product_title'] ?? 'Wishlist Item';
    final originalPrice = context['price'] as double? ?? 100.0;
    final discountPercent = 25;
    final salePrice = originalPrice * (1 - discountPercent / 100);

    final notification = AppNotification(
      id: 'wishlist_sale_${DateTime.now().millisecondsSinceEpoch}',
      title: '🎯 Wishlist Item on Sale!',
      body: 'Great news! "$productTitle" from your wishlist is now $discountPercent% OFF! Was \$${originalPrice.toStringAsFixed(2)}, now \$${salePrice.toStringAsFixed(2)}',
      type: NotificationType.priceAlert,
      priority: NotificationPriority.high,
      data: {
        'action': 'navigate_to_product',
        'product_id': context['product_id'],
        'product_title': productTitle,
        'original_price': originalPrice,
        'sale_price': salePrice,
        'discount_percentage': discountPercent,
        'savings_amount': originalPrice - salePrice,
        'from_wishlist': true,
        'sale_expires_at': DateTime.now().add(const Duration(hours: 12)).toIso8601String(),
        'utm_source': 'wishlist_alert',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'wishlist_price_alerts',
        'firebase_tracking': {
          'message_id': 'wishlist_sale_${context['product_id']}_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'wishlist_price_alerts',
          'product_id': context['product_id'],
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/E91E63/FFFFFF?text=🎯',
      actionUrl: '/products/${context['product_id']}',
    );

    _sendNotification(notification);
  }

  /// Generate test notification
  void _generateTestNotification(Map<String, dynamic> context) {
    final message = context['message'] as String? ??
        'This is a test notification sent at ${DateTime.parse('2025-06-23 08:13:54')}';

    final notification = AppNotification(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: '🧪 Test Notification',
      body: message,
      type: NotificationType.general,
      priority: NotificationPriority.normal,
      data: {
        'action': 'none',
        'test': true,
        'sent_at': DateTime.parse('2025-06-23 08:13:54').toIso8601String(),
        'user_id': context['user_id'] ?? 'roshdology123',
        'auto_dismiss': true,
        'dismiss_after': 5000, // 5 seconds
        'utm_source': 'test_action',
        'utm_medium': 'mobile_app',
        'utm_campaign': 'test_notifications',
        'firebase_tracking': {
          'message_id': 'test_notification_${DateTime.now().millisecondsSinceEpoch}',
          'campaign_id': 'test_notifications',
          'is_test': true,
        },
      },
      createdAt: DateTime.parse('2025-06-23 08:13:54'),
      userId: context['user_id'] as String? ?? 'roshdology123',
      imageUrl: 'https://via.placeholder.com/100x100/9C27B0/FFFFFF?text=🧪',
    );

    _sendNotification(notification);
  }

  /// 🔥 HELPER METHOD: Get priority from urgency string
  NotificationPriority _getPriorityFromUrgency(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'urgent':
        return NotificationPriority.urgent;
      case 'high':
        return NotificationPriority.high;
      case 'low':
        return NotificationPriority.low;
      default:
        return NotificationPriority.normal;
    }
  }

  /// Check if simulation is running
  bool get isSimulating => _isSimulating;

  /// Get next simulation time
  DateTime? get nextSimulationTime {
    if (_simulationTimer == null) return null;
    return DateTime.now().add(const Duration(minutes: 3));
  }

  /// Get simulation statistics
  Map<String, dynamic> get simulationStats {
    return {
      'is_simulating': _isSimulating,
      'next_simulation': nextSimulationTime?.toIso8601String(),
      'timer_active': _simulationTimer?.isActive ?? false,
      'callback_registered': onNotificationGenerated != null,
      'current_time': DateTime.parse('2025-06-23 08:13:54').toIso8601String(),
    };
  }

  /// Trigger specific notification type for testing
  void triggerSpecificNotification(String type, [Map<String, dynamic>? context]) {
    switch (type.toLowerCase()) {
      case 'welcome':
        _generateWelcomeNotification();
        break;
      case 'promotion':
        _generatePromotionalNotification();
        break;
      case 'cart_abandonment':
        _generateCartAbandonmentNotification();
        break;
      case 'new_product':
        _generateNewProductNotification();
        break;
      case 'price_alert':
        _generatePriceAlertNotification();
        break;
      case 'stock_alert':
        _generateStockAlertNotification();
        break;
      case 'order_update':
        _generateOrderUpdateNotification();
        break;
      case 'test':
        _generateTestNotification(context ?? {});
        break;
      default:
        _generateTestNotification({'message': 'Unknown notification type: $type'});
        break;
    }
  }
}