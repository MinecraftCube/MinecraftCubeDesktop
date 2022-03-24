import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/bloc/network_gateway_ip_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/bloc/network_internal_ip_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/bloc/network_public_ip_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/info_page/sections/network_section/network_section.i18n.dart';
import 'package:network_repository/network_repository.dart';

class NetworkSection extends StatelessWidget {
  const NetworkSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NetworkPublicIpBloc(
            networkRepository: context.read<NetworkRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => NetworkInternalIpBloc(
            networkRepository: context.read<NetworkRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => NetworkGatewayIpBloc(
            networkRepository: context.read<NetworkRepository>(),
          ),
        ),
      ],
      child: const NetworkSectionView(),
    );
  }
}

class NetworkSectionView extends StatefulWidget {
  const NetworkSectionView({Key? key}) : super(key: key);

  @override
  State<NetworkSectionView> createState() => _NetworkSectionViewState();
}

class _NetworkSectionViewState extends State<NetworkSectionView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // boxShadow: kElevationToShadow[2],
        ),
        child: ListView(
          shrinkWrap: true,
          children: const [
            PublicIpSection(),
            Divider(),
            InternalIpSection(),
            Divider(),
            GatewayIpSection(),
          ],
        ),
      ),
    );
  }
}

class PublicIpSection extends StatefulWidget {
  const PublicIpSection({Key? key}) : super(key: key);

  @override
  State<PublicIpSection> createState() => _PublicIpSectionState();
}

class _PublicIpSectionState extends State<PublicIpSection> {
  @override
  void initState() {
    super.initState();
    context.read<NetworkPublicIpBloc>().add(const NetworkPublicIpStarted());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<NetworkPublicIpBloc, NetworkPublicIpState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              networkSectionPublicIp.i18n,
              style: textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              state.ip,
              style: textTheme.subtitle2?.copyWith(color: Colors.green),
            ),
          ],
        );
      },
    );
  }
}

class GatewayIpSection extends StatefulWidget {
  const GatewayIpSection({Key? key}) : super(key: key);

  @override
  State<GatewayIpSection> createState() => _GatewayIpSectionState();
}

class _GatewayIpSectionState extends State<GatewayIpSection> {
  @override
  void initState() {
    super.initState();
    context.read<NetworkGatewayIpBloc>().add(const NetworkGatewayIpStarted());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<NetworkGatewayIpBloc, NetworkGatewayIpState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              networkSectionGatewayIp.i18n,
              style: textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
            ),
            ...state.ips.map(
              (ip) => Text(
                ip,
                style: textTheme.subtitle2?.copyWith(color: Colors.green),
              ),
            )
          ],
        );
      },
    );
  }
}

class InternalIpSection extends StatefulWidget {
  const InternalIpSection({Key? key}) : super(key: key);

  @override
  State<InternalIpSection> createState() => _InternalIpSectionState();
}

class _InternalIpSectionState extends State<InternalIpSection> {
  @override
  void initState() {
    super.initState();
    context.read<NetworkInternalIpBloc>().add(const NetworkInternalIpStarted());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<NetworkInternalIpBloc, NetworkInternalIpState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              networkSectionInternalIp.i18n,
              style: textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.ips
                  .map(
                    (interface) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            interface.name,
                            style: textTheme.bodyText2
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          ...interface.addresses.map(
                            (e) => Text(
                              e.address,
                              style: textTheme.subtitle2
                                  ?.copyWith(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        );
      },
    );
  }
}
