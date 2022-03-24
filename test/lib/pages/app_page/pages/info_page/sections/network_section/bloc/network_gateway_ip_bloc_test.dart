import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/bloc/network_gateway_ip_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_repository/network_repository.dart';

class MockNetworkRepository extends Mock implements NetworkRepository {}

void main() {
  late NetworkRepository networkRepository;

  setUp(() {
    networkRepository = MockNetworkRepository();
  });
  group('NetworkGatewayIpBloc', () {
    test('initial state is correct', () {
      expect(
        NetworkGatewayIpBloc(networkRepository: networkRepository).state,
        const NetworkGatewayIpState(),
      );
    });

    blocTest<NetworkGatewayIpBloc, NetworkGatewayIpState>(
      'emits [inProgress, failure] when api exception',
      build: () => NetworkGatewayIpBloc(
        networkRepository: networkRepository,
      ),
      act: (bloc) => bloc.add(
        const NetworkGatewayIpStarted(),
      ),
      setUp: () {
        when(() => networkRepository.getGatewayIps()).thenThrow(Exception());
      },
      expect: () => <NetworkGatewayIpState>[
        const NetworkGatewayIpState(status: NetworkStatus.inProgress),
        const NetworkGatewayIpState(
          status: NetworkStatus.failure,
          ips: [],
        ),
      ],
    );
    blocTest<NetworkGatewayIpBloc, NetworkGatewayIpState>(
      'emits [inProgress, success]',
      build: () => NetworkGatewayIpBloc(
        networkRepository: networkRepository,
      ),
      act: (bloc) => bloc.add(
        const NetworkGatewayIpStarted(),
      ),
      setUp: () {
        when(() => networkRepository.getGatewayIps())
            .thenAnswer((_) async => ['192.168.1.1', '10.0.0.1']);
      },
      expect: () => <NetworkGatewayIpState>[
        const NetworkGatewayIpState(status: NetworkStatus.inProgress),
        const NetworkGatewayIpState(
          status: NetworkStatus.success,
          ips: ['192.168.1.1', '10.0.0.1'],
        ),
      ],
    );
  });
}
