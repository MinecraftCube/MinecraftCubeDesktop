import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_repository/network_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_repository/src/network_interface_wrapper.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcessResult extends Mock implements io.ProcessResult {}

class MockNetworkInterface extends Mock implements io.NetworkInterface {}

class MockInternetAddressType extends Mock implements io.InternetAddressType {}

class MockNetworkInterfaceWrapper extends Mock
    implements NetworkInterfaceWrapper {}

class MockPlatform extends Mock implements Platform {}

class MockDio extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockInternetAddressType());
  });
  group('NetworkRepository', () {
    late Platform platform;
    late ProcessManager processManager;
    late NetworkInterfaceWrapper networkInterface;
    late NetworkRepository repository;
    late Dio dio;

    setUp(
      () {
        processManager = MockProcessManager();
        platform = MockPlatform();
        networkInterface = MockNetworkInterfaceWrapper();
        dio = MockDio();
        repository = NetworkRepository(
          dio: dio,
          networkInterface: networkInterface,
          platform: platform,
          processManager: processManager,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(NetworkRepository(), isNotNull);
      });
    });

    group('getPublicIp', () {
      test('return Service Unavailable when nothing return', () async {
        final response = MockResponse<String>();
        when(() => dio.get<String>(captureAny()))
            .thenAnswer((_) async => response);
        when(() => response.data).thenReturn(null);
        expect(await repository.getPublicIp(), 'Service Unavailable');
        final captured = verify(() => dio.get<String>(captureAny())).captured;
        expect(captured.last, 'https://api.ipify.org');
      });

      test('return Service Unavailable when empty return', () async {
        final response = MockResponse<String>();
        when(() => dio.get<String>(captureAny()))
            .thenAnswer((_) async => response);
        when(() => response.data).thenReturn('');
        expect(await repository.getPublicIp(), 'Service Unavailable');
      });

      test('return IP when service available', () async {
        const data = '111.234.124.87';
        final response = MockResponse<String>();
        when(() => dio.get<String>(captureAny()))
            .thenAnswer((_) async => response);
        when(() => response.data).thenReturn(data);
        expect(await repository.getPublicIp(), data);
      });
    });

    group('getInternalIps', () {
      test('return [] when dart unsupport the feature on the os', () async {
        when(() => networkInterface.supported).thenReturn(false);
        expect(await repository.getInternalIps(), []);
      });
      test('return [NetworkInterfaces]', () async {
        io.NetworkInterface networkInterfaceA = MockNetworkInterface();
        io.NetworkInterface networkInterfaceB = MockNetworkInterface();
        when(() => networkInterface.supported).thenReturn(true);
        when(
          () => networkInterface.list(
            includeLinkLocal: any(named: 'includeLinkLocal'),
            includeLoopback: any(named: 'includeLoopback'),
            type: any(named: 'type'),
          ),
        ).thenAnswer(
          (_) async => [networkInterfaceA, networkInterfaceB],
        );
        expect(
          await repository.getInternalIps(),
          equals([networkInterfaceA, networkInterfaceB]),
        );
      });
    });

    group('getGatewayIps', () {
      group('[uknown os]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws UnsupportedError on unknown os', () async {
          expect(repository.getGatewayIps(), throwsUnsupportedError);
        });
      });
      group('[windows]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(true);
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws GatewayUnexpectedException when error code appears',
            () async {
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('anything');
          when(() => result.stderr).thenReturn('anything');
          when(() => result.exitCode).thenReturn(127);
          expect(
            repository.getGatewayIps(),
            throwsA(isA<GatewayUnexpectedException>()),
          );
        });
        test('return empty List when no error code and empty output', () async {
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('');
          when(() => result.stderr).thenReturn('');
          when(() => result.exitCode).thenReturn(0);
          expect(
            await repository.getGatewayIps(),
            [],
          );
        });
        test('return correct gateway ip', () async {
          const command = 'chcp 65001 && ipconfig';
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn(windowsGatewayRaw);
          when(() => result.stderr).thenReturn('');
          when(() => result.exitCode).thenReturn(0);
          expect(
            await repository.getGatewayIps(),
            ['192.168.1.1'],
          );
          final capturedCmd = verify(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).captured;
          expect(capturedCmd.last, [command]);
        });
      });
      group('[linux]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isLinux).thenReturn(true);
          when(() => platform.isMacOS).thenReturn(false);
        });
        test('throws GatewayUnexpectedException when error code appears',
            () async {
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('anything');
          when(() => result.stderr).thenReturn('anything');
          when(() => result.exitCode).thenReturn(127);
          expect(
            repository.getGatewayIps(),
            throwsA(isA<GatewayUnexpectedException>()),
          );
        });
        test('return empty List when no error code and empty output', () async {
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('');
          when(() => result.stderr).thenReturn('');
          when(() => result.exitCode).thenReturn(0);
          expect(
            await repository.getGatewayIps(),
            [],
          );
        });
        test('return correct gateway ip', () async {
          const command =
              'ip route show default | awk \'/default/ {print \$3}\'';
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('192.168.1.8');
          when(() => result.stderr).thenReturn('');
          when(() => result.exitCode).thenReturn(0);
          expect(
            await repository.getGatewayIps(),
            ['192.168.1.8'],
          );
          final capturedCmd = verify(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).captured;
          expect(capturedCmd.last, [command]);
        });
      });
      group('[macos]', () {
        setUp(() {
          when(() => platform.isWindows).thenReturn(false);
          when(() => platform.isLinux).thenReturn(false);
          when(() => platform.isMacOS).thenReturn(true);
        });
        test('throws GatewayUnexpectedException when error code appears',
            () async {
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('anything');
          when(() => result.stderr).thenReturn('anything');
          when(() => result.exitCode).thenReturn(127);
          expect(
            repository.getGatewayIps(),
            throwsA(isA<GatewayUnexpectedException>()),
          );
        });
        test('return empty List when no error code and empty output', () async {
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('');
          when(() => result.stderr).thenReturn('');
          when(() => result.exitCode).thenReturn(0);
          expect(
            await repository.getGatewayIps(),
            [],
          );
        });
        test('return correct gateway ip', () async {
          const command = 'netstat -rn | grep "default" | awk \'{print \$2}\'';
          final result = MockProcessResult();
          when(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).thenAnswer((_) async => result);
          when(() => result.stdout).thenReturn('192.168.1.8');
          when(() => result.stderr).thenReturn('');
          when(() => result.exitCode).thenReturn(0);
          expect(
            await repository.getGatewayIps(),
            ['192.168.1.8'],
          );
          final capturedCmd = verify(
            () => processManager.run(
              captureAny(),
              sanitize: false,
              runInShell: true,
              includeParentEnvironment: true,
            ),
          ).captured;
          expect(capturedCmd.last, [command]);
        });
      });
    });
  });
}

const windowsGatewayRaw = r'''Windows IP Configuration
Ethernet adapter Hamachi:

   Connection-specific DNS Suffix  . :
   IPv6 Address. . . . . . . . . . . : 2620:9b::192e:19f2
   Link-local IPv6 Address . . . . . : fe80::8d90:cf49:f6b6:5caf%9
   IPv4 Address. . . . . . . . . . . : 25.46.25.242
   Subnet Mask . . . . . . . . . . . : 255.0.0.0
   Default Gateway . . . . . . . . . : 2620:9b::1900:1

Ethernet adapter 區域連線* 2:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . :

Ethernet adapter 乙太網路 3:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::48d0:ea57:aa73:4da1%3
   IPv4 Address. . . . . . . . . . . : 192.168.42.1
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :

Ethernet adapter 乙太網路 6:

   Connection-specific DNS Suffix  . :
   IPv6 Address. . . . . . . . . . . : 2001:b011:3807:146c:9da0:3556:dfc5:b8fa
   Temporary IPv6 Address. . . . . . : 2001:b011:3807:146c:c9e4:c231:2990:969d
   Link-local IPv6 Address . . . . . : fe80::9da0:3556:dfc5:b8fa%23
   IPv4 Address. . . . . . . . . . . : 192.168.1.108
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : fe80::ee43:f6ff:feec:53ef%23
                                       192.168.1.1''';
