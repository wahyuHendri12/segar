import 'package:connectivity_plus/connectivity_plus.dart';

/// Small seam so repositories can be tested without platform channels.
abstract class ConnectivityChecker {
  Future<bool> get isOnline;
}

class ConnectivityPlusChecker implements ConnectivityChecker {
  ConnectivityPlusChecker({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) return true;
      return results.any((result) => result != ConnectivityResult.none);
    } on Object {
      // If the platform cannot report connectivity, let the request try and
      // fail naturally instead of blocking the feature.
      return true;
    }
  }
}
