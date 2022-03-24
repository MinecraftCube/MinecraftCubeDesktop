import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/servers_dropdown_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_management_repository/server_management_repository.dart';

class MockServerManagementRepository extends Mock
    implements ServerManagementRepository {}

class MockTicker extends Mock implements Ticker {}

void main() {
  late ServerManagementRepository serverManagementRepository;
  late Ticker ticker;
  setUp(() {
    serverManagementRepository = MockServerManagementRepository();
    ticker = MockTicker();
    when(() => ticker.loop(period: 2)).thenAnswer((_) async* {});
  });
  group('ServersDropdownBloc', () {
    test('initial state is LoginState', () async {
      final bloc = ServersDropdownBloc(
        serverManagementRepository: serverManagementRepository,
        ticker: ticker,
      );
      expect(bloc.state, const ServersDropdownState());

      await bloc.close();
      verify(() => ticker.loop(period: 2)).called(1);
    });

    group('_ServersMapSynced', () {
      blocTest<ServersDropdownBloc, ServersDropdownState>(
        'emits [projectPath] and called getServers',
        setUp: () {
          when(() => ticker.loop(period: 2)).thenAnswer((_) async* {
            yield 1;
          });
          when(
            () => serverManagementRepository.getServers(),
          ).thenAnswer(
            (_) =>
                Stream.fromIterable(['servers/projectA', 'servers/projectB']),
          );
        },
        build: () => ServersDropdownBloc(
          serverManagementRepository: serverManagementRepository,
          ticker: ticker,
        ),
        expect: () => const [
          ServersDropdownState(
            serverPathToName: {
              'servers/projectA': 'projectA',
              'servers/projectB': 'projectB',
            },
            projectPath: null,
          ),
        ],
      );
    });

    group('ServersValueChanged', () {
      blocTest<ServersDropdownBloc, ServersDropdownState>(
        'emits [null, projectPath, null]',
        setUp: () {
          when(() => ticker.loop(period: 2)).thenAnswer((_) async* {
            yield 1;
          });
          when(
            () => serverManagementRepository.getServers(),
          ).thenAnswer(
            (_) =>
                Stream.fromIterable(['servers/projectA', 'servers/projectB']),
          );
        },
        build: () => ServersDropdownBloc(
          serverManagementRepository: serverManagementRepository,
          ticker: ticker,
        ),
        act: (bloc) => bloc
          ..add(ServersValueChanged(projectPath: 'servers/projectA'))
          ..add(ServersValueChanged(projectPath: 'servers/projectC')),
        expect: () => const [
          ServersDropdownState(
            serverPathToName: {
              'servers/projectA': 'projectA',
              'servers/projectB': 'projectB',
            },
            projectPath: null,
          ),
          ServersDropdownState(
            serverPathToName: {
              'servers/projectA': 'projectA',
              'servers/projectB': 'projectB',
            },
            projectPath: 'servers/projectA',
          ),
          ServersDropdownState(
            serverPathToName: {
              'servers/projectA': 'projectA',
              'servers/projectB': 'projectB',
            },
            projectPath: null,
          ),
        ],
      );
    });
  });
}
