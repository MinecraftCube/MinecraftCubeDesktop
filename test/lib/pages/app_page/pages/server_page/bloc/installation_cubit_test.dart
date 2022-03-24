import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installer_repository/installer_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installation_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockInstallerRepository extends Mock implements InstallerRepository {}

// https://github.com/felangel/bloc/issues/3254
void main() {
  late InstallerRepository installerRepository;
  setUp(() {
    installerRepository = MockInstallerRepository();
  });
  group('InstallationCubit', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => InstallationCubit(installerRepository: installerRepository),
      expect: () => [],
    );
    group('Install', () {
      const installerPath = '/path/to/installer.dmc';
      const serverName = 'vanilla_official_1.18.2';
      const installer = Installer(
        'official1.18.2',
        'nothingdesc',
        JarType.vanilla,
        'https://localhost.com/dmc',
        mapZipPath: 'https://localhost/map.zip',
        modelPack: ModelPack(path: 'https://localhost.com/moppack.zip'),
        modelSettings: [
          ModelSetting(
            name: 'modA',
            program: 'mod_a.jar',
            path: 'https://localhost/modA.zip',
          ),
          ModelSetting(
            name: 'modB',
            program: 'mod_b.jar',
            path: 'https://localhost/modB.zip',
          ),
        ],
      );
      late InstallationCubit installationCubit;
      setUp(() {
        installationCubit =
            InstallationCubit(installerRepository: installerRepository);
      });

      test('emits [uninit, failure] when createProject throws exception',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenThrow(Exception());

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final captured = verify(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).captured;
        expect(captured.last, serverName);

        final expectStates = [NetworkStatus.uninit, NetworkStatus.failure];
        expect(states.length, states.length);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
        }
      });

      test(
          'emits [uninit, inProgrss, inProgrss, failure] when copyInstaller throws exception',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => 'servers/newProject');
        when(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenThrow(Exception());

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final captured = verify(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).captured;
        expect(captured.first, installerPath);
        expect(captured.last, serverName);

        final expectStates = [
          NetworkStatus.uninit,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.failure
        ];
        expect(states.length, 4);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
          if (i > 1) {
            expect(states[i].projectPath, 'servers/newProject');
          }
        }
      });

      test(
          'emits [uninit, inProgrss, inProgrss, inProgrss, failure] when installMap throws exception',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => '');
        when(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => {});
        when(
          () => installerRepository.installMap(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenThrow(Exception());

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final captured = verify(
          () => installerRepository.installMap(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).captured;
        expect(captured.first, installer.mapZipPath);
        expect(captured.last, serverName);

        final expectStates = [
          NetworkStatus.uninit,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.failure
        ];
        expect(states.length, expectStates.length);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
        }
      });

      test(
          'emits [uninit, inProgrss, inProgrss, inProgrss, inProgrss, failure] when installMod throws exception',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => '');
        when(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => {});
        when(
          () => installerRepository.installMap(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installMod(
            url: captureAny(named: 'url'),
            modName: captureAny(named: 'modName'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenThrow(Exception());

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final expectStates = [
          NetworkStatus.uninit,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.failure
        ];
        expect(states.length, expectStates.length);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
        }
      });

      test(
          'emits [uninit, inProgrss, inProgrss, inProgrss, inProgrss, 2xinProgrss, failure] when installModpack throws exception',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => '');
        when(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => {});
        when(
          () => installerRepository.installMap(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installMod(
            url: captureAny(named: 'url'),
            modName: captureAny(named: 'modName'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installModpack(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenThrow(Exception());

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final captured = verify(
          () => installerRepository.installMod(
            url: captureAny(named: 'url'),
            modName: captureAny(named: 'modName'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).captured;
        expect(captured, [
          installer.modelSettings[0].path,
          installer.modelSettings[0].program,
          serverName,
          installer.modelSettings[1].path,
          installer.modelSettings[1].program,
          serverName,
        ]);

        final expectStates = [
          NetworkStatus.uninit,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.failure
        ];
        expect(states.length, expectStates.length);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
        }
      });

      test(
          'emits [uninit, inProgrss, inProgrss, inProgrss, inProgrss, 2xinProgrss, inProgrss, failure] when installServer throws exception',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => '');
        when(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => {});
        when(
          () => installerRepository.installMap(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installMod(
            url: captureAny(named: 'url'),
            modName: captureAny(named: 'modName'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installModpack(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final captured = verify(
          () => installerRepository.installModpack(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).captured;
        expect(captured, [installer.modelPack?.path, serverName]);

        final expectStates = [
          NetworkStatus.uninit,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.failure
        ];
        expect(states.length, expectStates.length);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
        }
      });

      test(
          'emits [uninit, inProgrss, inProgrss, inProgrss, inProgrss, 2xinProgrss, inProgrss, success] when everything complete',
          () async {
        when(
          () => installerRepository.createProject(
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => '');
        when(
          () => installerRepository.copyInstaller(
            installerPath: captureAny(named: 'installerPath'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) async => {});
        when(
          () => installerRepository.installMap(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installMod(
            url: captureAny(named: 'url'),
            modName: captureAny(named: 'modName'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installModpack(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));
        when(
          () => installerRepository.installServer(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).thenAnswer((_) => Stream.fromIterable([]));

        final List<InstallationState> states = [];
        final sub = installationCubit.stream.listen(states.add);

        await installationCubit.install(
          installer: installer,
          projectName: serverName,
          installerPath: installerPath,
        );
        await installationCubit.close();
        await sub.cancel();

        final captured = verify(
          () => installerRepository.installServer(
            url: captureAny(named: 'url'),
            projectName: captureAny(named: 'projectName'),
          ),
        ).captured;
        expect(captured, [installer.serverPath, serverName]);

        final expectStates = [
          NetworkStatus.uninit,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.inProgress,
          NetworkStatus.success
        ];
        expect(states.length, expectStates.length);
        for (int i = 0; i < states.length; i++) {
          expect(states[i].status, expectStates[i]);
        }
      });
    });
  });
}
