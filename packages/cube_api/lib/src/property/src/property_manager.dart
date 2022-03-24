import 'dart:convert';

import 'package:cube_api/src/property/src/property.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

class PropertyManager {
  const PropertyManager({FileSystem? fileSystem})
      : _fileSystem = fileSystem ?? const LocalFileSystem();
  final FileSystem _fileSystem;

  Stream<Property> loadProperty({required String filePath}) async* {
    File file = _fileSystem.file(filePath);
    if (!await file.exists()) return;
    final content = await file.readAsString();
    final lines = const LineSplitter().convert(content);
    for (final line in lines) {
      if (line.startsWith('#')) continue;
      final keyValue = line.split('=');
      if (keyValue.length == 2) {
        final key = keyValue[0];
        final value = keyValue[1];
        yield Property(name: key, value: value);
      }
    }
  }
}
