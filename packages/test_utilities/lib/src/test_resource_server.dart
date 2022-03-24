// import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:meta/meta.dart';
// import 'package:path/path.dart';

class TestResourceServer {
  late final Dhttpd httpServer;
  late final String rootPath;
  final int port;
  TestResourceServer(this.port, this.rootPath);
  @mustCallSuper
  Future<void> init() async {
    httpServer = await Dhttpd.start(path: rootPath, port: port);
  }

  @mustCallSuper
  Future<void> dispose() async {
    await httpServer.destroy();
  }

  String getUrl(String relativeFilePath, {bool useHttpPrefix = true}) {
    final prefix = useHttpPrefix ? 'http://' : '';
    return '$prefix${httpServer.host}:${httpServer.port}/$relativeFilePath';
  }
}
