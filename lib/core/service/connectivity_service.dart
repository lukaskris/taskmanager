import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectivityStream =>
      _connectivity.onConnectivityChanged.map(
        (event) =>
            event.contains(ConnectivityResult.mobile) ||
            event.contains(ConnectivityResult.wifi) ||
            event.contains(ConnectivityResult.ethernet),
      );

  Future<bool> get isConnected async {
    final event = await _connectivity.checkConnectivity();
    return event.contains(ConnectivityResult.mobile) ||
        event.contains(ConnectivityResult.wifi) ||
        event.contains(ConnectivityResult.ethernet);
  }
}
