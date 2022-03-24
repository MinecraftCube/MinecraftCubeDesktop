import 'dart:convert';

import 'package:cube_api/cube_api.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:system_repository/src/cpu_info.dart';
import 'package:system_repository/src/memory_info.dart';

// class LinuxMissingPackageException implements Exception {}

class SystemRepository {
  const SystemRepository({
    ProcessManager? processManager,
    Platform? platform,
  })  : _processManager = processManager ?? const LocalProcessManager(),
        _platform = platform ?? const LocalPlatform();
  final ProcessManager _processManager;
  final Platform _platform;

  Future<CpuInfo> getCpuInfo() async {
    // linux:
    // cpu name: lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p'
    // return Intel(R) core .... GHZ
    // cpu usage:
    // awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)
    // return 1.54456
    // windows:
    // cpu name: wmic cpu get NAME (should parse)
    // Name
    // Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz
    // cpu usage: wmic cpu get loadpercentage (should parse)
    // LoadPercentage
    // 13
    // macos:
    // cpu name: sysctl -a | grep machdep.cpu.brand_string | awk '{for(i = 2;i < NF; i++) printf $i " "; print $NF}'
    // return Intel(R) core .... GHZ
    // cpu usage: top -l 2 -n 0 -F | egrep -o ' \d*\.\d+% idle' | tail -1 | awk -F% -v prefix="$prefix" '{ printf "%s%.1f\n", prefix, 100 - $1 }'
    // return 11.6

    String getNameCmd = '';
    String getLoadCmd = '';

    if (_platform.isLinux) {
      const linuxCpuName =
          "lscpu | sed -nr '/Model name/ s/.*:\\s*(.*) @ .*/\\1/p'";
      const linuxCpuLoad =
          "awk '{u=\$2+\$4; t=\$2+\$4+\$5; if (NR==1){u1=u; t1=t;} else print (\$2+\$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)";
      getNameCmd = linuxCpuName;
      getLoadCmd = linuxCpuLoad;
    } else if (_platform.isMacOS) {
      const macosCpuName =
          "sysctl -a | grep machdep.cpu.brand_string | awk '{for(i = 2;i < NF; i++) printf \$i \" \"; print \$NF}'";
      const macosCpuLoad =
          "top -l 2 -n 0 -F | egrep -o ' \\d*\\.\\d+% idle' | tail -1 | awk -F% -v prefix=\"\$prefix\" '{ printf \"%s%.1f\\n\", prefix, 100 - \$1 }'";
      getNameCmd = macosCpuName;
      getLoadCmd = macosCpuLoad;
    } else if (_platform.isWindows) {
      const windowsCpuName = 'wmic cpu get NAME';
      const windowsCpuLoad = 'wmic cpu get loadpercentage';
      getNameCmd = windowsCpuName;
      getLoadCmd = windowsCpuLoad;
    } else {
      throw UnsupportedError('out of OS');
    }

    final nameResult = await _processManager.run(
      [getNameCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );
    final loadResult = await _processManager.run(
      [getLoadCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );

    String? name = transformProcessResult(nameResult);
    String? load = transformProcessResult(loadResult);

    if (_platform.isWindows) {
      List<String> names = const LineSplitter().convert(name ?? '');
      List<String> loads = const LineSplitter().convert(load ?? '');
      names = names.where((e) => e.isNotEmpty).toList();
      loads = loads.where((e) => e.isNotEmpty).toList();
      return const CpuInfo().copyWith(
        name: names.isEmpty ? null : names.last,
        load: loads.isEmpty ? null : double.tryParse(loads.last),
      );
    }

    return const CpuInfo()
        .copyWith(name: name, load: double.tryParse(load ?? ''));
  }

  Future<MemoryInfo> getMemoryInfo() async {
    // linux:
    // total memory: awk '/MemTotal/ {print $2}' /proc/meminfo
    // 16681340
    // free memory: awk '/MemFree/ {print $2}' /proc/meminfo
    // 2819112
    // windows:
    // total memory: wmic OS get TotalVisibleMemorySize (should parse) MB
    // TotalVisibleMemorySize
    // 16681340
    // free memory: wmic OS get FreePhysicalMemory (should parse) MB
    // FreePhysicalMemory
    // 2819112
    // macos:
    // total memory: top -l 1 -s 0 | grep PhysMem | awk '{print $2}'
    // 5712M
    // free memory: top -l 1 -s 0 | grep PhysMem | awk '{print $6}'
    // 2473M

    String totalMemCmd = '';
    String freeMemCmd = '';

    if (_platform.isLinux) {
      const linuxTotalMem = "awk '/MemTotal/ {print \$2}' /proc/meminfo";
      const linuxFreeMem = "awk '/MemFree/ {print \$2}' /proc/meminfo";
      totalMemCmd = linuxTotalMem;
      freeMemCmd = linuxFreeMem;
    } else if (_platform.isMacOS) {
      const macosTotalMem = "top -l 1 -s 0 | grep PhysMem | awk '{print \$2}'";
      const macosFreeMem = "top -l 1 -s 0 | grep PhysMem | awk '{print \$6}'";
      totalMemCmd = macosTotalMem;
      freeMemCmd = macosFreeMem;
    } else if (_platform.isWindows) {
      const windowsTotalMem = 'wmic OS get TotalVisibleMemorySize';
      const windowsFreeMem = 'wmic OS get FreePhysicalMemory';
      totalMemCmd = windowsTotalMem;
      freeMemCmd = windowsFreeMem;
    } else {
      throw UnsupportedError('out of OS');
    }

    final totalResult = await _processManager.run(
      [totalMemCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );
    final freeResult = await _processManager.run(
      [freeMemCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );

    String? total = transformProcessResult(totalResult);
    String? free = transformProcessResult(freeResult);

    // windows
    if (_platform.isWindows) {
      List<String> totals = const LineSplitter().convert(total ?? '');
      List<String> frees = const LineSplitter().convert(free ?? '');
      totals = totals.where((e) => e.isNotEmpty).toList();
      frees = frees.where((e) => e.isNotEmpty).toList();
      total = totals.isEmpty ? null : totals.last;
      free = frees.isEmpty ? null : frees.last;
    }
    // macos
    total = total?.replaceFirst('M', '');
    free = free?.replaceFirst('M', '');

    if (_platform.isMacOS) {
      final nTotal = double.tryParse(total ?? '');
      final nFree = double.tryParse(free ?? '');
      total = nTotal == null ? null : (nTotal * 1024).toString();
      free = nFree == null ? null : (nFree * 1024).toString();
    }

    return const MemoryInfo().copyWith(
      totalSize: double.tryParse(total ?? ''),
      freeSize: double.tryParse(free ?? ''),
    );
  }

  Future<String> getGpuInfo() async {
    // linux:
    // name: lshw -c video | grep product | awk '{for(i = 2;i < NF; i++) printf $i " "; print $NF}'
    // WARNING: you should run this program as super-user.
    // WARNING: output may be incomplete or inaccurate, you should run this program as super-user.
    // SVGA II Adapter
    // windows:
    // name: wmic path win32_VideoController get name
    // Name
    // NVIDIA GeForce GTX 1660
    // macos:
    // name: system_profiler SPDisplaysDataType | grep Model | awk '{for(i = 3; i < NF; i++) printf $i " "; print $NF}'
    // NVIDIA GeForce GTX 1660

    String gpuNameCmd = '';

    if (_platform.isLinux) {
      const linuxGpuName =
          "lshw -c video | grep product | awk '{for(i = 2;i < NF; i++) printf \$i \" \"; print \$NF}'";
      gpuNameCmd = linuxGpuName;
    } else if (_platform.isMacOS) {
      const macosGpuName =
          "system_profiler SPDisplaysDataType | grep Model | awk '{for(i = 3; i < NF; i++) printf \$i \" \"; print \$NF}'";
      gpuNameCmd = macosGpuName;
    } else if (_platform.isWindows) {
      const windowsGpuName = 'wmic path win32_VideoController get name';
      gpuNameCmd = windowsGpuName;
    } else {
      throw UnsupportedError('out of OS');
    }

    final gpuNameResult = await _processManager.run(
      [gpuNameCmd],
      runInShell: true,
      sanitize: false,
      includeParentEnvironment: true,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );

    String? gpuName = transformProcessResult(gpuNameResult);

    if (!_platform.isMacOS) {
      List<String> gpus = const LineSplitter().convert(gpuName ?? '');
      gpus = gpus.where((e) => e.isNotEmpty).toList();
      gpuName = gpus.isEmpty ? 'Detect Unavaliable' : gpus.last;
    }

    return gpuName ?? 'Detect Failure';
  }
}
