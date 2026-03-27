import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onStatusChange;
}

class ConnectivityNetworkInfo implements NetworkInfo {
  ConnectivityNetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    return _hasConnection(await _connectivity.checkConnectivity());
  }

  @override
  Stream<bool> get onStatusChange {
    return _connectivity.onConnectivityChanged.map(_hasConnection).distinct();
  }
}

class AlwaysOnlineNetworkInfo implements NetworkInfo {
  const AlwaysOnlineNetworkInfo();

  @override
  Future<bool> get isConnected async {
    return true;
  }

  @override
  Stream<bool> get onStatusChange => Stream<bool>.value(true);
}

bool _hasConnection(List<ConnectivityResult> results) {
  return results.any((result) => result != ConnectivityResult.none);
}
