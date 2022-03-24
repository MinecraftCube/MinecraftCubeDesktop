import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/server_properties_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:server_properties_repository/server_properties_repository.dart';

class MockServerPropertiesRepository extends Mock
    implements ServerPropertiesRepository {}

void main() {
  late ServerPropertiesRepository repository;
  const projectPath = 'servers/project';
  group('ServerPropertiesBloc', () {
    setUp(() {
      repository = MockServerPropertiesRepository();
      // when(() => repository.getProperties(directory: 'directory'));
    });

    test('initial state is correct', () {
      final bloc = ServerPropertiesBloc(
        serverPropertiesRepository: repository,
        projectPath: projectPath,
      );
      expect(bloc.state, const ServerPropertiesState());
    });
    group('ServerPropertiesLoaded', () {
      blocTest<ServerPropertiesBloc, ServerPropertiesState>(
        'emits empty properties when no file',
        build: () => ServerPropertiesBloc(
          projectPath: projectPath,
          serverPropertiesRepository: repository,
        ),
        act: (bloc) => bloc.add(
          ServerPropertiesLoaded(),
        ),
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer((_) => Stream.fromIterable([]));
        },
        expect: () => <ServerPropertiesState>[
          const ServerPropertiesState(
            properties: [],
          )
        ],
        verify: (_) {
          verify(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).called(1);
        },
      );
      blocTest<ServerPropertiesBloc, ServerPropertiesState>(
        'emits correct properties',
        build: () => ServerPropertiesBloc(
          projectPath: projectPath,
          serverPropertiesRepository: repository,
        ),
        act: (bloc) => bloc.add(
          ServerPropertiesLoaded(),
        ),
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
        },
        expect: () => <ServerPropertiesState>[
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '4g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          )
        ],
        verify: (_) {
          verify(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).called(1);
        },
      );
    });

    group('ServerPropertiesChanged', () {
      blocTest<ServerPropertiesBloc, ServerPropertiesState>(
        'emits changed properties',
        build: () => ServerPropertiesBloc(
          projectPath: projectPath,
          serverPropertiesRepository: repository,
        ),
        act: (bloc) async {
          bloc.add(
            ServerPropertiesLoaded(),
          );
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesChanged(fieldName: 'xmx', value: '16g'));
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesChanged(fieldName: 'hardcore', value: true));
        },
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
        },
        expect: () => <ServerPropertiesState>[
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '4g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          )
        ],
      );
    });

    group('ServerPropertiesSaved', () {
      blocTest<ServerPropertiesBloc, ServerPropertiesState>(
        'emits saved failure',
        build: () => ServerPropertiesBloc(
          projectPath: projectPath,
          serverPropertiesRepository: repository,
        ),
        act: (bloc) async {
          bloc.add(
            ServerPropertiesLoaded(),
          );
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesChanged(fieldName: 'xmx', value: '16g'));
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesChanged(fieldName: 'hardcore', value: true));
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesSaved());
        },
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
          when(
            () => repository.saveProperties(
              directory: any(named: 'directory'),
              properties: any(named: 'properties'),
            ),
          ).thenThrow(Exception());
        },
        expect: () => <ServerPropertiesState>[
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '4g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            status: NetworkStatus.inProgress,
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            status: NetworkStatus.failure,
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
        ],
      );

      blocTest<ServerPropertiesBloc, ServerPropertiesState>(
        'emits saved success',
        build: () => ServerPropertiesBloc(
          projectPath: projectPath,
          serverPropertiesRepository: repository,
        ),
        act: (bloc) async {
          bloc.add(
            ServerPropertiesLoaded(),
          );
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesChanged(fieldName: 'xmx', value: '16g'));
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesChanged(fieldName: 'hardcore', value: true));
          await Future.delayed(Duration.zero);
          bloc.add(ServerPropertiesSaved());
        },
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
          when(
            () => repository.saveProperties(
              directory: any(named: 'directory'),
              properties: any(named: 'properties'),
            ),
          ).thenAnswer((_) async => {});
        },
        expect: () => <ServerPropertiesState>[
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '4g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: false,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            status: NetworkStatus.inProgress,
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
          const ServerPropertiesState(
            status: NetworkStatus.success,
            properties: [
              StringServerProperty(
                name: 'java',
                fieldName: 'java',
                value: 'c8763',
                description: '',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'xmx',
                fieldName: 'xmx',
                value: '16g',
                description: '',
              ),
              BoolServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: true,
                description: '''
If set to true, server difficulty is ignored and set to hard and players will be set to spectator mode if they die.
''',
              ),
            ],
          ),
        ],
      );
    });
  });
}
