// ignore_for_file: unnecessary_string_escapes

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_installer_repository/forge_installer_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:process/process.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcess extends Mock implements io.Process {}

void main() {
  group('ForgeInstallerRepository', () {
    late ProcessManager processManager;
    late ForgeInstallerRepository repository;

    setUp(() {
      processManager = MockProcessManager();
      repository = ForgeInstallerRepository(
        processManager: processManager,
      );
    });

    group('constructor', () {
      test('instantiates internal processManager when not injected', () {
        expect(ForgeInstallerRepository(), isNotNull);
      });
    });

    group('installForge', () {
      test('return nothing when jarArchiveInfo is type of JarType.forge',
          () async {
        Completer completer = Completer();
        final List<String> collector = [];
        repository
            .installForge(
          javaExecutablePath: 'anything',
          jarArchiveInfo: const JarArchiveInfo(
            type: JarType.forge,
            executable: 'anyhing',
          ),
        )
            .listen(
          (event) {
            collector.add(event);
          },
          onDone: () {
            expect(collector, hasLength(0));
            completer.complete();
          },
        );
        await completer.future;
      });
      test('return nothing when jarArchiveInfo is type of JarType.vanilla',
          () async {
        Completer completer = Completer();
        final List<String> collector = [];
        repository
            .installForge(
          javaExecutablePath: 'anything',
          jarArchiveInfo: const JarArchiveInfo(
            type: JarType.vanilla,
            executable: 'anyhing',
          ),
        )
            .listen(
          (event) {
            collector.add(event);
          },
          onDone: () {
            expect(collector, hasLength(0));
            completer.complete();
          },
        );
        await completer.future;
      });
      test('return nothing when jarArchiveInfo is type of JarType.unknown',
          () async {
        Completer completer = Completer();
        final List<String> collector = [];
        repository
            .installForge(
          javaExecutablePath: 'anything',
          jarArchiveInfo: const JarArchiveInfo(
            type: JarType.unknown,
            executable: 'anyhing',
          ),
        )
            .listen(
          (event) {
            collector.add(event);
          },
          onDone: () {
            expect(collector, hasLength(0));
            completer.complete();
          },
        );
        await completer.future;
      });
      group('JarType.forgeInstaller', () {
        test('call process.start with correct arguments', () async {
          Completer completer = Completer();
          final List<String> collector = [];

          final process = MockProcess();
          const javaExecutable = 'java';
          const executable = 'servers/j8/forge_installer.jar';
          when(
            () => processManager.start(
              captureAny(),
              runInShell: true,
              workingDirectory: captureAny(named: 'workingDirectory'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stdout).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.stderr).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async => 0);
          when(() => process.kill()).thenReturn(false);

          repository
              .installForge(
            javaExecutablePath: javaExecutable,
            jarArchiveInfo: const JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: executable,
            ),
          )
              .listen(
            (event) {
              collector.add(event);
            },
            onDone: () {
              expect(collector, hasLength(0));
              final captured = verify(
                () => processManager.start(
                  captureAny(),
                  runInShell: true,
                  workingDirectory: captureAny(named: 'workingDirectory'),
                ),
              ).captured;
              expect(
                captured.first,
                equals(
                  [
                    javaExecutable,
                    '-jar',
                    'forge_installer.jar',
                    '--installServer'
                  ],
                ),
              );
              expect(captured.last, equals('servers/j8'));
              completer.complete();
            },
          );
          await completer.future;
        });

        test('return correct forge infos', () async {
          Completer completer = Completer();
          final List<String> collector = [];

          final process = MockProcess();
          const javaExecutable = 'java';
          const executable = 'servers/j8/forge_installer.jar';
          when(
            () => processManager.start(
              captureAny(),
              runInShell: true,
              workingDirectory: captureAny(named: 'workingDirectory'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stdout).thenAnswer((_) => fakeInstallerStream());
          when(() => process.stderr).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async => 0);
          when(() => process.kill()).thenReturn(false);

          repository
              .installForge(
            javaExecutablePath: javaExecutable,
            jarArchiveInfo: const JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: executable,
            ),
          )
              .listen(
            (event) {
              collector.add(event);
            },
            onDone: () {
              final fullText = collector.join('\n');
              expect(fullText, hasLength(fakeInstallerSuccess.length));
              expect(fullText, fakeInstallerSuccess);
              completer.complete();
            },
          );
          await completer.future;
        });

        test('throw ForgeInstallationException when exitCode not 0', () async {
          Completer completer = Completer();
          final List<String> collector = [];

          final process = MockProcess();
          const javaExecutable = 'java';
          const executable = 'servers/j8/forge_installer.jar';
          when(
            () => processManager.start(
              captureAny(),
              runInShell: true,
              workingDirectory: captureAny(named: 'workingDirectory'),
            ),
          ).thenAnswer((_) async => process);
          when(() => process.stdout).thenAnswer((_) => fakeInstallerStream());
          when(() => process.stderr).thenAnswer((_) => Stream.fromIterable([]));
          when(() => process.exitCode).thenAnswer((_) async => -1);
          when(() => process.kill()).thenReturn(false);

          repository
              .installForge(
            javaExecutablePath: javaExecutable,
            jarArchiveInfo: const JarArchiveInfo(
              type: JarType.forgeInstaller,
              executable: executable,
            ),
          )
              .listen(
            (event) {
              collector.add(event);
            },
            onDone: () {
              final fullText = collector.join('\n');
              expect(fullText, hasLength(fakeInstallerSuccess.length));
              expect(fullText, fakeInstallerSuccess);
              completer.complete();
            },
            onError: (e) {
              expect(e, isA<ForgeInstallationException>());
            },
          );
          await completer.future;
        });
      });
    });
  });
}

Stream<List<int>> fakeInstallerStream() {
  final lines = const LineSplitter().convert(fakeInstallerSuccess);
  final codes = lines.map<List<int>>((e) => e.codeUnits);
  return Stream.fromIterable(codes);
}

const fakeInstallerSuccess =
    r'''JVM info: Azul Systems, Inc. - 1.8.0_302 - 25.302-b08
java.net.preferIPv4Stack=true
Found java version 1.8.0_302
Target Directory: .
Extractiung main jar:
  Extracted successfully
Considering minecraft server jar
Downloading libraries
Considering library net.minecraftforge:forge:1.15.2-31.1.1
  File exists: Checksum validated.
Considering library org.ow2.asm:asm:7.2
  File exists: Checksum validated.
Considering library org.ow2.asm:asm-commons:7.2
  File exists: Checksum validated.
Considering library org.ow2.asm:asm-tree:7.2
  File exists: Checksum validated.
Considering library cpw.mods:modlauncher:5.0.0-milestone.4
  File exists: Checksum validated.
Considering library cpw.mods:grossjava9hacks:1.1.0
  File exists: Checksum validated.
Considering library net.minecraftforge:accesstransformers:2.0.0-milestone.1-shadowed
  File exists: Checksum validated.
Considering library net.minecraftforge:eventbus:2.0.0-milestone.1-service
  File exists: Checksum validated.
Considering library net.minecraftforge:forgespi:2.0.0-milestone.1
  File exists: Checksum validated.
Considering library net.minecraftforge:coremods:2.0.0-milestone.1
  File exists: Checksum validated.
Considering library net.minecraftforge:unsafe:0.2.0
  File exists: Checksum validated.
Considering library com.electronwill.night-config:core:3.6.2
  File exists: Checksum validated.
Considering library com.electronwill.night-config:toml:3.6.2
  File exists: Checksum validated.
Considering library org.jline:jline:3.12.1
  File exists: Checksum validated.
Considering library org.apache.maven:maven-artifact:3.6.0
  File exists: Checksum validated.
Considering library net.jodah:typetools:0.6.1
  File exists: Checksum validated.
Considering library org.apache.logging.log4j:log4j-api:2.11.2
  File exists: Checksum validated.
Considering library org.apache.logging.log4j:log4j-core:2.11.2
  File exists: Checksum validated.
Considering library net.minecrell:terminalconsoleappender:1.2.0
  File exists: Checksum validated.
Considering library net.sf.jopt-simple:jopt-simple:5.0.4
  File exists: Checksum validated.
Considering library com.github.jponge:lzma-java:1.3
  File exists: Checksum validated.
Considering library com.google.code.findbugs:jsr305:3.0.2
  File exists: Checksum validated.
Considering library com.google.code.gson:gson:2.8.0
  File exists: Checksum validated.
Considering library com.google.errorprone:error_prone_annotations:2.1.3
  File exists: Checksum validated.
Considering library com.google.guava:guava:20.0
  File exists: Checksum validated.
Considering library com.google.guava:guava:25.1-jre
  File exists: Checksum validated.
Considering library com.google.j2objc:j2objc-annotations:1.1
  File exists: Checksum validated.
Considering library com.nothome:javaxdelta:2.0.1
  File exists: Checksum validated.
Considering library commons-io:commons-io:2.4
  File exists: Checksum validated.
Considering library de.oceanlabs.mcp:mcp_config:1.15.2-20200122.131323@zip
  File exists: Checksum validated.
Considering library net.md-5:SpecialSource:1.8.5
  File exists: Checksum validated.
Considering library net.minecraftforge:binarypatcher:1.0.12
  File exists: Checksum validated.
Considering library net.minecraftforge:forge:1.15.2-31.1.1:universal
  File exists: Checksum validated.
Considering library net.minecraftforge:installertools:1.1.4
  File exists: Checksum validated.
Considering library net.minecraftforge:jarsplitter:1.1.2
  File exists: Checksum validated.
Considering library net.sf.jopt-simple:jopt-simple:4.9
  File exists: Checksum validated.
Considering library net.sf.jopt-simple:jopt-simple:5.0.4
  File exists: Checksum validated.
Considering library net.sf.opencsv:opencsv:2.3
  File exists: Checksum validated.
Considering library org.checkerframework:checker-qual:2.0.0
  File exists: Checksum validated.
Considering library org.codehaus.mojo:animal-sniffer-annotations:1.14
  File exists: Checksum validated.
Considering library org.ow2.asm:asm-analysis:6.1.1
  File exists: Checksum validated.
Considering library org.ow2.asm:asm-commons:6.1.1
  File exists: Checksum validated.
Considering library org.ow2.asm:asm-tree:6.1.1
  File exists: Checksum validated.
Considering library org.ow2.asm:asm:6.1.1
  File exists: Checksum validated.
Considering library trove:trove:1.0.2
  File exists: Checksum validated.
Created Temporary Directory: C:\Users\Dowen\AppData\Local\Temp\forge_installer4042697761493078462
  Extracting: /data/server.lzma
Building Processors
===============================================================================
  MainClass: net.minecraftforge.installertools.ConsoleTool
  Classpath:
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\minecraftforge\installertools\1.1.4\installertools-1.1.4.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\md-5\SpecialSource\1.8.5\SpecialSource-1.8.5.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\sf\jopt-simple\jopt-simple\5.0.4\jopt-simple-5.0.4.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\com\google\code\gson\gson\2.8.0\gson-2.8.0.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm-commons\6.1.1\asm-commons-6.1.1.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\com\google\guava\guava\20.0\guava-20.0.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\sf\opencsv\opencsv\2.3\opencsv-2.3.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm-analysis\6.1.1\asm-analysis-6.1.1.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm-tree\6.1.1\asm-tree-6.1.1.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm\6.1.1\asm-6.1.1.jar
  Args: --task, MCP_DATA, --input, D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\de\oceanlabs\mcp\mcp_config\1.15.2-20200122.131323\mcp_config-1.15.2-20200122.131323.zip, --output, D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\de\oceanlabs\mcp\mcp_config\1.15.2-20200122.131323\mcp_config-1.15.2-20200122.131323-mappings.txt, --key, mappings
Task: MCP_DATA
Input:  D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\de\oceanlabs\mcp\mcp_config\1.15.2-20200122.131323\mcp_config-1.15.2-20200122.131323.zip
Output: D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\de\oceanlabs\mcp\mcp_config\1.15.2-20200122.131323\mcp_config-1.15.2-20200122.131323-mappings.txt
Key:    mappings
Extracting: config/joined.tsrg
===============================================================================
  Cache:
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\minecraft\server\1.15.2\server-1.15.2-slim.jar Validated: 9e4cfc5a34121901aba5f4bf002af9ae472eede0
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\minecraft\server\1.15.2\server-1.15.2-extra.jar Validated: eb84dde2927f1dedb0b810f373a9a4e7325ba95d
  Cache Hit!
===============================================================================
  MainClass: net.md_5.specialsource.SpecialSource
  Classpath:
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\md-5\SpecialSource\1.8.5\SpecialSource-1.8.5.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm-commons\6.1.1\asm-commons-6.1.1.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\sf\jopt-simple\jopt-simple\4.9\jopt-simple-4.9.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\com\google\guava\guava\20.0\guava-20.0.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\sf\opencsv\opencsv\2.3\opencsv-2.3.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm-analysis\6.1.1\asm-analysis-6.1.1.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm-tree\6.1.1\asm-tree-6.1.1.jar
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\org\ow2\asm\asm\6.1.1\asm-6.1.1.jar
  Args: --in-jar, D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\minecraft\server\1.15.2\server-1.15.2-slim.jar, --out-jar, D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\minecraft\server\1.15.2-20200122.131323\server-1.15.2-20200122.131323-srg.jar, --srg-in, D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\de\oceanlabs\mcp\mcp_config\1.15.2-20200122.131323\mcp_config-1.15.2-20200122.131323-mappings.txt
Loading mappings
Loading mappings...  0%
Loading mappings... 10%
Loading mappings... 20%
Loading mappings... 30%
Loading mappings... 40%
Loading mappings... 50%
0 packages, 5137 classes, 18825 fields, 34159 methods
Remapping final jar
Remapping jar...  0%
Remapping jar... 10%
Remapping jar... 20%
Remapping jar... 30%
Remapping jar... 40%
Remapping jar... 50%
Remapping jar... 60%
Remapping jar... 70%
Remapping jar... 80%
Remapping jar... 90%
Remapping jar... 100%
===============================================================================
  Cache:
    D:\Project\McDedicatedServer\minecraft_scepter_desktop\resources\forge_1.15.2\.\libraries\net\minecraftforge\forge\1.15.2-31.1.1\forge-1.15.2-31.1.1-server.jar Validated: 7c2d9a39e6c676c148f93d16986035a9a8cfa85b
  Cache Hit!
The server installed successfully, you should now be able to run the file forge
You can delete this installer file now if you wish''';
