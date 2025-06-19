import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scalable_ecommerce/features/onboarding/presentation/cubit/onboarding_cubit.dart';

import '../../core/di/injection.dart';
import '../../core/storage/storage_service.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    redirect: (context, state) {
      final authCubit = context.read<AuthCubit>();
      final authState = authCubit.state;

      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplashRoute = state.matchedLocation == '/splash';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      return authState.when(
        initial: () {
          // Allow splash and onboarding, but redirect others to splash
          if (isSplashRoute || isOnboardingRoute) {
            return null; // Allow these routes
          }
          return '/splash';
        },
        loading: () {
          // Same logic for loading state
          if (isSplashRoute || isOnboardingRoute) {
            return null;
          }
          return '/splash';
        },
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
        error: (_, __) => '/auth/login',
        forgotPasswordSent: () => '/auth/login',
      );
    },

    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        builder: (context, state) =>  BlocProvider(
  create: (context) => getIt<OnboardingCubit>(),
  child: const OnboardingPage(),
),
      ),

      // Auth Routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) {
          // Redirect /auth to /auth/login
          if (state.matchedLocation == '/auth') {
            return '/auth/login';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupPage(),
          ),
        ],
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // Home/Products Tab
          GoRoute(
            path: '/home',
            builder: (context, state) => const ProductsPage(),
            routes: [
              GoRoute(
                path: 'product/:id',
                builder: (context, state) {
                  final productId = int.parse(state.pathParameters['id']!);
                  return ProductDetailPage(productId: productId);
                },
              ),
            ],
          ),

          // Search Tab
          GoRoute(
            path: '/search',
            builder: (context, state) => const Placeholder(),
          ),

          // Favorites Tab
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const Placeholder(),
          ),

          // Cart Tab
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartPage(),
            routes: [
              GoRoute(
                path: 'checkout',
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),

          // Profile Tab
          GoRoute(
            path: '/profile',
            builder: (context, state) => const Placeholder(),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),
        ],
      ),

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

// Main Shell Widget with Bottom Navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/favorites')) return 2;
    if (location.startsWith('/cart')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/cart');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
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
    try {
      final storageService = getIt<StorageService>();
      return storageService.getOnboardingCompleted();
    } catch (e) {
      return false;
    }
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