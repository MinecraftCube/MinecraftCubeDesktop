import 'dart:ui';

import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

class LocaleRepository {
  const LocaleRepository({
    FileSystem? fileSystem,
    PropertyManager? propertyManager,
  })  : _propertyManager = propertyManager ?? const PropertyManager(),
        _fileSystem = fileSystem ?? const LocalFileSystem();
  final PropertyManager _propertyManager;
  final FileSystem _fileSystem;
  static const filename = 'lang.properties';

  Future<Locale?> read() async {
    final properties = <Property>[];
    await for (final prop
        in _propertyManager.loadProperty(filePath: filename)) {
      properties.add(prop);
    }
    if (properties.isEmpty) return null;
    String? lang;
    String? country;
    for (final prop in properties) {
      if (prop.name == 'lang') {
        lang = prop.value;
      }
      if (prop.name == 'country') {
        country = prop.value;
      }
    }
    if (lang == null) return null;
    return Locale(lang, country);
  }

  Future<void> write({required String lang, required String country}) async {
    String content = '# Language Configuration\n';
    content += 'lang=$lang\n';
    content += 'country=$country';
    await _fileSystem.file(filename).create();
    await _fileSystem.file(filename).writeAsString(content);
  }
}
