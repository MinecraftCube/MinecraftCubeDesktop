import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installer_manager_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_management_repository/server_management_repository.dart';

class MockServerManagementRepository extends Mock
    implements ServerManagementRepository {}

void main() {
  late ServerManagementRepository serverManagementRepository;
  setUp(() {
    serverManagementRepository = MockServerManagementRepository();
  });

  group('InstallerManagerCubit', () {
    group('getInstallers', () {
      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [] when not found anything.',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
        ),
        setUp: () {
          when(() => serverManagementRepository.getInstallers())
              .thenAnswer((_) => Stream.fromIterable([]));
        },
        act: (cubit) => cubit.getInstallers(),
        expect: () => const <InstallerManagerState>[
          InstallerManagerState(
            status: NetworkStatus.inProgress,
            installers: [],
          ),
          InstallerManagerState(status: NetworkStatus.success, installers: []),
        ],
      );
      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, failure] when unexpected.',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
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
          ),
          InstallerManagerState(status: NetworkStatus.failure, installers: []),
        ],
      );

      blocTest<InstallerManagerCubit, InstallerManagerState>(
        'emits [loading, success]',
        build: () => InstallerManagerCubit(
          serverManagementRepository: serverManagementRepository,
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
        },
        act: (cubit) => cubit.getInstallers(),
        expect: () {
          return const <InstallerManagerState>[
            InstallerManagerState(
              status: NetworkStatus.inProgress,
              installers: [],
            ),
            InstallerManagerState(
              status: NetworkStatus.success,
              installers: [
                InstallerFile(
                  installer:
                      Installer('name', 'description', JarType.vanilla, 'path'),
                  path: 'anypath',
                ),
              ],
            ),
          ];
        },
      );
    });
  });
}
