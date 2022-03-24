import 'dart:io';
import 'package:path/path.dart' as p;

Future<void> deleteDirectory(String path) async {
  final isAbsolute = p.isAbsolute(path);
  final prefix = Platform.isWindows && isAbsolute ? r'\\?\' : '';
  await Directory(prefix + path).delete(recursive: true);
}
