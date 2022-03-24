@Tags(['integration'])

import 'dart:async';

import 'package:cube_api/src/property/property.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utilities/test_utilities.dart';
import 'package:path/path.dart' as p;

void main() {
  late PropertyManager propertyManager;
  late FileSystem fileSystem;
  setUp(() {
    fileSystem = const LocalFileSystem();
    propertyManager = PropertyManager(fileSystem: fileSystem);
  });
  group('PropertyManager', () {
    group('constructor', () {
      test('instantiates internal FileSystem when not injected', () {
        expect(const PropertyManager(), isNotNull);
      });
    });

    group('loadProperty', () {
      final rootPath =
          TestUtilities().getTestProjectDir(name: 'property_manager_test');

      setUp(() async {
        await rootPath.create(recursive: true);
        fileSystem.currentDirectory = rootPath;
      });

      tearDown(() async {
        fileSystem.currentDirectory = '/';
        if (await rootPath.exists()) await rootPath.delete(recursive: true);
      });

      test('file not found should do nothing', () async {
        final Completer completer = Completer();
        await copyPath(
          p.join(TestUtilities().rootResources, 'property_manager_repository'),
          p.join(rootPath.path, 'notfound'),
        );
        propertyManager
            .loadProperty(filePath: p.join('notfound', 'nosuchfile'))
            .listen(
              expectAsync1((p) => {}, count: 0),
              onDone: () => completer.complete(),
            );

        await completer.future;
      });

      test('empty file found and do nothing', () async {
        final Completer completer = Completer();
        await copyPath(
          p.join(TestUtilities().rootResources, 'property_manager_repository'),
          p.join(rootPath.path, 'empty'),
        );
        final stream = propertyManager.loadProperty(
          filePath: p.join('empty', 'empty.properties'),
        );
        stream.listen(
          expectAsync1((p) => {}, count: 0),
          onDone: () => completer.complete(),
        );
        await completer.future;
      });
      test('yield Property from minecraft server.properties', () async {
        final Completer completer = Completer();
        await copyPath(
          p.join(TestUtilities().rootResources, 'property_manager_repository'),
          p.join(rootPath.path, 'minecraft'),
        );
        const datas = [
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
          Property(
            name: 'entity-broadcast-range-percentage',
            value: '100',
          ),
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
          Property(
            name: 'network-compression-threshold',
            value: '256',
          ),
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
        ];

        final path = p.join('minecraft', 'server.properties');
        expect(
          propertyManager.loadProperty(
            filePath: path,
          ),
          emitsInOrder(
            datas,
          ),
        );
        propertyManager.loadProperty(filePath: path).listen(
              expectAsync1(
                (p) {},
                count: datas.length,
              ),
              onDone: () => completer.complete(),
            );
        await completer.future;
        // expect(
        //   await propertyManager.loadProperty(filePath: 'anything').length,
        //   equals(17),
        // );
      });
    });
  });
}

const fullRaw = '''#Minecraft server properties
#Sun Aug 22 22:59:38 CST 2021
broadcast-rcon-to-ops=true
view-distance=10
enable-jmx-monitoring=false
server-ip=
resource-pack-prompt=
rcon.port=25575
gamemode=survival
server-port=25565
allow-nether=true
enable-command-block=false
enable-rcon=false
sync-chunk-writes=true
enable-query=false
op-permission-level=4
prevent-proxy-connections=false
resource-pack=
entity-broadcast-range-percentage=100
level-name=world
rcon.password=
player-idle-timeout=0
motd=A Minecraft Server
query.port=25565
force-gamemode=false
rate-limit=0
hardcore=false
white-list=false
broadcast-console-to-ops=true
pvp=true
spawn-npcs=true
spawn-animals=true
snooper-enabled=true
difficulty=easy
function-permission-level=2
network-compression-threshold=256
text-filtering-config=
require-resource-pack=false
spawn-monsters=true
max-tick-time=60000
enforce-whitelist=false
use-native-transport=true
max-players=20
resource-pack-sha1=
spawn-protection=16
online-mode=true
enable-status=true
allow-flight=false
max-world-size=29999984''';
