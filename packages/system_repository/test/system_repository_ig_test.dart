@Tags(['integration'])

import 'package:flutter_test/flutter_test.dart';
import 'package:system_repository/src/system_repository.dart';

void main() {
  group('SystemRepository (integration not sure)', () {
    late SystemRepository repository;

    setUp(
      () {
        repository = const SystemRepository();
      },
    );

    group('constructor', () {
      test('instantiates internal process when not injected', () {
        expect(const SystemRepository(), isNotNull);
      });
    });

    group('getCpuInfo', () {
      test('return correct CpuInfo', () async {
        final cpu = await repository.getCpuInfo();
        expect(
          cpu.name,
          isNotEmpty,
        );
        expect(
          cpu.load,
          greaterThan(0),
        );
      });
    });
    group('getMemoryInfo', () {
      test('return correct MemoryInfo', () async {
        final memoryInfo = await repository.getMemoryInfo();
        expect(
          memoryInfo.freeSize,
          greaterThan(0),
        );
        expect(memoryInfo.totalSize, greaterThan(0));
      });
    });
    group('getGpuInfo', () {
      test('return correct GpuName (nogui?)', () async {
        expect(
          await repository.getGpuInfo(),
          isNotEmpty,
        );
      });
    });
  });
}
