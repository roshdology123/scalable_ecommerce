import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scalable_ecommerce/features/favorites/presentation/cubit/favorites_collections/favorites_collection_cubit.dart';
import 'package:scalable_ecommerce/features/onboarding/presentation/cubit/onboarding_cubit.dart';

import '../../core/di/injection.dart';
import '../../core/storage/storage_service.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import '../../features/favorites/presentation/pages/favorites_collection_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
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
      final location = state.matchedLocation;

      // Debug logging
      debugPrint('[Router] Redirect check - Location: $location, Auth State: $authState');

      final isAuthRoute = location.startsWith('/auth');
      final isSplashRoute = location == '/splash';
      final isOnboardingRoute = location == '/onboarding';

      return authState.when(
        initial: () {
          debugPrint('[Router] Auth state: initial - Location: $location');
          // During initial state, allow splash and onboarding
          if (isSplashRoute || isOnboardingRoute) {
            return null;
          }
          // Redirect everything else to splash for proper initialization
          return '/splash';
        },

        loading: () {
          debugPrint('[Router] Auth state: loading - Location: $location');
          // During loading, allow splash, onboarding, and auth routes
          if (isSplashRoute || isOnboardingRoute || isAuthRoute) {
            return null;
          }
          // Keep user on splash during auth check
          return '/splash';
        },

        authenticated: (user) {
          debugPrint('[Router] Auth state: authenticated - User: ${user.email}, Location: $location');
          // If user is authenticated and tries to access auth routes or splash, redirect to home
          if (isAuthRoute || isSplashRoute) {
            return '/home';
          }
          // Allow onboarding in case user wants to see it again from settings
          if (isOnboardingRoute) {
            return null;
          }
          return null; // Allow all other routes
        },

        unauthenticated: () {
          debugPrint('[Router] Auth state: unauthenticated - Location: $location');
          // Allow auth routes, splash, and onboarding for unauthenticated users
          if (isAuthRoute || isSplashRoute || isOnboardingRoute) {
            return null;
          }
          // Redirect protected routes to login
          return '/auth/login';
        },

        error: (message, errorCode) {
          debugPrint('[Router] Auth state: error - $message (Code: $errorCode), Location: $location');
          // Allow auth routes and splash even on error
          if (isAuthRoute || isSplashRoute || isOnboardingRoute) {
            return null;
          }
          return '/auth/login';
        },

        forgotPasswordSent: () {
          debugPrint('[Router] Auth state: forgotPasswordSent - Location: $location');
          // Stay on auth routes or redirect to login
          if (isAuthRoute || isSplashRoute) {
            return null;
          }
          return '/auth/login';
        },

        passwordResetSuccess: () {
          debugPrint('[Router] Auth state: passwordResetSuccess - Location: $location');
          // Redirect to login after successful password reset
          if (isAuthRoute) {
            return '/auth/login';
          }
          return '/auth/login';
        },
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
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<OnboardingCubit>(),
          child: const OnboardingPage(),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) {
          debugPrint('[Router] Building LoginPage for: ${state.matchedLocation}');
          return const LoginPage();
        },
      ),

      GoRoute(
        path: '/auth/signup',
        builder: (context, state) {
          debugPrint('[Router] Building SignupPage for: ${state.matchedLocation}');
          return const SignupPage();
        },
      ),

      // Protected Routes with Shell
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
            builder: (context, state) => const SearchPage(), // You'll need to create this
          ),

          // Favorites Tab
          GoRoute(
            path: '/favorites',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;

              return BlocProvider(
  create: (context) => getIt<FavoritesCollectionsCubit>()..loadCollections(),
  child: FavoritesPage(
                initialCollectionId: extra?['collectionId'],
                initialCategory: extra?['category'],
              ),
);
            },
          ),

          GoRoute(
            path: '/favorites/collections',
            builder: (context, state) {
              return const FavoritesCollectionsPage();
            },
          ),

          // Cart Tab
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartPage(),
            routes: [
              GoRoute(
                path: 'checkout',
                builder: (context, state) => const CheckoutPage(), // You'll need to create this
              ),
            ],
          ),

          // Profile Tab
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(), // You'll need to create this
            routes: [
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsPage(), // You'll need to create this
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfilePage(), // You'll need to create this
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
    ],

    // Enhanced error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
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
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.matchedLocation}" does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Check if user is authenticated to determine where to go
                final authCubit = context.read<AuthCubit>();
                final isAuthenticated = authCubit.isAuthenticated;
                context.go(isAuthenticated ? '/home' : '/auth/login');
              },
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Your existing MainShell remains the same...
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

// Enhanced Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    debugPrint('[SplashPage] Starting initialization...');

    try {
      // Minimum splash duration for UX
      final initFuture = _performInitialization();
      final minDelayFuture = Future.delayed(const Duration(seconds: 2));

      // Wait for both to complete
      await Future.wait([initFuture, minDelayFuture]);

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('[SplashPage] Error during initialization: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
        // Navigate to login on error
        context.go('/auth/login');
      }
    }
  }

  Future<void> _performInitialization() async {
    if (!mounted) return;

    // Check if user has seen onboarding
    final hasSeenOnboarding = await _checkOnboardingStatus();
    debugPrint('[SplashPage] Has seen onboarding: $hasSeenOnboarding');

    if (!hasSeenOnboarding) {
      debugPrint('[SplashPage] Going to onboarding');
      if (mounted) {
        context.go('/onboarding');
      }
      return;
    }

    // Check auth status (this will handle auto-login)
    final authCubit = context.read<AuthCubit>();
    debugPrint('[SplashPage] Current auth state: ${authCubit.state}');

    // If auth is in initial state, trigger auth check
    if (authCubit.state == const AuthState.initial()) {
      debugPrint('[SplashPage] Triggering auth status check...');
      await authCubit.checkAuthStatus();
    }

    // Wait a bit more to ensure state has settled
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      final finalAuthState = authCubit.state;
      debugPrint('[SplashPage] Final auth state: $finalAuthState');

      // Navigate based on final auth state
      finalAuthState.when(
        initial: () {
          debugPrint('[SplashPage] Still initial, going to login');
          context.go('/auth/login');
        },
        loading: () {
          debugPrint('[SplashPage] Still loading, waiting...');
          // Will be handled by the router redirect
        },
        authenticated: (user) {
          debugPrint('[SplashPage] User authenticated: ${user.email}, going to home');
          context.go('/home');
        },
        unauthenticated: () {
          debugPrint('[SplashPage] User not authenticated, going to login');
          context.go('/auth/login');
        },
        error: (message, error) {
          debugPrint('[SplashPage] Auth error: $message, going to login');
          context.go('/auth/login');
        },
        forgotPasswordSent: () {
          debugPrint('[SplashPage] Password reset sent, going to login');
          context.go('/auth/login');
        },
        passwordResetSuccess: () {
          debugPrint('[SplashPage] Password reset successful, going to login');
          context.go('/auth/login');
        },
      );
    }
  }

  Future<bool> _checkOnboardingStatus() async {
    try {
      final storageService = getIt<StorageService>();
      return storageService.getOnboardingCompleted();
    } catch (e) {
      debugPrint('[SplashPage] Error checking onboarding status: $e');
      return false; // Default to showing onboarding on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        debugPrint('[SplashPage] Auth state changed: $state');

        // Only navigate if we're done initializing
        if (!_isInitializing) {
          state.when(
            initial: () {}, // Will be handled by redirect
            loading: () {}, // Will be handled by redirect
            authenticated: (user) {
              if (mounted) context.go('/home');
            },
            unauthenticated: () {
              if (mounted) context.go('/auth/login');
            },
            error: (message, error) {
              if (mounted) context.go('/auth/login');
            },
            forgotPasswordSent: () {
              if (mounted) context.go('/auth/login');
            },
            passwordResetSuccess: () {
              if (mounted) context.go('/auth/login');
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // App Name
              Text(
                'Scalable E-Commerce',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Loading Indicator
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Status Text
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      key: ValueKey(state.runtimeType.toString()),
                      _getStatusText(state),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(AuthState state) {
    return state.when(
      initial: () => 'Initializing application...',
      loading: () => 'Checking authentication...',
      authenticated: (user) => 'Welcome back, ${user.firstName}!',
      unauthenticated: () => 'Setting up login...',
      error: (message, _) => 'Initialization complete',
      forgotPasswordSent: () => 'Redirecting to login...',
      passwordResetSuccess: () => 'Password reset successful!',
    );
  }
}

// Placeholder pages (you'll need to create these)
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Search Page - Coming Soon')),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Checkout Page - Coming Soon')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Page - Coming Soon')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Page - Coming Soon')),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Edit Profile Page - Coming Soon')),
    );
  }
}