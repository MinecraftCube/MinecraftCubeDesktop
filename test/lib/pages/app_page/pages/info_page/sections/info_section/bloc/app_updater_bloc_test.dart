import 'package:app_updater_repository/app_updater_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/info_section/bloc/app_updater_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAppUpdaterRepository extends Mock implements AppUpdaterRepository {}

void main() {
  late AppUpdaterRepository appUpdaterRepository;

  setUp(() {
    appUpdaterRepository = MockAppUpdaterRepository();
  });
  group('MockAppUpdaterRepository', () {
    test('initial state is correct', () {
      expect(
        AppUpdaterBloc(appUpdaterRepository: appUpdaterRepository).state,
        const AppUpdaterState(),
      );
    });

    group('AppUpdaterStarted', () {
      blocTest<AppUpdaterBloc, AppUpdaterState>(
        'emits [inProgress, failure] when api exception',
        build: () => AppUpdaterBloc(
          appUpdaterRepository: appUpdaterRepository,
        ),
        act: (bloc) => bloc.add(
          AppUpdaterStarted(),
        ),
        setUp: () {
          when(
            () => appUpdaterRepository.hasGreaterVersion(
              version: any(named: 'version'),
            ),
          ).thenThrow(Exception());
        },
        expect: () => <AppUpdaterState>[
          const AppUpdaterState(status: NetworkStatus.inProgress),
          const AppUpdaterState(
            status: NetworkStatus.failure,
          ),
        ],
      );
      blocTest<AppUpdaterBloc, AppUpdaterState>(
        'emits [inProgress, success with false]',
        build: () => AppUpdaterBloc(
          appUpdaterRepository: appUpdaterRepository,
        ),
        act: (bloc) => bloc.add(
          AppUpdaterStarted(),
        ),
        setUp: () {
          when(
            () => appUpdaterRepository.hasGreaterVersion(
              version: any(named: 'version'),
            ),
          ).thenAnswer((_) async => false);
        },
        expect: () => <AppUpdaterState>[
          const AppUpdaterState(status: NetworkStatus.inProgress),
          const AppUpdaterState(
            status: NetworkStatus.success,
            hasGreaterVersion: false,
          ),
        ],
      );

      blocTest<AppUpdaterBloc, AppUpdaterState>(
        'emits [inProgress, success with true]',
        build: () => AppUpdaterBloc(
          appUpdaterRepository: appUpdaterRepository,
        ),
        act: (bloc) => bloc.add(
          AppUpdaterStarted(),
        ),
        setUp: () {
          when(
            () => appUpdaterRepository.hasGreaterVersion(
              version: any(named: 'version'),
            ),
          ).thenAnswer((_) async => true);
        },
        expect: () => <AppUpdaterState>[
          const AppUpdaterState(status: NetworkStatus.inProgress),
          const AppUpdaterState(
            status: NetworkStatus.success,
            hasGreaterVersion: true,
          ),
        ],
      );
    });

    group('AppUpdaterMarkdownFetched', () {
      blocTest<AppUpdaterBloc, AppUpdaterState>(
        'emits [inProgress, failure] when api exception',
        build: () => AppUpdaterBloc(
          appUpdaterRepository: appUpdaterRepository,
        ),
        act: (bloc) => bloc.add(
          AppUpdaterMarkdownFetched(fullLocale: 'test'),
        ),
        setUp: () {
          when(
            () => appUpdaterRepository.getLatestRelease(
              fullLocale: any(named: 'fullLocale'),
            ),
          ).thenThrow(Exception());
        },
        expect: () => <AppUpdaterState>[
          const AppUpdaterState(status: NetworkStatus.inProgress),
          const AppUpdaterState(
            status: NetworkStatus.failure,
          ),
        ],
      );
      blocTest<AppUpdaterBloc, AppUpdaterState>(
        'emits [inProgress, success with empty]',
        build: () => AppUpdaterBloc(
          appUpdaterRepository: appUpdaterRepository,
        ),
        act: (bloc) => bloc.add(
          AppUpdaterMarkdownFetched(fullLocale: 'test'),
        ),
        setUp: () {
          when(
            () => appUpdaterRepository.getLatestRelease(
              fullLocale: any(named: 'fullLocale'),
            ),
          ).thenAnswer((_) async => null);
        },
        expect: () => <AppUpdaterState>[
          const AppUpdaterState(status: NetworkStatus.inProgress),
          const AppUpdaterState(
            status: NetworkStatus.success,
          ),
        ],
      );

      blocTest<AppUpdaterBloc, AppUpdaterState>(
        'emits [inProgress, success with data]',
        build: () => AppUpdaterBloc(
          appUpdaterRepository: appUpdaterRepository,
        ),
        act: (bloc) => bloc.add(
          AppUpdaterMarkdownFetched(fullLocale: 'test'),
        ),
        setUp: () {
          when(
            () => appUpdaterRepository.getLatestRelease(
              fullLocale: any(named: 'fullLocale'),
            ),
          ).thenAnswer((_) async => '123');
        },
        expect: () => <AppUpdaterState>[
          const AppUpdaterState(status: NetworkStatus.inProgress),
          const AppUpdaterState(
            status: NetworkStatus.success,
            markdown: '123',
          ),
        ],
      );
    });
  });
}
