@Tags(['integration'])
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:network_repository/network_repository.dart';
import 'package:platform/platform.dart';

void main() {
  final ipv4Reg = RegExp(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}');
  group('NetworkRepository', () {
    late Platform platform;
    late NetworkRepository repository;

    setUp(
      () {
        platform = const LocalPlatform();
        repository = NetworkRepository(
          platform: platform,
        );
      },
    );

    group('constructor', () {
      test('instantiates internal dependencies when not injected', () {
        expect(NetworkRepository(), isNotNull);
      });
    });

    group('getPublicIp', () {
      test('return ip fit ipv4', () async {
        expect(
          await repository.getPublicIp(),
          matches(ipv4Reg),
        );
      });
    });

    group('getInternalIps', () {
      test('return [NetworkInterfaces]', () async {
        final networks = await repository.getInternalIps();
        expect(
          networks,
          everyElement(isA<io.NetworkInterface>()),
        );
        expect(networks, hasLength(greaterThan(0)));
        for (final network in networks) {
          for (final address in network.addresses) {
            expect(address.address, matches(ipv4Reg));
          }
        }
      });
    });

    group('getGatewayIps', () {
      test('return correct gateway ips', () async {
        expect(
          await repository.getGatewayIps(),
          everyElement(matches(ipv4Reg)),
        );
      });
    });
  });
}
