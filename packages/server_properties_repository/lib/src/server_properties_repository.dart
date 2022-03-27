import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class ServerPropertiesRepository {
  ServerPropertiesRepository({
    FileSystem? fileSystem,
    PropertyManager? propertyManager,
  })  : _propertyManager = propertyManager ?? const PropertyManager(),
        _fileSystem = fileSystem ?? const LocalFileSystem();
  final PropertyManager _propertyManager;
  final FileSystem _fileSystem;

  Stream<Property> getProperties({required String directory}) {
    return _propertyManager.loadProperty(
      filePath: p.join(directory, 'server.properties'),
    );
  }

  Future<void> saveProperties({
    required String directory,
    required Iterable<Property> properties,
  }) async {
    final currentCST =
        DateTime.now().toUtc().subtract(const Duration(hours: 6));
    final serverPropertiesFile =
        _fileSystem.file(p.join(directory, 'server.properties'));
    String result =
        '# Minecraft server properties (Managed by MinecraftCube)\n# ${DateFormat(r"EEE MMM d HH:mm:ss 'CST' yyyy").format(currentCST)}\n';
    for (final prop in properties) {
      result += '${prop.name}=${prop.value}\n';
    }
    await serverPropertiesFile.writeAsString(result);
  }
}
