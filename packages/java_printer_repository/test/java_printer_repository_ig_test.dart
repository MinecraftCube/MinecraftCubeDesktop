@Tags(['integration'])
import 'package:flutter_test/flutter_test.dart';
import 'package:java_printer_repository/java_printer_repository.dart';
import 'package:process/process.dart';

void main() {
  group('JavaPrinterRepository', () {
    late ProcessManager processManager;
    late JavaPrinterRepository repository;

    setUp(
      () {
        processManager = const LocalProcessManager();
        repository = JavaPrinterRepository(
          processManager: processManager,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(const JavaPrinterRepository(), isNotNull);
      });
    });

    group('getJavaVersion', () {
      test('return correct java info', () async {
        expect(
          await repository.getVersionInfo(javaExecutablePath: 'java'),
          matches(
            RegExp(r'version \".*\"'),
          ),
        );
      });
    });
  });
}
