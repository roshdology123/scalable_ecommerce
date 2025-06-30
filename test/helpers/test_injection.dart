import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:scalable_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:scalable_ecommerce/features/products/domain/repositories/products_repository.dart';


class MockAuthRepository extends Mock implements AuthRepository {}
class MockProductsRepository extends Mock implements ProductsRepository {}

/// Setup test dependencies
void setupTestDependencies() {
  // Reset GetIt
  GetIt.instance.reset();

  // Register test mocks
  GetIt.instance.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(),
  );

  GetIt.instance.registerLazySingleton<ProductsRepository>(
        () => MockProductsRepository(),
  );

  // Configure test-specific dependencies
  // configureTestDependencies();
}

/// Teardown test dependencies
void teardownTestDependencies() {
  GetIt.instance.reset();
}

/// Widget test helper
void setupWidgetTest() {
  setUpAll(() {
    setupTestDependencies();
  });

  tearDownAll(() {
    teardownTestDependencies();
  });
}