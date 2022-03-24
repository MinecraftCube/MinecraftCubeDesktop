import 'dart:io' as io;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements io.ProcessResult {}

typedef LaunchDef = Future<bool> Function(
  String urlString, {
  bool? forceSafariVC,
  bool forceWebView,
  bool enableJavaScript,
  bool enableDomStorage,
  bool universalLinksOnly,
  Map<String, String> headers,
  Brightness? statusBarBrightness,
  String? webOnlyWindowName,
});
void main() {
  group('LauncherRepository', () {
    late int canLaunchCalled;
    late int launchCalled;
    late LauncherRepository repository;
    late Future<bool> Function(String urlString) _canLaunch;
    late LaunchDef _launch;

    setUp(
      () {
        canLaunchCalled = 0;
        launchCalled = 0;
        _canLaunch = (_) async {
          canLaunchCalled++;
          return true;
        };
        _launch = (
          String urlString, {
          bool? forceSafariVC,
          bool forceWebView = false,
          bool enableJavaScript = false,
          bool enableDomStorage = false,
          bool universalLinksOnly = false,
          Map<String, String> headers = const {},
          Brightness? statusBarBrightness,
          String? webOnlyWindowName,
        }) async {
          launchCalled++;
          return true;
        };
        repository = LauncherRepository(
          _canLaunch,
          _launch,
        );
      },
    );

    group('launch', () {
      test('called once', () async {
        repository.launch(path: 'fileAAA');
        expect(launchCalled, 1);
      });
    });

    group('canLaunch', () {
      test('called once', () async {
        repository.canLaunch(path: 'fileAAA');
        expect(canLaunchCalled, 1);
      });
    });
  });
}
