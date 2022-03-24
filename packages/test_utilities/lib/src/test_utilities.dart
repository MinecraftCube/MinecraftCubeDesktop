import 'dart:io' as io;

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart';

// ignore: constant_identifier_names
const _TEMP = 'DART_TEST_TEMP';
// ignore: constant_identifier_names
const _RESOURCES = 'DART_TEST_RESOURCES';

class TestUtilities {
  factory TestUtilities() {
    return _singleton;
  }

  TestUtilities._internal() {
    rootTemp = io.Platform.environment[_TEMP] ??
        join(io.Directory.current.path, 'test_temp');
    rootResources = io.Platform.environment[_RESOURCES] ??
        join(io.Directory.current.path, 'test_resources');
    _system = const LocalFileSystem();
  }

  Directory getTestProjectDir({required String name}) {
    return _system.directory(join(rootTemp, name));
  }

  static final TestUtilities _singleton = TestUtilities._internal();

  late final FileSystem _system;
  late final String rootTemp;
  late final String rootResources;
}
