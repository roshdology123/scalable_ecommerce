import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// import '../../core/di/injection.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
// import '../../features/auth/pages/pages/login_page.dart';
// import '../../features/auth/pages/pages/signup_page.dart';
// import '../../features/products/pages/pages/products_page.dart';
// import '../../features/products/pages/pages/product_detail_page.dart';
// import '../../features/cart/pages/pages/cart_page.dart';
// import '../../features/cart/pages/pages/checkout_page.dart';
// import '../../features/favorites/pages/pages/favorites_page.dart';
// import '../../features/search/pages/pages/search_page.dart';
// import '../../features/profile/pages/pages/profile_page.dart';
// import '../../features/profile/pages/pages/settings_page.dart';
// import '../../features/onboarding/pages/pages/onboarding_page.dart';
// import '../../features/navigation/pages/pages/main_navigation_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // Route redirection based on auth state
    redirect: (context, state) {
      final authCubit = context.read<AuthCubit>();
      final authState = authCubit.state;

      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplashRoute = state.matchedLocation == '/splash';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      return authState.when(
        initial: () => isSplashRoute ? null : '/splash',
        loading: () => isSplashRoute ? null : '/splash',
        forgotPasswordSent: () => isSplashRoute ? null : '/splash',
        authenticated: (_) {
          if (isAuthRoute || isSplashRoute || isOnboardingRoute) {
            return '/home';
          }
          return null;
        },
        unauthenticated: () {
          if (isAuthRoute || isSplashRoute || isOnboardingRoute) {
            return null;
          }
          return '/auth/login';
        },
        error: (s,_) => '/auth/login',
      );
    },

    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // // Onboarding Route
      // GoRoute(
      //   path: '/onboarding',
      //   builder: (context, state) => const OnboardingPage(),
      // ),
      //
      // Auth Routes
      GoRoute(
        path: '/auth',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => const SignupPage(),
          ),
        ],
      ),

      // // Main App Shell with Bottom Navigation
      // ShellRoute(
      //   navigatorKey: _shellNavigatorKey,
      //   builder: (context, state, child) {
      //     return MainNavigationPage(child: child);
      //   },
      //   routes: [
      //     // Home/Products Tab
      //     GoRoute(
      //       path: '/home',
      //       builder: (context, state) => const ProductsPage(),
      //       routes: [
      //         GoRoute(
      //           path: '/product/:id',
      //           builder: (context, state) {
      //             final productId = int.parse(state.pathParameters['id']!);
      //             return ProductDetailPage(productId: productId);
      //           },
      //         ),
      //       ],
      //     ),
      //
      //     // Search Tab
      //     GoRoute(
      //       path: '/search',
      //       builder: (context, state) => const SearchPage(),
      //     ),
      //
      //     // Favorites Tab
      //     GoRoute(
      //       path: '/favorites',
      //       builder: (context, state) => const FavoritesPage(),
      //     ),
      //
      //     // Cart Tab
      //     GoRoute(
      //       path: '/cart',
      //       builder: (context, state) => const CartPage(),
      //       routes: [
      //         GoRoute(
      //           path: '/checkout',
      //           builder: (context, state) => const CheckoutPage(),
      //         ),
      //       ],
      //     ),
      //
      //     // Profile Tab
      //     GoRoute(
      //       path: '/profile',
      //       builder: (context, state) => const ProfilePage(),
      //       routes: [
      //         GoRoute(
      //           path: '/settings',
      //           builder: (context, state) => const SettingsPage(),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      //
      // Standalone Routes (outside shell)
      GoRoute(
        path: '/product-detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['id']!);
          return ProductDetailPage(productId: productId);
        },
      ),

      // GoRoute(
      //   path: '/checkout',
      //   parentNavigatorKey: _rootNavigatorKey,
      //   builder: (context, state) => const CheckoutPage(),
      // ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization time
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Check if user has seen onboarding
      final hasSeenOnboarding = await _checkOnboardingStatus();

      if (!hasSeenOnboarding) {
        context.go('/onboarding');
      } else {
        // Let the router redirect handle auth state
        context.go('/home');
      }
    }
  }

  Future<bool> _checkOnboardingStatus() async {
    // Check SharedPreferences or local storage
    // For now, return false to show onboarding
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'E-Commerce',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}