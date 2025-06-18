import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/di/environments.dart';
import 'core/storage/local_storage.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/products/presentation/cubit/categories_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (LocalStorage will handle its own initialization)
  await Hive.initFlutter();

  // Configure dependencies based on environment
  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: Environments.dev);
  await configureAppDependencies(environment);

  runApp(const MyApp());
}

Future<void> configureAppDependencies(String environment) async {
  // Configure DI with environment
  configureDependencies();

  // Pre-resolve async dependencies (including LocalStorage initialization)
  await getIt.allReady();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Cubits
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<CategoriesCubit>(
          create: (context) => getIt<CategoriesCubit>(),
        ),
      ],
      child: const MyApp(),
    );
  }
}