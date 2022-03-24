import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/bloc/network_internal_ip_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_repository/network_repository.dart';

class MockNetworkRepository extends Mock implements NetworkRepository {}

class MockNetworkInterface extends Mock implements NetworkInterface {}

class MockInternetAddress extends Mock implements InternetAddress {}

void main() {
  late NetworkRepository networkRepository;

  setUp(() {
    networkRepository = MockNetworkRepository();
  });
  group('NetworkInternalIpBloc', () {
    test('initial state is correct', () {
      expect(
        NetworkInternalIpBloc(networkRepository: networkRepository).state,
        const NetworkInternalIpState(),
      );
    });

    blocTest<NetworkInternalIpBloc, NetworkInternalIpState>(
      'emits [inProgress, failure] when api exception',
      build: () => NetworkInternalIpBloc(
        networkRepository: networkRepository,
      ),
      act: (bloc) => bloc.add(
        const NetworkInternalIpStarted(),
      ),
      setUp: () {
        when(() => networkRepository.getInternalIps()).thenThrow(Exception());
      },
      expect: () => <NetworkInternalIpState>[
        const NetworkInternalIpState(status: NetworkStatus.inProgress),
        const NetworkInternalIpState(
          status: NetworkStatus.failure,
          ips: [],
        ),
      ],
    );

    group('success', () {
      NetworkInterface interfaceA = MockNetworkInterface();
      NetworkInterface interfaceB = MockNetworkInterface();
      InternetAddress addressAA = MockInternetAddress();
      InternetAddress addressAB = MockInternetAddress();
      InternetAddress addressBA = MockInternetAddress();
      InternetAddress addressBB = MockInternetAddress();
      setUp(() {
        when(() => interfaceA.name).thenReturn('INTERFACE_A');
        when(() => interfaceA.addresses).thenReturn([addressAA, addressAB]);
        when(() => addressAA.address).thenReturn('192.168.1.5');
        when(() => addressAB.address).thenReturn('192.168.1.10');
        when(() => interfaceB.name).thenReturn('INTERFACE_B');
        when(() => interfaceB.addresses).thenReturn([addressBA, addressBB]);
        when(() => addressBA.address).thenReturn('192.168.1.15');
        when(() => addressBB.address).thenReturn('192.168.1.20');
      });
      blocTest<NetworkInternalIpBloc, NetworkInternalIpState>(
        'emits [inProgress, success]',
        build: () => NetworkInternalIpBloc(
          networkRepository: networkRepository,
        ),
        act: (bloc) => bloc.add(
          const NetworkInternalIpStarted(),
        ),
        setUp: () {
          when(() => networkRepository.getInternalIps()).thenAnswer(
            (_) async => [interfaceA, interfaceB],
          );
        },
        expect: () => <NetworkInternalIpState>[
          const NetworkInternalIpState(status: NetworkStatus.inProgress),
          NetworkInternalIpState(
            status: NetworkStatus.success,
            ips: [interfaceA, interfaceB],
          ),
        ],
      );
    });
  });
}
