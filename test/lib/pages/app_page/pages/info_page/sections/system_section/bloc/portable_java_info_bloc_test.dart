import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/portable_java_info_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockJavaInfoRepository extends Mock implements JavaInfoRepository {}

void main() {
  late JavaInfoRepository javaInfoRepository;

  setUp(() {
    javaInfoRepository = MockJavaInfoRepository();
  });
  group('PortableJavaInfoBloc', () {
    test('initial state is correct', () {
      expect(
        PortableJavaInfoBloc(javaInfoRepository: javaInfoRepository).state,
        const PortableJavaInfoState(),
      );
    });

    blocTest<PortableJavaInfoBloc, PortableJavaInfoState>(
      'emits [inProgress, failure] when api exception',
      build: () => PortableJavaInfoBloc(
        javaInfoRepository: javaInfoRepository,
      ),
      act: (bloc) => bloc.add(
        const PortableJavaInfoStarted(),
      ),
      setUp: () {
        when(() => javaInfoRepository.getPortableJavas())
            .thenThrow(Exception());
      },
      expect: () => <PortableJavaInfoState>[
        const PortableJavaInfoState(status: NetworkStatus.inProgress),
        const PortableJavaInfoState(
          status: NetworkStatus.failure,
        ),
      ],
    );
    blocTest<PortableJavaInfoBloc, PortableJavaInfoState>(
      'emits [inProgress, success] with empty datas',
      build: () => PortableJavaInfoBloc(
        javaInfoRepository: javaInfoRepository,
      ),
      act: (bloc) => bloc.add(
        const PortableJavaInfoStarted(),
      ),
      setUp: () {
        when(() => javaInfoRepository.getPortableJavas())
            .thenAnswer((_) => Stream.fromIterable([]));
      },
      expect: () => <PortableJavaInfoState>[
        const PortableJavaInfoState(status: NetworkStatus.inProgress),
        const PortableJavaInfoState(
          status: NetworkStatus.success,
          infos: [],
        ),
      ],
    );
    blocTest<PortableJavaInfoBloc, PortableJavaInfoState>(
      'emits [inProgress, success]',
      build: () => PortableJavaInfoBloc(
        javaInfoRepository: javaInfoRepository,
      ),
      act: (bloc) => bloc.add(
        const PortableJavaInfoStarted(),
      ),
      setUp: () {
        when(() => javaInfoRepository.getPortableJavas()).thenAnswer(
          (_) => Stream.fromIterable([
            const JavaInfo(
              executablePaths: ['java8/8/bin/java'],
              name: 'java8',
            ),
            const JavaInfo(
              executablePaths: ['java16/16/bin/java'],
              name: 'java16',
            ),
          ]),
        );
      },
      expect: () => <PortableJavaInfoState>[
        const PortableJavaInfoState(status: NetworkStatus.inProgress),
        const PortableJavaInfoState(
          status: NetworkStatus.success,
          infos: [
            JavaInfo(
              executablePaths: ['java8/8/bin/java'],
              name: 'java8',
            ),
            JavaInfo(
              executablePaths: ['java16/16/bin/java'],
              name: 'java16',
            ),
          ],
        ),
      ],
    );
  });
}
