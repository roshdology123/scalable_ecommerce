import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_service.dart';
import '../utils/app_logger.dart';

@module
abstract class CoreModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  Dio get dio => Dio();

  @singleton
  AppLogger get logger => AppLogger();

  @singleton
  LocalStorage get localStorage => LocalStorage();

  @singleton
  SecureStorage get secureStorage => SecureStorage();

  @singleton
  NetworkInfo networkInfo(Connectivity connectivity) =>
      NetworkInfoImpl(connectivity);

  @singleton
  DioClient dioClient(
      NetworkInfo networkInfo,
      SecureStorage secureStorage,
      ) =>
      DioClient(networkInfo, secureStorage);

  @singleton
  StorageService storageService(
      SharedPreferences prefs,
      SecureStorage secureStorage,
      LocalStorage localStorage,
      ) =>
      StorageService(prefs, secureStorage, localStorage);
}