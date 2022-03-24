import 'package:bloc_test/bloc_test.dart';
import 'package:console_repository/console_repository.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/_utilities/console_line_util.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/installation_cubit.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/server_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/server_machine.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/eula_ask_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/idle_state.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/machine/states/jar_dangerous_ask_state.dart';
import 'package:mocktail/mocktail.dart';

import '../machine/states/jar_analyzer_state_test.dart';

class MockInstallationCubit extends Mock implements InstallationCubit {}

class MockServerMachine extends Mock implements ServerMachine {}

class MockInstaller extends Mock implements Installer {}

class MockEulaAskState extends Mock implements EulaAskState {}

class MockDangerousAskState extends Mock implements JarDangerousAskState {}

class MockIdleState extends Mock implements IdleState {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockInstaller());
  });
  group('ServerBloc', () {
    late InstallationCubit installationCubit;
    late ServerMachine machine;

    setUp(() {
      installationCubit = MockInstallationCubit();
      machine = MockServerMachine();
      when(() => installationCubit.stream)
          .thenAnswer((_) => Stream.fromFutures([]));
      when(() => machine.logStream).thenAnswer((_) => Stream.fromFutures([]));
      when(() => machine.stateStream).thenAnswer((_) => Stream.fromFutures([]));
      when(() => machine.stableStream)
          .thenAnswer((_) => Stream.fromFutures([]));
      when(() => machine.dispose()).thenAnswer((_) async {});
    });

    test('initial state is correct', () {
      final serverBloc =
          ServerBloc(installationCubit: installationCubit, machine: machine);
      expect(serverBloc.state, const ServerState(lines: []));
    });
    group('ProjectCreated', () {
      blocTest<ServerBloc, ServerState>(
        'emits [(isIdle: false)] when nothing emitted from installerCubit',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        act: (bloc) => bloc.add(
          ProjectCreated(
            installer: const Installer(
              'fake',
              'description',
              JarType.vanilla,
              'serverPath',
            ),
            installerPath: 'installerPath',
            serverName: 'serverName',
          ),
        ),
        setUp: () {
          when(
            () => installationCubit.install(
              installer: captureAny(named: 'installer'),
              projectName: captureAny(named: 'projectName'),
              installerPath: captureAny(named: 'installerPath'),
            ),
          ).thenAnswer((_) async {});
        },
        expect: () =>
            <ServerState>[const ServerState(lines: [], isIdle: false)],
        verify: (_) {
          final capture = verify(
            () => installationCubit.install(
              installer: captureAny(named: 'installer'),
              projectName: captureAny(named: 'projectName'),
              installerPath: captureAny(named: 'installerPath'),
            ),
          ).captured;
          expect(capture, [
            const Installer(
              'fake',
              'description',
              JarType.vanilla,
              'serverPath',
            ),
            'serverName',
            'installerPath',
          ]);
        },
      );

      blocTest<ServerBloc, ServerState>(
        'emits [log] when installerCubit.stream emits logs',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(
            () => installationCubit.stream,
          ).thenAnswer(
            (_) => Stream.fromIterable([
              InstallationState(
                logs: generateOneLineConsoleLine('Test Log'),
                projectPath: '1',
                serverName: '2',
                status: NetworkStatus.inProgress,
              )
            ]),
          );
        },
        expect: () => <ServerState>[
          ServerState(
            lines: generateOneLineConsoleLine('Test Log').toList(),
          )
        ],
      );

      blocTest<ServerBloc, ServerState>(
        'emits [log, (success log)] and call machine.start',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(
            () => installationCubit.stream,
          ).thenAnswer(
            (_) => Stream.fromIterable([
              InstallationState(
                logs: generateOneLineConsoleLine('Test Log'),
                projectPath: 'servers/projectName',
                serverName: '2',
                status: NetworkStatus.inProgress,
              ),
              InstallationState(
                logs: generateOneLineConsoleLine('Success'),
                projectPath: 'servers/projectName',
                serverName: '2',
                status: NetworkStatus.success,
              )
            ]),
          );
        },
        expect: () => <ServerState>[
          ServerState(
            lines: generateOneLineConsoleLine('Test Log').toList(),
          ),
          ServerState(
            lines: [
              ...generateOneLineConsoleLine(
                'Test Log',
              ), // should isIdle false If make InstallationState instead of InstallationCubit
              ...generateOneLineConsoleLine('Success'),
            ],
          ),
          const ServerState(lines: [], isIdle: false),
        ],
        verify: (_) {
          expect(
            verify(() => machine.start(captureAny())).captured.last,
            'servers/projectName',
          );
        },
      );

      blocTest<ServerBloc, ServerState>(
        'emits [log, (failure log)]',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(
            () => installationCubit.stream,
          ).thenAnswer(
            (_) => Stream.fromIterable([
              InstallationState(
                logs: generateOneLineConsoleLine('Test Log'),
                projectPath: 'servers/projectName',
                serverName: '2',
                status: NetworkStatus.inProgress,
              ),
              InstallationState(
                logs: generateOneLineConsoleLine('Failure'),
                projectPath: 'servers/projectName',
                serverName: '2',
                status: NetworkStatus.failure,
              )
            ]),
          );
        },
        expect: () => <ServerState>[
          ServerState(
            lines: generateOneLineConsoleLine('Test Log').toList(),
          ),
          ServerState(
            isIdle: true,
            lines: [
              ...generateOneLineConsoleLine('Test Log'),
              ...generateOneLineConsoleLine('Failure')
            ],
          ),
        ],
        verify: (_) {
          verifyNever(() => machine.start(any()));
        },
      );
    });

    group('ProjectSelected', () {
      blocTest<ServerBloc, ServerState>(
        'emits [] and called machine.start',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        act: (bloc) => bloc.add(
          ProjectSelected(
            projectPath: 'servers/projecter',
          ),
        ),
        expect: () =>
            <ServerState>[const ServerState(lines: [], isIdle: false)],
        verify: (_) {
          final capture = verify(
            () => machine.start(
              captureAny(),
            ),
          ).captured;
          expect(capture, ['servers/projecter']);
        },
      );
    });

    group('AgreementConfirmed', () {
      blocTest<ServerBloc, ServerState>(
        'emits [] and called machine.agree',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        act: (bloc) => bloc.add(
          AgreementConfirmed(),
        ),
        expect: () => <ServerState>[],
        verify: (_) {
          verify(
            () => machine.agree(),
          ).called(1);
        },
      );
    });

    group('AgreementRejected', () {
      blocTest<ServerBloc, ServerState>(
        'emits [] and called machine.disagree',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        act: (bloc) => bloc.add(
          AgreementRejected(),
        ),
        expect: () => <ServerState>[],
        verify: (_) {
          verify(
            () => machine.disagree(),
          ).called(1);
        },
      );
    });

    group('CommandInputted', () {
      blocTest<ServerBloc, ServerState>(
        'emits [] and called machine.input with correct command',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        act: (bloc) => bloc.add(
          CommandInputted(command: 'help!'),
        ),
        expect: () => <ServerState>[],
        verify: (_) {
          verify(
            () => machine.input('help!'),
          ).called(1);
        },
      );
    });

    group('StopCommandInputted', () {
      blocTest<ServerBloc, ServerState>(
        'emits [] and called machine.input with stop command',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        act: (bloc) => bloc.add(
          StopCommandInputted(),
        ),
        expect: () => <ServerState>[],
        verify: (_) {
          verify(
            () => machine.input('stop'),
          ).called(1);
        },
      );
    });

    group('_UserActionNeeded', () {
      blocTest<ServerBloc, ServerState>(
        'emits [eula] and when stateStream is EulaAskState',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(() => machine.stateStream).thenAnswer(
            (_) => Stream.fromIterable([MockEulaAskState()]),
          );
        },
        expect: () => <ServerState>[
          const ServerState(type: ServerType.eula, lines: []),
          const ServerState(type: ServerType.eula, lines: [], isIdle: false),
        ],
      );

      blocTest<ServerBloc, ServerState>(
        'emits [dangerous] and when stateStream is JarDangerousAskState',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(() => machine.stateStream).thenAnswer(
            (_) => Stream.fromIterable([MockJarDangerousAskState()]),
          );
        },
        expect: () => <ServerState>[
          const ServerState(type: ServerType.dangerous, lines: []),
          const ServerState(
            type: ServerType.dangerous,
            lines: [],
            isIdle: false,
          ),
        ],
      );

      blocTest<ServerBloc, ServerState>(
        'emits [eula, none] and when stateStream emits eula then idle (_MachineIdleChanged)',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(() => machine.stateStream).thenAnswer(
            (_) => Stream.fromIterable([MockEulaAskState(), MockIdleState()]),
          );
        },
        expect: () => <ServerState>[
          const ServerState(type: ServerType.eula, lines: []),
          const ServerState(
            type: ServerType.eula,
            lines: [],
            isIdle: false,
          ),
          const ServerState(
            type: ServerType.eula,
            lines: [],
            isIdle: true,
          ),
          const ServerState(
            type: ServerType.none,
            lines: [],
            isIdle: true,
          ),
        ],
      );
    });

    group('_MachineStableFetched', () {
      blocTest<ServerBloc, ServerState>(
        'emits [false, true] and when stableStream changed',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(() => machine.stableStream).thenAnswer(
            (_) => Stream.fromIterable([false, true]),
          );
        },
        expect: () => <ServerState>[
          const ServerState(lines: [], stable: false),
          const ServerState(lines: [], stable: true),
        ],
      );
    });

    group('_LogChanged', () {
      blocTest<ServerBloc, ServerState>(
        'emits log limit up to 100',
        build: () => ServerBloc(
          installationCubit: installationCubit,
          machine: machine,
        ),
        setUp: () {
          when(() => machine.logStream).thenAnswer(
            (_) => getFakeLogsStream(105),
          );
        },
        expect: () => <ServerState>[
          ServerState(lines: getFakeLogs(100, 5).toList()),
        ],
      );

      // bufferTime will fail on the slow machine... so comment out for unit test consistent...
      // blocTest<ServerBloc, ServerState>(
      //   'emits log and cut by .bufferTime(const Duration(milliseconds: 500))',
      //   build: () => ServerBloc(
      //     installationCubit: installationCubit,
      //     machine: machine,
      //   ),
      //   setUp: () {
      //     when(() => machine.logStream).thenAnswer(
      //       (_) => getFakeLogsStream(20, 0, 100),
      //     );
      //   },
      //   wait: const Duration(milliseconds: 2200),
      //   expect: () => <ServerState>[
      //     ServerState(lines: getFakeLogs(5, 0).toList()),
      //     ServerState(lines: getFakeLogs(10, 0).toList()),
      //     ServerState(lines: getFakeLogs(15, 0).toList()),
      //     ServerState(lines: getFakeLogs(20, 0).toList()),
      //   ],
      // );
    });
  });
}

Iterable<ConsoleLine> getFakeLogs(int count, [int from = 0]) sync* {
  for (int i = from; i < from + count; i++) {
    for (final line in generateOneLineConsoleLine('$i')) {
      yield line;
    }
  }
}

Stream<Iterable<ConsoleLine>> getFakeLogsStream(
  int count, [
  int from = 0,
  int delay = 0,
]) async* {
  for (int i = from; i < from + count; i++) {
    if (delay != 0) await Future.delayed(Duration(milliseconds: delay));

    yield generateOneLineConsoleLine('$i');
  }
}
