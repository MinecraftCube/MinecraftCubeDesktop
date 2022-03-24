import 'dart:async';

import 'package:cube_api/src/property/property.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

void main() {
  late PropertyManager propertyManager;
  late FileSystem fileSystem;
  setUp(() {
    fileSystem = MockFileSystem();
    propertyManager = PropertyManager(fileSystem: fileSystem);
  });
  group('PropertyManager', () {
    group('constructor', () {
      test('instantiates internal FileSystem when not injected', () {
        expect(const PropertyManager(), isNotNull);
      });
    });

    group('loadProperty', () {
      test('file not found should do nothing', () async {
        final Completer completer = Completer();
        final file = MockFile();
        when(() => file.exists()).thenAnswer((_) async => false);
        when(() => fileSystem.file(any())).thenReturn(file);
        propertyManager.loadProperty(filePath: 'anything').listen(
          expectAsync1((p) => {}, count: 0),
          onDone: () {
            verifyNever(() => file.readAsString());
            completer.complete();
          },
        );
        await completer.future;
      });

      test('empty file found and do nothing', () async {
        final Completer completer = Completer();
        final file = MockFile();
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.readAsString()).thenAnswer((_) async => '');
        when(() => fileSystem.file(any())).thenReturn(file);
        propertyManager.loadProperty(filePath: 'anything').listen(
          expectAsync1((p) => {}, count: 0),
          onDone: () {
            verify(() => file.readAsString()).called(1);
            completer.complete();
          },
        );
        await completer.future;
      });

      test('yield Property from normal raw', () async {
        final file = MockFile();
        const raw = '''broadcast-rcon-to-ops=true
view-distance=10
enable-jmx-monitoring=false''';
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.readAsString()).thenAnswer((_) async => raw);
        when(() => fileSystem.file(any())).thenReturn(file);
        expect(
          propertyManager.loadProperty(filePath: 'anything'),
          emitsInOrder(
            [
              const Property(name: 'broadcast-rcon-to-ops', value: 'true'),
              const Property(name: 'view-distance', value: '10'),
              const Property(name: 'enable-jmx-monitoring', value: 'false'),
            ],
          ),
        );
      });

      test('yield Property from normal raw with comment', () async {
        final file = MockFile();
        const raw = '''#Minecraft server properties
#Sun Aug 22 22:59:38 CST 2021
broadcast-rcon-to-ops=true
view-distance=10
enable-jmx-monitoring=false''';
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.readAsString()).thenAnswer((_) async => raw);
        when(() => fileSystem.file(any())).thenReturn(file);
        expect(
          propertyManager.loadProperty(filePath: 'anything'),
          emitsInOrder(
            [
              const Property(name: 'broadcast-rcon-to-ops', value: 'true'),
              const Property(name: 'view-distance', value: '10'),
              const Property(name: 'enable-jmx-monitoring', value: 'false'),
            ],
          ),
        );
      });

      test('yield Property from minecraft raw', () async {
        final Completer completer = Completer();
        final file = MockFile();
        when(() => file.exists()).thenAnswer((_) async => true);
        when(() => file.readAsString()).thenAnswer((_) async => fullRaw);
        when(() => fileSystem.file(any())).thenReturn(file);
        // final stream = propertyManager.loadProperty(filePath: 'anything');
        expect(
          propertyManager.loadProperty(filePath: 'anything'),
          emitsInOrder(
            [
              const Property(name: 'broadcast-rcon-to-ops', value: 'true'),
              const Property(name: 'view-distance', value: '10'),
              const Property(name: 'enable-jmx-monitoring', value: 'false'),
              const Property(name: 'server-ip', value: ''),
            ],
          ),
        );
        propertyManager.loadProperty(filePath: 'anything').listen(
              expectAsync1(
                (p) {},
                count: 47,
              ),
              onDone: () => completer.complete(),
            );
        // expect(
        //   await propertyManager.loadProperty(filePath: 'anything').length,
        //   equals(17),
        // );
        await completer.future;
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
