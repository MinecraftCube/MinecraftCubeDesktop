import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/system_java_info_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockJavaInfoRepository extends Mock implements JavaInfoRepository {}

void main() {
  late JavaInfoRepository javaInfoRepository;

  setUp(() {
    javaInfoRepository = MockJavaInfoRepository();
  });
  group('SystemJavaInfoBloc', () {
    test('initial state is correct', () {
      expect(
        SystemJavaInfoBloc(javaInfoRepository: javaInfoRepository).state,
        const SystemJavaInfoState(),
      );
    });

    blocTest<SystemJavaInfoBloc, SystemJavaInfoState>(
      'emits [inProgress, failure] when api exception',
      build: () => SystemJavaInfoBloc(
        javaInfoRepository: javaInfoRepository,
      ),
      act: (bloc) => bloc.add(
        const SystemJavaInfoStarted(),
      ),
      setUp: () {
        when(() => javaInfoRepository.getSystemJava()).thenThrow(Exception());
      },
      expect: () => <SystemJavaInfoState>[
        const SystemJavaInfoState(status: NetworkStatus.inProgress),
        const SystemJavaInfoState(
          status: NetworkStatus.failure,
        ),
      ],
    );
    blocTest<SystemJavaInfoBloc, SystemJavaInfoState>(
      'emits [inProgress, success]',
      build: () => SystemJavaInfoBloc(
        javaInfoRepository: javaInfoRepository,
      ),
      act: (bloc) => bloc.add(
        const SystemJavaInfoStarted(),
      ),
      setUp: () {
        when(() => javaInfoRepository.getSystemJava()).thenAnswer(
          (_) async => const JavaInfo(
            executablePaths: ['programdata/java'],
            name: 'java',
            output: fakeJavaOutput,
          ),
        );
      },
      expect: () => <SystemJavaInfoState>[
        const SystemJavaInfoState(status: NetworkStatus.inProgress),
        const SystemJavaInfoState(
          status: NetworkStatus.success,
          info: JavaInfo(
            executablePaths: ['programdata/java'],
            name: 'java',
            output: fakeJavaOutput,
          ),
        ),
      ],
    );
  });
}

const fakeJavaOutput = '''java version "17.0.1" 2021-10-19 LTS
Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.1+12-LTS-39, mixed mode, sharing)''';
