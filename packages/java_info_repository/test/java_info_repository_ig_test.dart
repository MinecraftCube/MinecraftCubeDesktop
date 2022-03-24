@Tags(['integration'])

import 'dart:async';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:path/path.dart' as p;
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('JavaInfoRepository', () {
    late FileSystem fileSystem;
    late JavaInfoRepository repository;

    setUp(
      () {
        fileSystem = const LocalFileSystem();
        repository = JavaInfoRepository(
          fileSystem: fileSystem,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(const JavaInfoRepository(), isNotNull);
      });
    });

    group('getSystemJava', () {
      test('return correct JavaInfo', () async {
        final info = await repository.getSystemJava();
        expect(
          info.name,
          'java',
        );
        expect(info.executablePaths, isNotEmpty);
        for (final exe in info.executablePaths) {
          expect(exe, contains('java'));
        }
        expect(info.output, isNotEmpty);
      });
    });

    group('getPortableJavas', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'java_info_repository_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });
      test('return nothing when no java directory', () async {
        expect(repository.getPortableJavas(), emitsDone);
      });
      test('return nothing when no any sub directory', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'java_info_repository',
            'empty',
          ),
          p.join(rootPath.path, 'java'),
        );
        expect(repository.getPortableJavas(), emitsDone);
      });

      test('return nothing when no file match the bin/java rule', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'java_info_repository',
            'nomatch',
          ),
          p.join(rootPath.path, 'java'),
        );
        expect(repository.getPortableJavas(), emitsDone);
      });

      test('return matche-only result on bin/java rule', () async {
        await copyPath(
          p.join(
            TestUtilities().rootResources,
            'java_info_repository',
            'match',
          ),
          p.join(rootPath.path, 'java'),
        );

        final jarInfos = <JavaInfo>[];
        Completer completer = Completer();
        repository.getPortableJavas().listen(
              ((info) => jarInfos.add(info)),
              onDone: (() => completer.complete()),
            );
        await completer.future;
        expect(
          jarInfos,
          allOf([
            // Order are different on Linux and Windows
            contains(
              JavaInfo(
                executablePaths: [
                  p.join('java', 'AProjectJava', 'bin', 'java'),
                  p.join('java', 'AProjectJava', 'bin', 'java.exe'),
                ],
                name: 'AProjectJava',
              ),
            ),
            contains(
              JavaInfo(
                executablePaths: [
                  p.join('java', 'BProjectJava', 'bin', 'java'),
                  p.join('java', 'BProjectJava', 'bin', 'java.exe'),
                ],
                name: 'BProjectJava',
              ),
            ),
          ]),
        );
      });
    });
  });
}
