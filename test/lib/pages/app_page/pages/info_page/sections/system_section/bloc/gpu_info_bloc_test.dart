import 'package:bloc_test/bloc_test.dart';
import 'package:cube_api/cube_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/gpu_info_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:system_repository/system_repository.dart';

class MockSystemRepository extends Mock implements SystemRepository {}

void main() {
  late SystemRepository systemRepository;

  setUp(() {
    systemRepository = MockSystemRepository();
  });
  group('GpuInfoBloc', () {
    test('initial state is correct', () {
      expect(
        GpuInfoBloc(systemRepository: systemRepository).state,
        const GpuInfoState(),
      );
    });

    blocTest<GpuInfoBloc, GpuInfoState>(
      'emits [inProgress, failure] when api exception',
      build: () => GpuInfoBloc(
        systemRepository: systemRepository,
      ),
      act: (bloc) => bloc.add(
        const GpuInfoStarted(),
      ),
      setUp: () {
        when(() => systemRepository.getGpuInfo()).thenThrow(Exception());
      },
      expect: () => <GpuInfoState>[
        const GpuInfoState(status: NetworkStatus.inProgress),
        const GpuInfoState(
          status: NetworkStatus.failure,
        ),
      ],
    );
    blocTest<GpuInfoBloc, GpuInfoState>(
      'emits [inProgress, success]',
      build: () => GpuInfoBloc(
        systemRepository: systemRepository,
      ),
      act: (bloc) => bloc.add(
        const GpuInfoStarted(),
      ),
      setUp: () {
        when(() => systemRepository.getGpuInfo())
            .thenAnswer((_) async => 'Nvidia');
      },
      expect: () => <GpuInfoState>[
        const GpuInfoState(status: NetworkStatus.inProgress),
        const GpuInfoState(
          status: NetworkStatus.success,
          info: 'Nvidia',
        ),
      ],
    );
  });
}
