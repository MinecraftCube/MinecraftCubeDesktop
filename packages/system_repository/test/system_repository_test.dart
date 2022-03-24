import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:system_repository/src/cpu_info.dart';
import 'package:system_repository/src/memory_info.dart';
import 'package:system_repository/src/system_repository.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements io.ProcessResult {}

class MockPlatform extends Mock implements Platform {}

class MockEncoding extends Mock implements Encoding {}

void main() {
  Encoding mockEncoding = MockEncoding();
  setUpAll(() {
    registerFallbackValue(mockEncoding);
  });
  group('SystemRepository', () {
    late Platform platform;
    late ProcessManager processManager;
    late SystemRepository repository;

    setUp(
      () {
        platform = MockPlatform();
        processManager = MockProcessManager();
        repository = SystemRepository(
          processManager: processManager,
          platform: platform,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(const SystemRepository(), isNotNull);
      });
    });

    group('getCpuInfo', () {
      test('throws UnsupportedError on unknown os', () {
        when(() => platform.isLinux).thenReturn(false);
        when(() => platform.isWindows).thenReturn(false);
        when(() => platform.isMacOS).thenReturn(false);
        expect(
          repository.getCpuInfo(),
          throwsA(isA<UnsupportedError>()),
        );
      });
      group('[windows]', () {
        const windowsCpuNameCmd = 'wmic cpu get NAME';
        const windowsCpuLoadCmd = 'wmic cpu get loadpercentage';
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(true);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getCpuInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default CpuInfo when nothing return', () async {
          io.ProcessResult nameResult = MockProcessResult();
          io.ProcessResult loadResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => nameResult);
          when(() => nameResult.exitCode).thenReturn(0);
          when(() => nameResult.stderr).thenReturn('');
          when(() => nameResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(windowsCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => loadResult);
          when(() => loadResult.exitCode).thenReturn(0);
          when(() => loadResult.stderr).thenReturn('');
          when(() => loadResult.stdout).thenReturn('');
          expect(
            await repository.getCpuInfo(),
            const CpuInfo(),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct CpuInfo', () async {
          io.ProcessResult nameResult = MockProcessResult();
          io.ProcessResult loadResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => nameResult);
          when(() => nameResult.exitCode).thenReturn(0);
          when(() => nameResult.stderr).thenReturn('');
          when(() => nameResult.stdout).thenReturn(windowsCpuName);
          when(
            () => processManager.run(
              captureAny(that: contains(windowsCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => loadResult);
          when(() => loadResult.exitCode).thenReturn(0);
          when(() => loadResult.stderr).thenReturn('');
          when(() => loadResult.stdout).thenReturn(windowsCpuLoad);
          expect(
            await repository.getCpuInfo(),
            const CpuInfo(
              name: 'Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz',
              load: 13,
            ),
          );
        });
      });
      group('[linux]', () {
        const linuxCpuNameCmd =
            "lscpu | sed -nr '/Model name/ s/.*:\\s*(.*) @ .*/\\1/p'";
        const linuxCpuLoadCmd =
            "awk '{u=\$2+\$4; t=\$2+\$4+\$5; if (NR==1){u1=u; t1=t;} else print (\$2+\$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)";
        setUp(() {
          when(() => platform.isLinux).thenReturn(true);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getCpuInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default CpuInfo when nothing return', () async {
          io.ProcessResult nameResult = MockProcessResult();
          io.ProcessResult loadResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => nameResult);
          when(() => nameResult.exitCode).thenReturn(0);
          when(() => nameResult.stderr).thenReturn('');
          when(() => nameResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(linuxCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => loadResult);
          when(() => loadResult.exitCode).thenReturn(0);
          when(() => loadResult.stderr).thenReturn('');
          when(() => loadResult.stdout).thenReturn('');
          expect(
            await repository.getCpuInfo(),
            const CpuInfo(),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct CpuInfo', () async {
          io.ProcessResult nameResult = MockProcessResult();
          io.ProcessResult loadResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => nameResult);
          when(() => nameResult.exitCode).thenReturn(0);
          when(() => nameResult.stderr).thenReturn('');
          when(() => nameResult.stdout).thenReturn(linuxCpuName);
          when(
            () => processManager.run(
              captureAny(that: contains(linuxCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => loadResult);
          when(() => loadResult.exitCode).thenReturn(0);
          when(() => loadResult.stderr).thenReturn('');
          when(() => loadResult.stdout).thenReturn(linuxCpuLoad);
          expect(
            await repository.getCpuInfo(),
            const CpuInfo(
              name: 'Intel(R) core .... GHZ',
              load: 1.54456,
            ),
          );
        });
      });

      group('[macos]', () {
        const macosCpuNameCmd =
            "sysctl -a | grep machdep.cpu.brand_string | awk '{for(i = 2;i < NF; i++) printf \$i \" \"; print \$NF}'";
        const macosCpuLoadCmd =
            "top -l 2 -n 0 -F | egrep -o ' \\d*\\.\\d+% idle' | tail -1 | awk -F% -v prefix=\"\$prefix\" '{ printf \"%s%.1f\\n\", prefix, 100 - \$1 }'";
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(true);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getCpuInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default CpuInfo when nothing return', () async {
          io.ProcessResult nameResult = MockProcessResult();
          io.ProcessResult loadResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => nameResult);
          when(() => nameResult.exitCode).thenReturn(0);
          when(() => nameResult.stderr).thenReturn('');
          when(() => nameResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(macosCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => loadResult);
          when(() => loadResult.exitCode).thenReturn(0);
          when(() => loadResult.stderr).thenReturn('');
          when(() => loadResult.stdout).thenReturn('');
          expect(
            await repository.getCpuInfo(),
            const CpuInfo(),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(macosCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(macosCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct CpuInfo', () async {
          io.ProcessResult nameResult = MockProcessResult();
          io.ProcessResult loadResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosCpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => nameResult);
          when(() => nameResult.exitCode).thenReturn(0);
          when(() => nameResult.stderr).thenReturn('');
          when(() => nameResult.stdout).thenReturn(macosCpuName);
          when(
            () => processManager.run(
              captureAny(that: contains(macosCpuLoadCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => loadResult);
          when(() => loadResult.exitCode).thenReturn(0);
          when(() => loadResult.stderr).thenReturn('');
          when(() => loadResult.stdout).thenReturn(macosCpuLoad);
          expect(
            await repository.getCpuInfo(),
            const CpuInfo(
              name: 'Intel(R) core .... GHZ',
              load: 11.6,
            ),
          );
        });
      });
    });
    group('getMemoryInfo', () {
      test('throws UnsupportedError on unknown os', () {
        when(() => platform.isLinux).thenReturn(false);
        when(() => platform.isWindows).thenReturn(false);
        when(() => platform.isMacOS).thenReturn(false);
        expect(
          repository.getMemoryInfo(),
          throwsA(isA<UnsupportedError>()),
        );
      });
      group('[windows]', () {
        const windowsTotalMemCmd = 'wmic OS get TotalVisibleMemorySize';
        const windowsFreeMemCmd = 'wmic OS get FreePhysicalMemory';
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(true);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getMemoryInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default MemoryInfo when nothing return', () async {
          io.ProcessResult totalMemResult = MockProcessResult();
          io.ProcessResult freeMemResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => totalMemResult);
          when(() => totalMemResult.exitCode).thenReturn(0);
          when(() => totalMemResult.stderr).thenReturn('');
          when(() => totalMemResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(windowsFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => freeMemResult);
          when(() => freeMemResult.exitCode).thenReturn(0);
          when(() => freeMemResult.stderr).thenReturn('');
          when(() => freeMemResult.stdout).thenReturn('');
          expect(
            await repository.getMemoryInfo(),
            const MemoryInfo(),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct MemoryInfo', () async {
          io.ProcessResult totalMemResult = MockProcessResult();
          io.ProcessResult freeMemResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => totalMemResult);
          when(() => totalMemResult.exitCode).thenReturn(0);
          when(() => totalMemResult.stderr).thenReturn('');
          when(() => totalMemResult.stdout).thenReturn(windowsTotalMem);
          when(
            () => processManager.run(
              captureAny(that: contains(windowsFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => freeMemResult);
          when(() => freeMemResult.exitCode).thenReturn(0);
          when(() => freeMemResult.stderr).thenReturn('');
          when(() => freeMemResult.stdout).thenReturn(windowsFreeMem);
          expect(
            await repository.getMemoryInfo(),
            const MemoryInfo(
              freeSize: 2819112,
              totalSize: 16681340,
            ),
          );
        });
      });
      group('[linux]', () {
        const linuxTotalMemCmd = "awk '/MemTotal/ {print \$2}' /proc/meminfo";
        const linuxFreeMemCmd = "awk '/MemFree/ {print \$2}' /proc/meminfo";
        setUp(() {
          when(() => platform.isLinux).thenReturn(true);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getMemoryInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default MemoryInfo when nothing return', () async {
          io.ProcessResult totalMemResult = MockProcessResult();
          io.ProcessResult freeMemResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => totalMemResult);
          when(() => totalMemResult.exitCode).thenReturn(0);
          when(() => totalMemResult.stderr).thenReturn('');
          when(() => totalMemResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(linuxFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => freeMemResult);
          when(() => freeMemResult.exitCode).thenReturn(0);
          when(() => freeMemResult.stderr).thenReturn('');
          when(() => freeMemResult.stdout).thenReturn('');
          expect(
            await repository.getMemoryInfo(),
            const MemoryInfo(),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct MemoryInfo', () async {
          io.ProcessResult totalMemResult = MockProcessResult();
          io.ProcessResult freeMemResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => totalMemResult);
          when(() => totalMemResult.exitCode).thenReturn(0);
          when(() => totalMemResult.stderr).thenReturn('');
          when(() => totalMemResult.stdout).thenReturn(linuxTotalMem);
          when(
            () => processManager.run(
              captureAny(that: contains(linuxFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => freeMemResult);
          when(() => freeMemResult.exitCode).thenReturn(0);
          when(() => freeMemResult.stderr).thenReturn('');
          when(() => freeMemResult.stdout).thenReturn(linuxFreeMem);
          expect(
            await repository.getMemoryInfo(),
            const MemoryInfo(
              freeSize: 2819112,
              totalSize: 16681340,
            ),
          );
        });
      });
      group('[macos]', () {
        const macosTotalMemCmd =
            "top -l 1 -s 0 | grep PhysMem | awk '{print \$2}'";
        const macosFreeMemCmd =
            "top -l 1 -s 0 | grep PhysMem | awk '{print \$6}'";
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(true);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getMemoryInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return default MemoryInfo when nothing return', () async {
          io.ProcessResult totalMemResult = MockProcessResult();
          io.ProcessResult freeMemResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => totalMemResult);
          when(() => totalMemResult.exitCode).thenReturn(0);
          when(() => totalMemResult.stderr).thenReturn('');
          when(() => totalMemResult.stdout).thenReturn('');
          when(
            () => processManager.run(
              captureAny(that: contains(macosFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => freeMemResult);
          when(() => freeMemResult.exitCode).thenReturn(0);
          when(() => freeMemResult.stderr).thenReturn('');
          when(() => freeMemResult.stdout).thenReturn('');
          expect(
            await repository.getMemoryInfo(),
            const MemoryInfo(),
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(macosTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
          verify(
            () => processManager.run(
              captureAny(that: contains(macosFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct MemoryInfo', () async {
          io.ProcessResult totalMemResult = MockProcessResult();
          io.ProcessResult freeMemResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosTotalMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => totalMemResult);
          when(() => totalMemResult.exitCode).thenReturn(0);
          when(() => totalMemResult.stderr).thenReturn('');
          when(() => totalMemResult.stdout).thenReturn(macosTotalMem);
          when(
            () => processManager.run(
              captureAny(that: contains(macosFreeMemCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => freeMemResult);
          when(() => freeMemResult.exitCode).thenReturn(0);
          when(() => freeMemResult.stderr).thenReturn('');
          when(() => freeMemResult.stdout).thenReturn(macosFreeMem);
          expect(
            await repository.getMemoryInfo(),
            const MemoryInfo(
              totalSize: 5712 * 1024,
              freeSize: 2473 * 1024,
            ),
          );
        });
      });
    });
    group('getGpuInfo', () {
      test('throws UnsupportedError on unknown os', () {
        when(() => platform.isLinux).thenReturn(false);
        when(() => platform.isWindows).thenReturn(false);
        when(() => platform.isMacOS).thenReturn(false);
        expect(
          repository.getGpuInfo(),
          throwsA(isA<UnsupportedError>()),
        );
      });
      group('[windows]', () {
        const windowsGpuNameCmd = 'wmic path win32_VideoController get name';
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(true);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getGpuInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return *Detect Unavaliable* when nothing return', () async {
          io.ProcessResult gpuNameResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => gpuNameResult);
          when(() => gpuNameResult.exitCode).thenReturn(0);
          when(() => gpuNameResult.stderr).thenReturn('');
          when(() => gpuNameResult.stdout).thenReturn('');
          expect(
            await repository.getGpuInfo(),
            'Detect Unavaliable',
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(windowsGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct GpuName', () async {
          io.ProcessResult gpuNameResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(windowsGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => gpuNameResult);
          when(() => gpuNameResult.exitCode).thenReturn(0);
          when(() => gpuNameResult.stderr).thenReturn('');
          when(() => gpuNameResult.stdout).thenReturn(windowsGpuName);
          expect(
            await repository.getGpuInfo(),
            'NVIDIA GeForce GTX 1660',
          );
        });
      });
      group('[linux]', () {
        const linuxGpuNameCmd =
            "lshw -c video | grep product | awk '{for(i = 2;i < NF; i++) printf \$i \" \"; print \$NF}'";
        setUp(() {
          when(() => platform.isLinux).thenReturn(true);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getGpuInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return *Detect Unavaliable* when nothing return', () async {
          io.ProcessResult gpuNameResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => gpuNameResult);
          when(() => gpuNameResult.exitCode).thenReturn(0);
          when(() => gpuNameResult.stderr).thenReturn('');
          when(() => gpuNameResult.stdout).thenReturn('');
          expect(
            await repository.getGpuInfo(),
            'Detect Unavaliable',
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(linuxGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct GpuName', () async {
          io.ProcessResult gpuNameResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(linuxGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => gpuNameResult);
          when(() => gpuNameResult.exitCode).thenReturn(0);
          when(() => gpuNameResult.stderr).thenReturn('');
          when(() => gpuNameResult.stdout).thenReturn(linuxGpuName);
          expect(
            await repository.getGpuInfo(),
            'SVGA II Adapter',
          );
        });
      });
      group('[macos]', () {
        const macosGpuNameCmd =
            "system_profiler SPDisplaysDataType | grep Model | awk '{for(i = 3; i < NF; i++) printf \$i \" \"; print \$NF}'";
        setUp(() {
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(true);
        });
        test('throws StdoutException when exitCode is not equal to 0',
            () async {
          io.ProcessResult result = MockProcessResult();
          when(
            () => processManager.run(
              any(),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => result);
          when(() => result.exitCode).thenReturn(127);
          when(() => result.stderr).thenReturn('anything');
          when(() => result.stdout).thenReturn('anything');
          expect(
            repository.getGpuInfo(),
            throwsA(isA<io.StdoutException>()),
          );
        });

        test('return *Detect Unavaliable* when nothing return', () async {
          io.ProcessResult gpuNameResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => gpuNameResult);
          when(() => gpuNameResult.exitCode).thenReturn(0);
          when(() => gpuNameResult.stderr).thenReturn('');
          when(() => gpuNameResult.stdout).thenReturn('');
          expect(
            await repository.getGpuInfo(),
            'Detect Failure',
          );
          verify(
            () => processManager.run(
              captureAny(that: contains(macosGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).called(1);
        });
        test('return correct GpuName', () async {
          io.ProcessResult gpuNameResult = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(that: contains(macosGpuNameCmd)),
              runInShell: true,
              sanitize: false,
              includeParentEnvironment: true,
              stderrEncoding: any(named: 'stderrEncoding'),
              stdoutEncoding: any(named: 'stdoutEncoding'),
            ),
          ).thenAnswer((_) async => gpuNameResult);
          when(() => gpuNameResult.exitCode).thenReturn(0);
          when(() => gpuNameResult.stderr).thenReturn('');
          when(() => gpuNameResult.stdout).thenReturn(macosGpuName);
          expect(
            await repository.getGpuInfo(),
            'NVIDIA GeForce GTX 1660',
          );
        });
      });
    });
  });
}

const windowsCpuName = r'''Name
Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz
''';
const windowsCpuLoad = r'''LoadPercentage
13
''';
const linuxCpuName = r'''Intel(R) core .... GHZ''';
const linuxCpuLoad = r'''1.54456''';
const macosCpuName = r'''Intel(R) core .... GHZ''';
const macosCpuLoad = r'''11.6''';

const windowsTotalMem = r'''TotalVisibleMemorySize
16681340
''';
const windowsFreeMem = r'''FreePhysicalMemory
2819112
''';
const linuxTotalMem = r'''16681340''';
const linuxFreeMem = r'''2819112''';
const macosTotalMem = r'''5712M''';
const macosFreeMem = r'''2473M''';

const windowsGpuName = r'''Name
NVIDIA GeForce GTX 1660
''';
const linuxGpuName = r'''WARNING: you should run this program as super-user.
WARNING: output may be incomplete or inaccurate, you should run this program as super-user.
SVGA II Adapter''';
const macosGpuName = r'''NVIDIA GeForce GTX 1660''';
