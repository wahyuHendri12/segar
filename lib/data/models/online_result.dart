/// Status shared by every optional online lookup.
enum OnlineFetchStatus { success, disabled, offline, notFound, error }

/// Result wrapper that lets the UI react to offline, disabled and empty states
/// without catching exceptions itself.
class OnlineResult<T> {
  const OnlineResult({required this.status, this.data, this.fromCache = false});

  const OnlineResult.success(T value, {this.fromCache = false})
    : status = OnlineFetchStatus.success,
      data = value;

  const OnlineResult.failure(this.status) : data = null, fromCache = false;

  final OnlineFetchStatus status;
  final T? data;

  /// True when the value came from the local cache instead of the network.
  final bool fromCache;

  bool get isSuccess => status == OnlineFetchStatus.success;
}
