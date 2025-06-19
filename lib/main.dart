import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/di/injection.dart';
import 'core/di/bloc_providers.dart';
import 'app/router/app_router.dart';
import 'app/themes/app_theme.dart';
import 'core/utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final logger = AppLogger();

  try {
    logger.logBusinessLogic(
      'app_initialization_started',
      'system_startup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:26:16',
      },
    );

    // Configure system UI
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Initialize dependencies
    await configureDependencies();

    logger.logBusinessLogic(
      'app_initialization_completed',
      'system_startup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:26:16',
      },
    );

    runApp(EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar',),
        child: const MyApp()));

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      'App.main',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:26:16',
      },
    );

    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProviders.wrapWithProviders(
      MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Scalable E-commerce',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'App Failed to Start',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Restart App'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}