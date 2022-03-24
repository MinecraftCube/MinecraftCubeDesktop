import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:cube_properties_repository/cube_properties_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/cube_properties_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/consts/app_cube_properties.dart';
import 'package:mocktail/mocktail.dart';

class MockCubePropertiesRepository extends Mock
    implements CubePropertiesRepository {}

class MockJavaInfoRepository extends Mock implements JavaInfoRepository {}

void main() {
  late CubePropertiesRepository repository;
  late JavaInfoRepository javaInfoRepository;
  const projectPath = 'servers/project';
  group('CubePropertiesBloc', () {
    setUp(() {
      repository = MockCubePropertiesRepository();
      javaInfoRepository = MockJavaInfoRepository();
      // when(() => repository.getProperties(directory: 'directory'));
      // when(() => javaInfoRepository.getPortableJavas()).thenAnswer((_) => Stream.fromIterable([]));
      when(() => javaInfoRepository.getPortableJavas())
          .thenAnswer((_) => Stream.fromIterable([]));
    });

    test('initial state is correct', () {
      final bloc = CubePropertiesBloc(
        cubePropertiesRepository: repository,
        javaInfoRepository: javaInfoRepository,
        projectPath: projectPath,
      );
      expect(bloc.state, const CubePropertiesState());
    });
    group('CubePropertiesLoaded', () {
      blocTest<CubePropertiesBloc, CubePropertiesState>(
        'emits empty properties when no file',
        build: () => CubePropertiesBloc(
          projectPath: projectPath,
          javaInfoRepository: javaInfoRepository,
          cubePropertiesRepository: repository,
        ),
        act: (bloc) => bloc.add(
          CubePropertiesLoaded(),
        ),
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer((_) => Stream.fromIterable([]));
        },
        expect: () => <CubePropertiesState>[
          CubePropertiesState(
            properties: getAppCubeProperties().toList(),
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
      blocTest<CubePropertiesBloc, CubePropertiesState>(
        'emits correct properties',
        build: () => CubePropertiesBloc(
          projectPath: projectPath,
          javaInfoRepository: javaInfoRepository,
          cubePropertiesRepository: repository,
        ),
        act: (bloc) => bloc.add(
          CubePropertiesLoaded(),
        ),
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'Java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'Xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
        },
        expect: () => <CubePropertiesState>[
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '4g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
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

      blocTest<CubePropertiesBloc, CubePropertiesState>(
        'emits correct properties with portable javas',
        build: () => CubePropertiesBloc(
          projectPath: projectPath,
          javaInfoRepository: javaInfoRepository,
          cubePropertiesRepository: repository,
        ),
        act: (bloc) => bloc.add(
          CubePropertiesLoaded(),
        ),
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'Java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'Xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
          when(
            () => javaInfoRepository.getPortableJavas(),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              const JavaInfo(
                executablePaths: ['speical_path/java_a'],
                name: 'special_path',
              ),
              const JavaInfo(
                executablePaths: ['speical_patha/java_B'],
                name: 'special_patha',
              ),
              const JavaInfo(
                executablePaths: ['speical_pathb/java_C'],
                name: 'special_pathb',
              ),
            ]),
          );
        },
        expect: () => <CubePropertiesState>[
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {
                  'special_path': 'speical_path/java_a',
                  'special_patha': 'speical_patha/java_B',
                  'special_pathb': 'speical_pathb/java_C',
                  'Java(System)': 'java',
                },
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '4g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
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

    group('CubePropertiesChanged', () {
      blocTest<CubePropertiesBloc, CubePropertiesState>(
        'emits changed properties',
        build: () => CubePropertiesBloc(
          projectPath: projectPath,
          javaInfoRepository: javaInfoRepository,
          cubePropertiesRepository: repository,
        ),
        act: (bloc) async {
          bloc.add(
            CubePropertiesLoaded(),
          );
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesChanged(fieldName: 'Xmx', value: '16g'));
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesChanged(fieldName: 'hardcore', value: '123'));
        },
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'Java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'Xmx', value: '4g'),
              Property(name: 'hardcore', value: 'false'),
            ]),
          );
        },
        expect: () => <CubePropertiesState>[
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '4g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: '123',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          )
        ],
      );
    });

    group('CubePropertiesSaved', () {
      blocTest<CubePropertiesBloc, CubePropertiesState>(
        'emits saved failure',
        build: () => CubePropertiesBloc(
          projectPath: projectPath,
          javaInfoRepository: javaInfoRepository,
          cubePropertiesRepository: repository,
        ),
        act: (bloc) async {
          bloc.add(
            CubePropertiesLoaded(),
          );
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesChanged(fieldName: 'Xmx', value: '16g'));
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesChanged(fieldName: 'hardcore', value: 'true'));
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesSaved());
        },
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'Java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'Xmx', value: '4g'),
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
        expect: () => <CubePropertiesState>[
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '4g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'true',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            status: NetworkStatus.inProgress,
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'true',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            status: NetworkStatus.failure,
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'true',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          )
        ],
      );

      blocTest<CubePropertiesBloc, CubePropertiesState>(
        'emits saved success',
        build: () => CubePropertiesBloc(
          projectPath: projectPath,
          javaInfoRepository: javaInfoRepository,
          cubePropertiesRepository: repository,
        ),
        act: (bloc) async {
          bloc.add(
            CubePropertiesLoaded(),
          );
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesChanged(fieldName: 'Xmx', value: '16g'));
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesChanged(fieldName: 'hardcore', value: 'true'));
          await Future.delayed(Duration.zero);
          bloc.add(CubePropertiesSaved());
        },
        setUp: () {
          when(
            () => repository.getProperties(
              directory: projectPath,
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable(const [
              Property(name: 'Java', value: 'c8763'),
              Property(name: '123', value: '456'),
              Property(name: 'Xmx', value: '4g'),
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
        expect: () => <CubePropertiesState>[
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '4g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'false',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'true',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            status: NetworkStatus.inProgress,
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'true',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          ),
          const CubePropertiesState(
            status: NetworkStatus.success,
            properties: [
              StringServerProperty(
                name: 'Java',
                fieldName: 'Java',
                value: 'c8763',
                selectables: {'Java(System)': 'java'},
                description: '''
Allows users to specify custom java.

You could select the portable javas by adding custom java under project/java folder,
Keep system java by using only 'java'
''',
              ),
              StringServerProperty(
                name: '123',
                fieldName: '123',
                value: '456',
                description: '',
              ),
              StringServerProperty(
                name: 'Xmx',
                fieldName: 'Xmx',
                value: '16g',
                description: '''
set maximum Java heap size
''',
              ),
              StringServerProperty(
                name: 'hardcore',
                fieldName: 'hardcore',
                value: 'true',
                description: '',
              ),
              StringServerProperty(
                name: 'Xms',
                fieldName: 'Xms',
                value: '256m',
                description: '''
set initial Java heap size
''',
              ),
            ],
          )
        ],
      );
    });
  });
}
