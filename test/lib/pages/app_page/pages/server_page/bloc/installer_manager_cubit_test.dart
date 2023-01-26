import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installer_manager_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_management_repository/server_management_repository.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

class MockServerManagementRepository extends Mock
    implements ServerManagementRepository {}

class MockVanillaServerRepository extends Mock
    implements VanillaServerRepository {}

void main() {
  late ServerManagementRepository serverManagementRepository;
  late VanillaServerRepository vanillaServerRepository;
  setUp(() {
    serverManagementRepository = MockServerManagementRepository();
    vanillaServerRepository = MockVanillaServerRepository();
  });

  final givenVanillaManifestVersionInfo = VanillaManifestVersionInfo(
    id: 'id',
    type: 'type',
    url: 'url',
    time: DateTime.now(),
    releaseTime: DateTime.now(),
  );

  group('InstallerManagerCubit', () {
    group('getInstallers', () {
      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [] when not found anything.',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.getInstallers())
              .thenAnswer((_) => Stream.fromIterable([]));
          when(() => vanillaServerRepository.getServers())
              .thenAnswer((_) async => []);
        },
        act: (cubit) => cubit.getInstallers(),
        expect: () => const <InstallerManagerState>[
          InstallerManagerState(
            status: NetworkStatus.inProgress,
            installers: [],
            vanillaVersions: [],
          ),
          InstallerManagerState(
            status: NetworkStatus.success,
            installers: [],
            vanillaVersions: [],
          ),
        ],
      );
      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, failure] when unexpected.',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.getInstallers())
              .thenThrow(Exception());
        },
        act: (cubit) => cubit.getInstallers(),
        expect: () => const <InstallerManagerState>[
          InstallerManagerState(
            status: NetworkStatus.inProgress,
            installers: [],
            vanillaVersions: [],
          ),
          InstallerManagerState(
            status: NetworkStatus.failure,
            installers: [],
            vanillaVersions: [],
          ),
        ],
      );

      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, success]',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.getInstallers()).thenAnswer(
            (_) => Stream.fromIterable([
              const InstallerFile(
                installer:
                    Installer('name', 'description', JarType.vanilla, 'path'),
                path: 'anypath',
              ),
            ]),
          );
          when(() => vanillaServerRepository.getServers()).thenAnswer(
            (_) async => [givenVanillaManifestVersionInfo],
          );
        },
        act: (cubit) => cubit.getInstallers(),
        expect: () {
          return <InstallerManagerState>[
            const InstallerManagerState(
              status: NetworkStatus.inProgress,
              installers: [],
              vanillaVersions: [],
            ),
            InstallerManagerState(
              status: NetworkStatus.success,
              installers: const [
                InstallerFile(
                  installer:
                      Installer('name', 'description', JarType.vanilla, 'path'),
                  path: 'anypath',
                ),
              ],
              vanillaVersions: [
                givenVanillaManifestVersionInfo,
              ],
            ),
          ];
        },
      );
    });
  });
}
