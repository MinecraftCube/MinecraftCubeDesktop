@Tags(['integration'])

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VanillaServerRepository (Ignore for third party api)', () {
    test('dummy test for melos#261 and flutter#100467', () {});

    // late SystemRepository repository;

    // setUp(
    //   () {
    //     repository = const SystemRepository();
    //   },
    // );

    // group('constructor', () {
    //   test('instantiates internal process when not injected', () {
    //     expect(const SystemRepository(), isNotNull);
    //   });
    // });

    // group('getCpuInfo', () {
    //   test('return correct CpuInfo', () async {
    //     final cpu = await repository.getCpuInfo();
    //     expect(
    //       cpu.name,
    //       isNotEmpty,
    //     );
    //     expect(
    //       cpu.load,
    //       greaterThan(0),
    //     );
    //   });
    // });
    // group('getMemoryInfo', () {
    //   test('return correct MemoryInfo', () async {
    //     final memoryInfo = await repository.getMemoryInfo();
    //     expect(
    //       memoryInfo.freeSize,
    //       greaterThan(0),
    //     );
    //     expect(memoryInfo.totalSize, greaterThan(0));
    //   });
    // });
    // group('getGpuInfo', () {
    //   test('return correct GpuName (nogui?)', () async {
    //     expect(
    //       await repository.getGpuInfo(),
    //       isNotEmpty,
    //     );
    //   });
    // });
  });
}
