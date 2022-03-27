@Tags(['integration'])
import 'package:cube_api/cube_api.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:server_properties_repository/server_properties_repository.dart';
import 'package:test_utilities/test_utilities.dart';

void main() {
  group('ServerPropertiesRepository', () {
    late FileSystem fileSystem;
    late PropertyManager propertyManager;
    late ServerPropertiesRepository repository;

    setUp(() {
      fileSystem = const LocalFileSystem();
      propertyManager = const PropertyManager();
      repository = ServerPropertiesRepository(
        fileSystem: fileSystem,
        propertyManager: propertyManager,
      );
    });

    group('constructor', () {
      test('instantiates properly when not injected', () {
        expect(ServerPropertiesRepository(), isNotNull);
      });
    });

    final rootPath = TestUtilities()
        .getTestProjectDir(name: 'server_properties_repository_test');

    setUp(() async {
      await rootPath.create(recursive: true);
      fileSystem.currentDirectory = rootPath;
    });

    tearDown(() async {
      fileSystem.currentDirectory = '/';
      if (await rootPath.exists()) await rootPath.delete(recursive: true);
    });
    group('getProperties', () {
      test('return nothing when there is no server.properties file', () async {
        expect(
          repository.getProperties(directory: 'empty'),
          emitsDone,
        );
      });
      test('return correct server.properties', () async {
        await copyPath(
          p.join(TestUtilities().rootResources, 'server_properties_repository'),
          rootPath.path,
        );
        expect(
          repository.getProperties(directory: 'project'),
          emitsInOrder(const [
            Property(name: 'broadcast-rcon-to-ops', value: 'true'),
            Property(name: 'view-distance', value: '10'),
            Property(name: 'enable-jmx-monitoring', value: 'false'),
            Property(name: 'server-ip', value: ''),
            Property(name: 'resource-pack-prompt', value: ''),
            Property(name: 'rcon.port', value: '25575'),
            Property(name: 'gamemode', value: 'survival'),
            Property(name: 'server-port', value: '25565'),
            Property(name: 'allow-nether', value: 'true'),
            Property(name: 'enable-command-block', value: 'false'),
            Property(name: 'enable-rcon', value: 'false'),
            Property(name: 'sync-chunk-writes', value: 'true'),
            Property(name: 'enable-query', value: 'false'),
            Property(name: 'op-permission-level', value: '4'),
            Property(name: 'prevent-proxy-connections', value: 'false'),
            Property(name: 'resource-pack', value: ''),
            Property(name: 'entity-broadcast-range-percentage', value: '100'),
            Property(name: 'level-name', value: 'world'),
            Property(name: 'rcon.password', value: ''),
            Property(name: 'player-idle-timeout', value: '0'),
            Property(name: 'motd', value: 'A Minecraft Server'),
            Property(name: 'query.port', value: '25565'),
            Property(name: 'force-gamemode', value: 'false'),
            Property(name: 'rate-limit', value: '0'),
            Property(name: 'hardcore', value: 'false'),
            Property(name: 'white-list', value: 'false'),
            Property(name: 'broadcast-console-to-ops', value: 'true'),
            Property(name: 'pvp', value: 'true'),
            Property(name: 'spawn-npcs', value: 'true'),
            Property(name: 'spawn-animals', value: 'true'),
            Property(name: 'snooper-enabled', value: 'true'),
            Property(name: 'difficulty', value: 'easy'),
            Property(name: 'function-permission-level', value: '2'),
            Property(name: 'network-compression-threshold', value: '256'),
            Property(name: 'text-filtering-config', value: ''),
            Property(name: 'require-resource-pack', value: 'false'),
            Property(name: 'spawn-monsters', value: 'true'),
            Property(name: 'max-tick-time', value: '60000'),
            Property(name: 'enforce-whitelist', value: 'false'),
            Property(name: 'use-native-transport', value: 'true'),
            Property(name: 'max-players', value: '20'),
            Property(name: 'resource-pack-sha1', value: ''),
            Property(name: 'spawn-protection', value: '16'),
            Property(name: 'online-mode', value: 'true'),
            Property(name: 'enable-status', value: 'true'),
            Property(name: 'allow-flight', value: 'false'),
            Property(name: 'max-world-size', value: '29999984'),
          ]),
        );
      });
    });

    group('saveProperties', () {
      test('call loadPropety', () async {
        await fileSystem.directory('test').create();
        await repository.saveProperties(
          directory: 'test',
          properties: const [
            Property(name: 'prevent-proxy-connections', value: 'false'),
            Property(name: 'resource-pack', value: ''),
            Property(name: 'entity-broadcast-range-percentage', value: '100'),
            Property(name: 'level-name', value: 'world'),
            Property(name: 'rcon.password', value: ''),
            Property(name: 'player-idle-timeout', value: '0'),
            Property(name: 'motd', value: 'A Minecraft Server'),
          ],
        );
        File file = fileSystem.file(p.join('test', 'server.properties'));
        expect(await file.exists(), isTrue);
        expect(
          await file.readAsString(),
          allOf([
            startsWith('# Minecraft'),
            contains('prevent-proxy-connections'),
            contains('resource-pack'),
            contains('entity-broadcast-range-percentage'),
            contains('level-name'),
            contains('rcon.password'),
            contains('player-idle-timeout'),
            contains('motd'),
          ]),
        );
      });
    });
  });
}
