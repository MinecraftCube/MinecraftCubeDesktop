import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launcher_repository/launcher_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/server_management_launcher_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_management_repository/server_management_repository.dart';

class MockServerManagementRepository extends Mock
    implements ServerManagementRepository {}

class MockLauncherRepository extends Mock implements LauncherRepository {}

void main() {
  late ServerManagementRepository serverManagementRepository;
  late LauncherRepository launcherRepository;
  setUp(() {
    serverManagementRepository = MockServerManagementRepository();
    launcherRepository = MockLauncherRepository();
  });

  group('ServerManagementLauncherCubit', () {
    group('launch', () {
      blocTest<ServerManagementLauncherCubit, ServerManagementLauncherState>(
        'emits [] when null input.',
        build: () => ServerManagementLauncherCubit(
          launcherRepository: launcherRepository,
          serverManagementRepository: serverManagementRepository,
        ),
        act: (cubit) => cubit.launch(null),
        expect: () => const <ServerManagementLauncherState>[],
      );
      blocTest<ServerManagementLauncherCubit, ServerManagementLauncherState>(
        'emits [loading, failure] when laucnh failed.',
        build: () => ServerManagementLauncherCubit(
          launcherRepository: launcherRepository,
          serverManagementRepository: serverManagementRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.createServersDir())
              .thenAnswer((_) async => 'servers');
          when(() => launcherRepository.launch(path: any(named: 'path')))
              .thenThrow(Exception());
        },
        act: (cubit) => cubit.launch(ServerManagementLauncherType.servers),
        expect: () => const <ServerManagementLauncherState>[
          ServerManagementLauncherState(status: NetworkStatus.inProgress),
          ServerManagementLauncherState(status: NetworkStatus.failure),
        ],
      );

      blocTest<ServerManagementLauncherCubit, ServerManagementLauncherState>(
        'emits [loading, success] on servers',
        build: () => ServerManagementLauncherCubit(
          launcherRepository: launcherRepository,
          serverManagementRepository: serverManagementRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.createServersDir())
              .thenAnswer((_) async => 'servers');
          when(() => launcherRepository.launch(path: captureAny(named: 'path')))
              .thenAnswer((_) async => true);
        },
        act: (cubit) => cubit.launch(ServerManagementLauncherType.servers),
        expect: () {
          expect(
            verify(
              () => launcherRepository.launch(path: captureAny(named: 'path')),
            ).captured.last,
            'file:servers',
          );
          return const <ServerManagementLauncherState>[
            ServerManagementLauncherState(status: NetworkStatus.inProgress),
            ServerManagementLauncherState(status: NetworkStatus.success),
          ];
        },
      );

      blocTest<ServerManagementLauncherCubit, ServerManagementLauncherState>(
        'emits [loading, success] on servers',
        build: () => ServerManagementLauncherCubit(
          launcherRepository: launcherRepository,
          serverManagementRepository: serverManagementRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.createInstallersDir())
              .thenAnswer((_) async => 'installers');
          when(() => launcherRepository.launch(path: captureAny(named: 'path')))
              .thenAnswer((_) async => true);
        },
        act: (cubit) => cubit.launch(ServerManagementLauncherType.installers),
        expect: () {
          expect(
            verify(
              () => launcherRepository.launch(path: captureAny(named: 'path')),
            ).captured.last,
            'file:installers',
          );
          return const <ServerManagementLauncherState>[
            ServerManagementLauncherState(status: NetworkStatus.inProgress),
            ServerManagementLauncherState(status: NetworkStatus.success),
          ];
        },
      );
    });
  });
}
