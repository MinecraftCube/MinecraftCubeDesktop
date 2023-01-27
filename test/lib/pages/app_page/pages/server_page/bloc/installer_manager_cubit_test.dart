import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installer_creator_repository/installer_creator_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installer_manager_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_management_repository/server_management_repository.dart';
import 'package:vanilla_server_repository/vanilla_server_repository.dart';

class MockServerManagementRepository extends Mock
    implements ServerManagementRepository {}

class MockVanillaServerRepository extends Mock
    implements VanillaServerRepository {}

class MockInstallerCreatorRepository extends Mock
    implements InstallerCreatorRepository {}

void main() {
  late ServerManagementRepository serverManagementRepository;
  late VanillaServerRepository vanillaServerRepository;
  late InstallerCreatorRepository installerCreatorRepository;
  setUp(() {
    serverManagementRepository = MockServerManagementRepository();
    vanillaServerRepository = MockVanillaServerRepository();
    installerCreatorRepository = MockInstallerCreatorRepository();
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
          installerCreatorRepository: installerCreatorRepository,
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
          installerCreatorRepository: installerCreatorRepository,
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
          installerCreatorRepository: installerCreatorRepository,
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

    group('getVanillaInstaller', () {
      const url = 'targetUrl';
      const name = 'name';
      const description = 'description';
      const server = 'server';
      const type = JarType.vanilla;
      final vanillaManifestInfo = VanillaManifestVersionInfo(
        id: 'id',
        type: 'type',
        url: url,
        time: DateTime.now(),
        releaseTime: DateTime.now(),
      );
      const vanillaServerDownloadServerInfo =
          VanillaServerDownloadsServerInfo(sha1: '1', size: 1, url: '1');

      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, failure] when getServerByVersionInfo throws',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
          installerCreatorRepository: installerCreatorRepository,
        ),
        setUp: () {
          when(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).thenThrow(
            Exception(),
          );
          when(
            () => serverManagementRepository.createInstallersDir(
              subfolder: '_vanilla',
            ),
          ).thenAnswer((_) async => '');
          when(
            () => installerCreatorRepository.create(
              name: captureAny(named: 'name'),
              description: captureAny(named: 'description'),
              server: captureAny(named: 'server'),
              pack: captureAny(named: 'pack'),
              map: captureAny(named: 'map'),
              settings: captureAny(named: 'settings'),
              type: JarType.vanilla,
              subfolder: '_vanilla',
            ),
          ).thenAnswer(
            (_) async =>
                const MapEntry('', Installer(name, description, type, server)),
          );
        },
        act: (cubit) =>
            cubit.getVanillaInstaller(vanillaManifest: vanillaManifestInfo),
        expect: () {
          return <InstallerManagerState>[
            const InstallerManagerState(
              status: NetworkStatus.inProgress,
              installers: [],
              vanillaVersions: [],
            ),
            const InstallerManagerState(
              status: NetworkStatus.failure,
              installers: [],
              vanillaVersions: [],
            ),
          ];
        },
        verify: (_) {
          final captured = verify(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).captured;
          expect(captured, [url]);
        },
      );

      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, failure] when createInstallersDir throws',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
          installerCreatorRepository: installerCreatorRepository,
        ),
        setUp: () {
          when(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).thenAnswer(
            (_) async => vanillaServerDownloadServerInfo,
          );
          when(
            () => serverManagementRepository.createInstallersDir(
              subfolder: '_vanilla',
            ),
          ).thenThrow(Exception());
          when(
            () => installerCreatorRepository.create(
              name: captureAny(named: 'name'),
              description: captureAny(named: 'description'),
              server: captureAny(named: 'server'),
              pack: captureAny(named: 'pack'),
              map: captureAny(named: 'map'),
              settings: captureAny(named: 'settings'),
              type: JarType.vanilla,
              subfolder: '_vanilla',
            ),
          ).thenAnswer(
            (_) async =>
                const MapEntry('', Installer(name, description, type, server)),
          );
        },
        act: (cubit) =>
            cubit.getVanillaInstaller(vanillaManifest: vanillaManifestInfo),
        expect: () {
          return <InstallerManagerState>[
            const InstallerManagerState(
              status: NetworkStatus.inProgress,
              installers: [],
              vanillaVersions: [],
            ),
            const InstallerManagerState(
              status: NetworkStatus.failure,
              installers: [],
              vanillaVersions: [],
            ),
          ];
        },
        verify: (_) {
          final captured = verify(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).captured;
          expect(captured, [url]);
        },
      );

      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, failure] when installerCreatorRepository.create throws',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
          installerCreatorRepository: installerCreatorRepository,
        ),
        setUp: () {
          when(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).thenAnswer(
            (_) async => vanillaServerDownloadServerInfo,
          );
          when(
            () => serverManagementRepository.createInstallersDir(
              subfolder: '_vanilla',
            ),
          ).thenAnswer((_) async => '');
          when(
            () => installerCreatorRepository.create(
              name: captureAny(named: 'name'),
              description: captureAny(named: 'description'),
              server: captureAny(named: 'server'),
              pack: captureAny(named: 'pack'),
              map: captureAny(named: 'map'),
              settings: captureAny(named: 'settings'),
              type: JarType.vanilla,
              subfolder: '_vanilla',
            ),
          ).thenThrow(
            Exception(),
          );
        },
        act: (cubit) =>
            cubit.getVanillaInstaller(vanillaManifest: vanillaManifestInfo),
        expect: () {
          return <InstallerManagerState>[
            const InstallerManagerState(
              status: NetworkStatus.inProgress,
              installers: [],
              vanillaVersions: [],
            ),
            const InstallerManagerState(
              status: NetworkStatus.failure,
              installers: [],
              vanillaVersions: [],
            ),
          ];
        },
        verify: (_) {
          final captured = verify(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).captured;
          expect(captured, [url]);
        },
      );

      const entry =
          MapEntry('installerPath', Installer(name, description, type, server));
      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, success]',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
          vanillaServerRepository: vanillaServerRepository,
          installerCreatorRepository: installerCreatorRepository,
        ),
        setUp: () {
          when(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).thenAnswer(
            (_) async => vanillaServerDownloadServerInfo,
          );
          when(
            () => serverManagementRepository.createInstallersDir(
              subfolder: '_vanilla',
            ),
          ).thenAnswer((_) async => '');
          when(
            () => installerCreatorRepository.create(
              name: captureAny(named: 'name'),
              description: captureAny(named: 'description'),
              server: captureAny(named: 'server'),
              pack: captureAny(named: 'pack'),
              map: captureAny(named: 'map'),
              settings: captureAny(named: 'settings'),
              type: JarType.vanilla,
              subfolder: '_vanilla',
            ),
          ).thenAnswer(
            (_) async => entry,
          );
        },
        act: (cubit) async {
          final result = await cubit.getVanillaInstaller(
            vanillaManifest: vanillaManifestInfo,
          );
          expect(
            result,
            InstallerFile(
              installer: entry.value,
              path: entry.key,
            ),
          );
        },
        expect: () {
          return <InstallerManagerState>[
            const InstallerManagerState(
              status: NetworkStatus.inProgress,
              installers: [],
              vanillaVersions: [],
            ),
            const InstallerManagerState(
              status: NetworkStatus.success,
              installers: [],
              vanillaVersions: [],
            ),
          ];
        },
        verify: (_) {
          final captured = verify(
            () => vanillaServerRepository.getServerByVersionInfo(
              url: captureAny(named: 'url'),
            ),
          ).captured;
          expect(captured, [url]);
        },
      );
    });
  });
}
