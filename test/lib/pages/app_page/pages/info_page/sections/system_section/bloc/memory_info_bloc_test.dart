import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/memory_info_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:system_repository/system_repository.dart';

class MockSystemRepository extends Mock implements SystemRepository {}

class MockTicker extends Mock implements Ticker {}

void main() {
  late SystemRepository systemRepository;
  late Ticker ticker;

  setUp(() {
    systemRepository = MockSystemRepository();
    ticker = MockTicker();
  });

  group('MemoryInfoBloc', () {
    test('initial state is correct', () {
      expect(
        MemoryInfoBloc(systemRepository: systemRepository, ticker: ticker)
            .state,
        const MemoryInfoState(),
      );
    });

    blocTest<MemoryInfoBloc, MemoryInfoState>(
      'emits [failure] when api exception',
      build: () =>
          MemoryInfoBloc(systemRepository: systemRepository, ticker: ticker),
      act: (bloc) => bloc.add(
        const MemoryInfoStarted(),
      ),
      setUp: () {
        when(() => ticker.loop(period: 2)).thenAnswer(
          (_) => Stream<int>.fromIterable([5, 4, 3, 2, 1]),
        );
        when(() => systemRepository.getMemoryInfo()).thenThrow(Exception());
      },
      expect: () => <MemoryInfoState>[
        const MemoryInfoState(
          status: NetworkStatus.failure,
        ),
      ],
    );

    blocTest<MemoryInfoBloc, MemoryInfoState>(
      'emits [success] 3 times',
      build: () =>
          MemoryInfoBloc(systemRepository: systemRepository, ticker: ticker),
      act: (bloc) => bloc.add(
        const MemoryInfoStarted(),
      ),
      setUp: () {
        when(() => ticker.loop(period: 2)).thenAnswer(
          (_) => Stream<int>.fromIterable([3, 2, 1]),
        );
        final infos = [
          const MemoryInfo(totalSize: 4096, freeSize: 1024),
          const MemoryInfo(totalSize: 4096, freeSize: 1500),
          const MemoryInfo(totalSize: 4096, freeSize: 2048),
        ];
        when(() => systemRepository.getMemoryInfo())
            .thenAnswer((_) async => infos.removeAt(0));
      },
      expect: () => <MemoryInfoState>[
        const MemoryInfoState(
          status: NetworkStatus.success,
          info: MemoryInfo(totalSize: 4096, freeSize: 1024),
        ),
        const MemoryInfoState(
          status: NetworkStatus.success,
          info: MemoryInfo(totalSize: 4096, freeSize: 1500),
        ),
        const MemoryInfoState(
          status: NetworkStatus.success,
          info: MemoryInfo(totalSize: 4096, freeSize: 2048),
        ),
      ],
      verify: (_) => verify(() => ticker.loop(period: 2)).called(1),
    );
  });
}
