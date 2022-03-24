import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft_cube_desktop/pages/app_page/pages/server_page/bloc/servers_dropdown_bloc.dart';
import 'package:server_management_repository/server_management_repository.dart';

class ServersDropdown extends StatelessWidget {
  const ServersDropdown({
    Key? key,
    this.projectPath,
    this.onProjectPathChanged,
    this.enabled = true,
  }) : super(key: key);
  final String? projectPath;
  final bool enabled;
  final void Function(String? projectPath)? onProjectPathChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServersDropdownBloc(
        serverManagementRepository: context.read<ServerManagementRepository>(),
      ),
      child: ServersDropdownView(
        projectPath: projectPath,
        onProjectPathChanged: onProjectPathChanged,
      ),
    );
  }
}

class ServersDropdownView extends StatefulWidget {
  const ServersDropdownView({
    Key? key,
    this.projectPath,
    this.onProjectPathChanged,
    this.enabled = true,
  }) : super(key: key);
  final String? projectPath;
  final bool enabled;
  final void Function(String? projectPath)? onProjectPathChanged;

  @override
  State<ServersDropdownView> createState() => _ServersDropdownViewState();
}

class _ServersDropdownViewState extends State<ServersDropdownView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ServersDropdownView oldWidget) {
    final isWidgetUpdated = oldWidget.projectPath != widget.projectPath;
    final isDifferent = widget.projectPath !=
        context.read<ServersDropdownBloc>().state.projectPath;
    if (isWidgetUpdated && isDifferent) {
      context
          .read<ServersDropdownBloc>()
          .add(ServersValueChanged(projectPath: widget.projectPath));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ServersDropdownBloc, ServersDropdownState>(
      builder: (context, state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2(
            buttonWidth: 120,
            itemHeight: 36,
            isExpanded: true,
            buttonPadding: const EdgeInsets.symmetric(horizontal: 8),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.black38,
              ),
              color: Colors.white,
            ),
            value: state.projectPath,
            onChanged: widget.enabled
                ? (String? v) {
                    final onProjectPathChanged = widget.onProjectPathChanged;
                    if (onProjectPathChanged != null) {
                      onProjectPathChanged(v);
                    }
                  }
                : null,
            items: state.serverPathToName.keys
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  state.serverPathToName[value] ?? '',
                  style: textTheme.caption,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
