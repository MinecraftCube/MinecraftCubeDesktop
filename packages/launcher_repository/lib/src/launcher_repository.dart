import 'dart:ui';

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
  /// Parses the specified URL string and delegates handling of it to the
  /// underlying platform.
  ///
  /// The returned future completes with a [PlatformException] on invalid URLs and
  /// schemes which cannot be handled, that is when [canLaunch] would complete
  /// with false.
  ///
  /// By default when [forceSafariVC] is unset, the launcher
  /// opens web URLs in the Safari View Controller, anything else is opened
  /// using the default handler on the platform. If set to true, it opens the
  /// URL in the Safari View Controller. If false, the URL is opened in the
  /// default browser of the phone. Note that to work with universal links on iOS,
  /// this must be set to false to let the platform's system handle the URL.
  /// Set this to false if you want to use the cookies/context of the main browser
  /// of the app (such as SSO flows). This setting will nullify [universalLinksOnly]
  /// and will always launch a web content in the built-in Safari View Controller regardless
  /// if the url is a universal link or not.
  ///
  /// [universalLinksOnly] is only used in iOS with iOS version >= 10.0. This setting is only validated
  /// when [forceSafariVC] is set to false. The default value of this setting is false.
  /// By default (when unset), the launcher will either launch the url in a browser (when the
  /// url is not a universal link), or launch the respective native app content (when
  /// the url is a universal link). When set to true, the launcher will only launch
  /// the content if the url is a universal link and the respective app for the universal
  /// link is installed on the user's device; otherwise throw a [PlatformException].
  ///
  /// [forceWebView] is an Android only setting. If null or false, the URL is
  /// always launched with the default browser on device. If set to true, the URL
  /// is launched in a WebView. Unlike iOS, browser context is shared across
  /// WebViews.
  /// [enableJavaScript] is an Android only setting. If true, WebView enable
  /// javascript.
  /// [enableDomStorage] is an Android only setting. If true, WebView enable
  /// DOM storage.
  /// [headers] is an Android only setting that adds headers to the WebView.
  /// When not using a WebView, the header information is passed to the browser,
  /// some Android browsers do not support the [Browser.EXTRA_HEADERS](https://developer.android.com/reference/android/provider/Browser#EXTRA_HEADERS)
  /// intent extra and the header information will be lost.
  /// [webOnlyWindowName] is an Web only setting . _blank opens the new url in new tab ,
  /// _self opens the new url in current tab.
  /// Default behaviour is to open the url in new tab.
  ///
  /// Note that if any of the above are set to true but the URL is not a web URL,
  /// this will throw a [PlatformException].
  ///
  /// [statusBarBrightness] Sets the status bar brightness of the application
  /// after opening a link on iOS. Does nothing if no value is passed. This does
  /// not handle resetting the previous status bar style.
  ///
  /// Returns true if launch url is successful; false is only returned when [universalLinksOnly]
  /// is set to true and the universal link failed to launch.
  /// {@endtemplate}
  final Future<bool> Function(
    String urlString, {
    bool? forceSafariVC,
    bool forceWebView,
    bool enableJavaScript,
    bool enableDomStorage,
    bool universalLinksOnly,
    Map<String, String> headers,
    Brightness? statusBarBrightness,
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
