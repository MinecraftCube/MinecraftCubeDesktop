import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_repository/src/network_interface_wrapper.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:validators/validators.dart' as v;

// class LinuxMissingPackageException implements Exception {}

class GatewayUnexpectedException implements Exception {}

class NetworkRepository {
  NetworkRepository({
    ProcessManager? processManager,
    Dio? dio,
    NetworkInterfaceWrapper? networkInterface,
    Platform? platform,
  })  : _processManager = processManager ?? const LocalProcessManager(),
        _dio = dio ?? Dio(),
        _networkInterface = networkInterface ?? const NetworkInterfaceWrapper(),
        _platform = platform ?? const LocalPlatform();
  final ProcessManager _processManager;
  final Dio _dio;
  final NetworkInterfaceWrapper _networkInterface;
  final Platform _platform;

  Future<String> getPublicIp() async {
    final response = await _dio.get<String>('https://api.ipify.org');
    final body = response.data;
    if (body == null || body.isEmpty) return 'Service Unavailable';
    return body;
  }

  Future<List<NetworkInterface>> getInternalIps() async {
    if (!_networkInterface.supported) return [];
    return _networkInterface.list(
      includeLoopback: true,
      includeLinkLocal: true,
      type: InternetAddressType.IPv4,
    );
  }

  Future<Iterable<String>> getGatewayIps() async {
    const macos = 'netstat -rn | grep "default" | awk \'{print \$2}\'';
    const linux = 'ip route show default | awk \'/default/ {print \$3}\'';
    const windows = 'chcp 65001 && ipconfig';
    String command = '';

    if (_platform.isMacOS) {
      command = macos;
    } else if (_platform.isLinux) {
      command = linux;
    } else if (_platform.isWindows) {
      command = windows;
    } else {
      throw UnsupportedError('');
    }

    final result = await _processManager.run(
      [command],
      sanitize: false,
      runInShell: true,
      includeParentEnvironment: true,
    );
    final stdout = result.stdout;
    final stderr = result.stderr;
    if (result.exitCode != 0) {
      // if (stderr != null && stderr is String && stderr.isNotEmpty) {
      //   throw Exception(stderr);
      // }
      // use composite command, awk at the end return exitcode 0
      // if (_platform.isLinux) {
      //   throw LinuxMissingPackageException();
      // }
      throw GatewayUnexpectedException();
    }
    String? output;
    if (stderr is String && stderr.isNotEmpty) output = stderr;
    if (stdout is String && stdout.isNotEmpty) output = stdout;
    if (output == null) return [];
    if (_platform.isMacOS) {
      final lines = const LineSplitter().convert(output);
      return lines.where((element) => v.isIP(element, 4));
    } else if (_platform.isLinux) {
      return [output];
    } else {
      return _parseGatewayWindows(output);
    }
  }

  Iterable<String> _parseGatewayWindows(String raw) sync* {
    final multiGateway = RegExp(
      r'Default Gateway.*\:\ .*[\r*\n]*\ +(\d{1,3}\.\d{1,3}.\d{1,3}.\d{1,3})(\r\n)*',
      multiLine: true,
    );
    final singleGateway = RegExp(
      r'Default Gateway.*\:\ (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})',
    );

    final multiMatches = multiGateway.allMatches(raw);
    final singleMatch = singleGateway.allMatches(raw);

    for (RegExpMatch match in multiMatches) {
      if (match.groupCount > 0) {
        final matched = match.group(1);
        if (matched != null) yield matched;
      }
    }
    for (RegExpMatch match in singleMatch) {
      if (match.groupCount > 0) {
        final matched = match.group(1);
        if (matched != null) yield matched;
      }
    }
  }
}

// NOTES
// Internal use NetworkInterface, but should wrap for test
// Public use https://pub.dev/packages/dart_ipify
// Gateway (wait for https://pub.dev/packages/network_info_plus to support the ethernet feature)
// windows:
// chcp 65001 && ipconfig && findstr /b "Default Gateway"
// Windows IP Configuration
// Ethernet adapter Hamachi:
//
//    Connection-specific DNS Suffix  . :
//    IPv6 Address. . . . . . . . . . . : 2620:9b::192e:19f2
//    Link-local IPv6 Address . . . . . : fe80::8d90:cf49:f6b6:5caf%9
//    IPv4 Address. . . . . . . . . . . : 25.46.25.242
//    Subnet Mask . . . . . . . . . . . : 255.0.0.0
//    Default Gateway . . . . . . . . . : 2620:9b::1900:1
//
// Ethernet adapter 區域連線* 2:
//
//    Media State . . . . . . . . . . . : Media disconnected
//    Connection-specific DNS Suffix  . :
//
// Ethernet adapter 乙太網路 3:
//
//    Connection-specific DNS Suffix  . :
//    Link-local IPv6 Address . . . . . : fe80::48d0:ea57:aa73:4da1%3
//    IPv4 Address. . . . . . . . . . . : 192.168.42.1
//    Subnet Mask . . . . . . . . . . . : 255.255.255.0
//    Default Gateway . . . . . . . . . :
//
// Ethernet adapter 乙太網路 6:
//
//    Connection-specific DNS Suffix  . :
//    IPv6 Address. . . . . . . . . . . : 2001:b011:3807:146c:9da0:3556:dfc5:b8fa
//    Temporary IPv6 Address. . . . . . : 2001:b011:3807:146c:c9e4:c231:2990:969d
//    Link-local IPv6 Address . . . . . : fe80::9da0:3556:dfc5:b8fa%23
//    IPv4 Address. . . . . . . . . . . : 192.168.1.108
//    Subnet Mask . . . . . . . . . . . : 255.255.255.0
//    Default Gateway . . . . . . . . . : fe80::ee43:f6ff:feec:53ef%23
//                                        192.168.1.1
// linux: should install net-tools or error,
// ip r | grep default / ip route show default | awk '/default/ {print $3}'
// default via 192.168.206.2 dev ens33 proto dhcp metric 100
// macos: netstat -rn | grep "default" | awk '{print $2}' LIST OF IPS should filter ipv4
