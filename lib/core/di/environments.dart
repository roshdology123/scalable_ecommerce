import 'package:injectable/injectable.dart';


abstract class Environments {
  static const String dev = 'dev';
  static const String staging = 'staging';
  static const String prod = 'prod';
  static const String test = 'test';
}

/// Environment-specific modules
@module
@Environment(Environments.dev)
abstract class DevModule {
  @singleton
  @Named('apiUrl')
  String get apiUrl => 'https://fakestoreapi.com';

  @singleton
  @Named('enableLogging')
  bool get enableLogging => true;
}

@module
@Environment(Environments.staging)
abstract class StagingModule {
  @singleton
  @Named('apiUrl')
  String get apiUrl => 'https://staging.yourapi.com';

  @singleton
  @Named('enableLogging')
  bool get enableLogging => true;
}

@module
@Environment(Environments.prod)
abstract class ProdModule {
  @singleton
  @Named('apiUrl')
  String get apiUrl => 'https://api.yourproductionurl.com';

  @singleton
  @Named('enableLogging')
  bool get enableLogging => false;
}

@module
@Environment(Environments.test)
abstract class TestModule {
  @singleton
  @Named('apiUrl')
  String get apiUrl => 'https://test.api.com';

  @singleton
  @Named('enableLogging')
  bool get enableLogging => false;

  // // Mock services for testing
  // @LazySingleton(as: AuthRepository)
  // MockAuthRepository get mockAuthRepository => MockAuthRepository();
}