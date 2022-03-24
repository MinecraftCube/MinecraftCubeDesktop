import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/bloc/network_public_ip_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_repository/network_repository.dart';

class MockNetworkRepository extends Mock implements NetworkRepository {}

void main() {
  late NetworkRepository networkRepository;

  setUp(() {
    networkRepository = MockNetworkRepository();
  });
  group('NetworkPublicIpBloc', () {
    test('initial state is correct', () {
      expect(
        NetworkPublicIpBloc(networkRepository: networkRepository).state,
        const NetworkPublicIpState(),
      );
    });

    blocTest<NetworkPublicIpBloc, NetworkPublicIpState>(
      'emits [inProgress, failure] when api exception',
      build: () => NetworkPublicIpBloc(
        networkRepository: networkRepository,
      ),
      act: (bloc) => bloc.add(
        const NetworkPublicIpStarted(),
      ),
      setUp: () {
        when(() => networkRepository.getPublicIp()).thenThrow(Exception());
      },
      expect: () => <NetworkPublicIpState>[
        const NetworkPublicIpState(status: NetworkStatus.inProgress),
        const NetworkPublicIpState(
          status: NetworkStatus.failure,
          ip: 'Unavailable',
        ),
      ],
    );
    blocTest<NetworkPublicIpBloc, NetworkPublicIpState>(
      'emits [inProgress, success]',
      build: () => NetworkPublicIpBloc(
        networkRepository: networkRepository,
      ),
      act: (bloc) => bloc.add(
        const NetworkPublicIpStarted(),
      ),
      setUp: () {
        when(() => networkRepository.getPublicIp())
            .thenAnswer((_) async => '111.123.187.210');
      },
      expect: () => <NetworkPublicIpState>[
        const NetworkPublicIpState(status: NetworkStatus.inProgress),
        const NetworkPublicIpState(
          status: NetworkStatus.success,
          ip: '111.123.187.210',
        ),
      ],
    );
  });
}
