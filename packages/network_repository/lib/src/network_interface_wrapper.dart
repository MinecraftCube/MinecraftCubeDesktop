import 'dart:io';

class NetworkInterfaceWrapper {
  const NetworkInterfaceWrapper();

  /// Whether the [list] method is supported.
  ///
  /// The [list] method is currently unsupported on Android.
  bool get supported => NetworkInterface.listSupported;

  /// Query the system for [NetworkInterface]s.
  ///
  /// If [includeLoopback] is `true`, the returned list will include the
  /// loopback device. Default is `false`.
  ///
  /// If [includeLinkLocal] is `true`, the list of addresses of the returned
  /// [NetworkInterface]s, may include link local addresses. Default is `false`.
  ///
  /// If [type] is either [InternetAddressType.IPv4] or
  /// [InternetAddressType.IPv6] it will only lookup addresses of the
  /// specified type. Default is [InternetAddressType.any].
  Future<List<NetworkInterface>> list({
    bool includeLoopback = false,
    bool includeLinkLocal = false,
    InternetAddressType type = InternetAddressType.any,
  }) async {
    return NetworkInterface.list(
      includeLinkLocal: includeLinkLocal,
      includeLoopback: includeLoopback,
      type: type,
    );
  }
}
