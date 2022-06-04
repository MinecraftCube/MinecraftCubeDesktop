import 'package:url_launcher/url_launcher.dart';

class LauncherRepository {
  const LauncherRepository(
    this._canLaunch,
    this._launch,
  );

  /// {@template canLauncher}
  /// Some shared docs
  /// Checks whether the specified URL can be handled by some app installed on the
  /// device.
  ///
  /// On some systems, such as recent versions of Android and iOS, this will
  /// always return false unless the application has been configuration to allow
  /// querying the system for launch support. See
  /// [the README](https://pub.dev/packages/url_launcher#configuration) for
  /// details.
  /// {@endtemplate}
  final Future<bool> Function(String urlString) _canLaunch;

  /// {@template launch}
  /// String version of [launchUrl].
  ///
  /// This should be used only in the very rare case of needing to launch a URL
  /// that is considered valid by the host platform, but not by Dart's [Uri]
  /// class. In all other cases, use [launchUrl] instead, as that will ensure
  /// that you are providing a valid URL.
  ///
  /// The behavior of this method when passing an invalid URL is entirely
  /// platform-specific; no effort is made by the plugin to make the URL valid.
  /// Some platforms may provide best-effort interpretation of an invalid URL,
  /// others will immediately fail if the URL can't be parsed according to the
  /// official standards that define URL formats.
  /// {@endtemplate}
  final Future<bool> Function(
    String urlString, {
    LaunchMode mode,
    WebViewConfiguration webViewConfiguration,
    String? webOnlyWindowName,
  }) _launch;

  /// {@macro canLauncher}
  Future<bool> canLaunch({required String path}) async {
    return _canLaunch(path);
  }

  /// {@macro launch}
  Future<bool> launch({required String path}) async {
    return _launch(path);
  }
}
