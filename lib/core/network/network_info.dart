import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    // results is List<ConnectivityResult>
    return _isConnected(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    // Consider connected if any interface is available
    return results.any((result) =>
    result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet
    );
  }
}

@module
abstract class NetworkModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}