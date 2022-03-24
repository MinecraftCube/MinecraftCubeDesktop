import 'package:cube_api/cube_api.dart';
import 'package:equatable/equatable.dart';

class CubeProperties extends Equatable {
  const CubeProperties({
    this.xmx = '4g',
    this.xms = '256m',
    this.java = 'java',
  });

  final String xmx;
  final String xms;
  final String java;

  ///
  /// Read [CubeProperties] from [path]
  ///
  /// dev: [fromFile] should be [CubeProperties.fromFile], but static cannot be mockable, so this is the caveat.
  // Future<CubeProperties> fromFile({
  //   required String path,
  // }) async {
  //   final stream = _propertyManager.loadProperty(filePath: path);
  //   CubeProperties cubeProperties =
  //       CubeProperties(propertyManager: _propertyManager);
  //   await for (final property in stream) {
  //     switch (property.name.toLowerCase()) {
  //       case 'xmx':
  //         cubeProperties = cubeProperties.copyWith(xmx: property.value);
  //         break;
  //       case 'xms':
  //         cubeProperties = cubeProperties.copyWith(xms: property.value);
  //         break;
  //       case 'java':
  //         cubeProperties = cubeProperties.copyWith(java: property.value);
  //         break;
  //       default:
  //         break;
  //     }
  //   }
  //   return cubeProperties;
  // }

  // Future<void> writeToFile(File file) async {
  //   await file.create(recursive: true);
  //   String result =
  //       '# MinecraftCube ${DateFormat('yyyy/MM/dd HH:mm:ss')} Local Time \n';
  //   result += toString();
  //   await file.writeAsString(result);
  // }

  CubeProperties fromProperty({
    required Iterable<Property> properties,
  }) {
    CubeProperties cubeProperties = const CubeProperties();
    for (final property in properties) {
      switch (property.name.toLowerCase()) {
        case 'xmx':
          cubeProperties = cubeProperties.copyWith(xmx: property.value);
          break;
        case 'xms':
          cubeProperties = cubeProperties.copyWith(xms: property.value);
          break;
        case 'java':
          cubeProperties = cubeProperties.copyWith(java: property.value);
          break;
        default:
          break;
      }
    }
    return cubeProperties;
  }

  @override
  String toString() {
    String result = '';
    result += 'Xmx=$xmx\n';
    result += 'Xms=$xms\n';
    result += 'Java=$java\n';
    return result;
  }

  CubeProperties copyWith({
    String? xmx,
    String? xms,
    String? java,
    // PropertyManager? propertyManager,
  }) {
    return CubeProperties(
      xmx: xmx ?? this.xmx,
      xms: xms ?? this.xms,
      java: java ?? this.java,
      // propertyManager: propertyManager ?? _propertyManager,
    );
  }

  @override
  List<Object> get props => [xmx, xms, java];
}
