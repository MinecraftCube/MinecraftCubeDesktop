import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/cpu_info_bloc.dart';
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

  group('CpuInfoBloc', () {
    test('initial state is correct', () {
      expect(
        CpuInfoBloc(systemRepository: systemRepository, ticker: ticker).state,
        const CpuInfoState(),
      );
    });

    blocTest<CpuInfoBloc, CpuInfoState>(
      'emits [failure] when api exception',
      build: () =>
          CpuInfoBloc(systemRepository: systemRepository, ticker: ticker),
      act: (bloc) => bloc.add(
        const CpuInfoStarted(),
      ),
      setUp: () {
        when(() => ticker.loop(period: 2)).thenAnswer(
          (_) => Stream<int>.fromIterable([5, 4, 3, 2, 1]),
        );
        when(() => systemRepository.getCpuInfo()).thenThrow(Exception());
      },
      expect: () => <CpuInfoState>[
        const CpuInfoState(
          status: NetworkStatus.failure,
        ),
      ],
    );

    blocTest<CpuInfoBloc, CpuInfoState>(
      'emits [success] 3 times',
      build: () =>
          CpuInfoBloc(systemRepository: systemRepository, ticker: ticker),
      act: (bloc) => bloc.add(
        const CpuInfoStarted(),
      ),
      setUp: () {
        when(() => ticker.loop(period: 2)).thenAnswer(
          (_) => Stream<int>.fromIterable([3, 2, 1]),
        );
        final infos = [
          const CpuInfo(load: 1, name: 'Intel'),
          const CpuInfo(load: 2, name: 'Intel'),
          const CpuInfo(load: 3, name: 'Intel')
        ];
        when(() => systemRepository.getCpuInfo())
            .thenAnswer((_) async => infos.removeAt(0));
      },
      expect: () => <CpuInfoState>[
        const CpuInfoState(
          status: NetworkStatus.success,
          info: CpuInfo(load: 1, name: 'Intel'),
        ),
        const CpuInfoState(
          status: NetworkStatus.success,
          info: CpuInfo(load: 2, name: 'Intel'),
        ),
        const CpuInfoState(
          status: NetworkStatus.success,
          info: CpuInfo(load: 3, name: 'Intel'),
        ),
      ],
      verify: (_) => verify(() => ticker.loop(period: 2)).called(1),
    );
  });
}
