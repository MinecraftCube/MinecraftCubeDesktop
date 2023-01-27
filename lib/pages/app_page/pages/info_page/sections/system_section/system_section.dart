import 'dart:math' as Math;
import 'package:cube_api/cube_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:java_info_repository/java_info_repository.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/cpu_info_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/gpu_info_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/memory_info_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/portable_java_info_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/bloc/system_java_info_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/system_section/system_section.i18n.dart';
import 'package:system_repository/system_repository.dart';

class SystemSection extends StatelessWidget {
  const SystemSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CpuInfoBloc(
            systemRepository: context.read<SystemRepository>(),
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (context) => MemoryInfoBloc(
            systemRepository: context.read<SystemRepository>(),
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              GpuInfoBloc(systemRepository: context.read<SystemRepository>()),
        ),
        BlocProvider(
          create: (context) => PortableJavaInfoBloc(
            javaInfoRepository: context.read<JavaInfoRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => SystemJavaInfoBloc(
            javaInfoRepository: context.read<JavaInfoRepository>(),
          ),
        ),
      ],
      child: const SystemSectionView(),
    );
  }
}

class SystemSectionView extends StatefulWidget {
  const SystemSectionView({Key? key}) : super(key: key);

  @override
  State<SystemSectionView> createState() => _SystemSectionViewState();
}

class _SystemSectionViewState extends State<SystemSectionView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          CpuInfoSection(),
          MemoryInfoSection(),
          GpuInfoSection(),
          Divider(),
          SystemJavaInfoSection(),
          PortableJavaInfoSection(),
        ],
      ),
    );
  }
}

class CpuInfoSection extends StatefulWidget {
  const CpuInfoSection({Key? key}) : super(key: key);

  @override
  State<CpuInfoSection> createState() => _CpuInfoSectionState();
}

class _CpuInfoSectionState extends State<CpuInfoSection> {
  @override
  void initState() {
    context.read<CpuInfoBloc>().add(const CpuInfoStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpuInfoBloc, CpuInfoState>(
      builder: (context, state) {
        return ListTile(
          leading: Text(systemSectionCpu.i18n),
          title: LinearProgressIndicator(
            value: state.info.load / 100.0,
          ),
          subtitle: Text('${state.info.name} (${state.info.load}%)'),
        );
      },
    );
  }
}

class MemoryInfoSection extends StatefulWidget {
  const MemoryInfoSection({Key? key}) : super(key: key);

  @override
  State<MemoryInfoSection> createState() => _MemoryInfoSectionState();
}

class _MemoryInfoSectionState extends State<MemoryInfoSection> {
  @override
  void initState() {
    context.read<MemoryInfoBloc>().add(const MemoryInfoStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryInfoBloc, MemoryInfoState>(
      builder: (context, state) {
        final totalSize = (state.info.totalSize ?? 0.0) + 1.0;
        final freeSize = state.info.freeSize ?? 0.0;
        final usedSize = totalSize - freeSize;
        final number = usedSize / totalSize;
        final percent = 100 * number;
        return ListTile(
          leading: Text(systemSectionRam.i18n),
          title: LinearProgressIndicator(
            value: Math.min(Math.max(number, 0), 1),
          ),
          subtitle:
              Text('$usedSize/$totalSize (${percent.toStringAsFixed(1)}%)'),
        );
      },
    );
  }
}

class GpuInfoSection extends StatefulWidget {
  const GpuInfoSection({Key? key}) : super(key: key);

  @override
  State<GpuInfoSection> createState() => _GpuInfoSectionState();
}

class _GpuInfoSectionState extends State<GpuInfoSection> {
  @override
  void initState() {
    context.read<GpuInfoBloc>().add(const GpuInfoStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpuInfoBloc, GpuInfoState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        final contentStyle =
            textTheme.bodyMedium?.copyWith(color: textTheme.bodySmall?.color);
        return ListTile(
          leading: Text(systemSectionGpu.i18n),
          title: Text(
            state.info,
            style: contentStyle,
          ),
        );
      },
    );
  }
}

class SystemJavaInfoSection extends StatefulWidget {
  const SystemJavaInfoSection({Key? key}) : super(key: key);

  @override
  State<SystemJavaInfoSection> createState() => _SystemJavaInfoSectionState();
}

class _SystemJavaInfoSectionState extends State<SystemJavaInfoSection> {
  @override
  void initState() {
    context.read<SystemJavaInfoBloc>().add(const SystemJavaInfoStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemJavaInfoBloc, SystemJavaInfoState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        final colorTheme = Theme.of(context).colorScheme;
        final info = state.info;
        final contentStyle =
            textTheme.bodyMedium?.copyWith(color: textTheme.bodySmall?.color);
        const gap = SizedBox(
          height: 8,
        );
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                systemSectionSystemJava.i18n,
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              gap,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorTheme.background),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(systemSectionSystemJavaLocations.i18n),
                    ),
                    Text(
                      (info?.executablePaths ?? []).join('\n'),
                      style: contentStyle,
                    ),
                  ],
                ),
              ),
              gap,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorTheme.background),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(systemSectionSystemJavaInfos.i18n),
                    ),
                    Text(
                      info?.output.trim() ?? '',
                      style: contentStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PortableJavaInfoSection extends StatefulWidget {
  const PortableJavaInfoSection({Key? key}) : super(key: key);

  @override
  State<PortableJavaInfoSection> createState() =>
      _PortableJavaInfoSectionState();
}

class _PortableJavaInfoSectionState extends State<PortableJavaInfoSection> {
  @override
  void initState() {
    context.read<PortableJavaInfoBloc>().add(const PortableJavaInfoStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortableJavaInfoBloc, PortableJavaInfoState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        final infos = state.infos;
        const gap = SizedBox(
          height: 8,
        );
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                systemSectionPortableJava.i18n,
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              gap,
              ...infos.map(
                (e) => Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(e.name),
                    ),
                    Text(e.executablePaths.join('\n')),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
