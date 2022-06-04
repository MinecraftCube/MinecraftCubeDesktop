import 'dart:io' as io;
import 'package:flutter_test/flutter_test.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';
import 'package:url_launcher/url_launcher.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements io.ProcessResult {}

typedef LaunchDef = Future<bool> Function(
  String urlString, {
  LaunchMode? mode,
  WebViewConfiguration? webViewConfiguration,
  String? webOnlyWindowName,
});
void main() {
  group('LauncherRepository', () {
    late int canLaunchCalled;
    late int launchCalled;
    late LauncherRepository repository;
    late Future<bool> Function(String urlString) canLaunch;
    late LaunchDef launch;

    setUp(
      () {
        canLaunchCalled = 0;
        launchCalled = 0;
        canLaunch = (_) async {
          canLaunchCalled++;
          return true;
        };
        launch = (
          String urlString, {
          LaunchMode? mode,
          WebViewConfiguration? webViewConfiguration,
          String? webOnlyWindowName,
        }) async {
          launchCalled++;
          return true;
        };
        repository = LauncherRepository(
          canLaunch,
          launch,
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
