import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PropertyListTile extends StatelessWidget {
  const PropertyListTile({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.description,
    this.trailing,
  }) : super(key: key);
  final String title;
  final String fieldName;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // Widget trailingWidget = _createTextTrailing();
    // if(isInteger) {
    //   trailingWidget =_createIntegerTrailing();
    // } else if(isBoolean) {
    //   trailingWidget = _createBoolTrailing();
    // }
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      title: Text(
        title,
        style: textTheme.caption
            ?.copyWith(fontWeight: FontWeight.bold, color: colorTheme.primary),
      ),
      subtitle: Text(
        fieldName,
        style: textTheme.caption?.copyWith(color: Colors.grey),
      ),
      trailing: Container(
        constraints: const BoxConstraints(maxWidth: 120, maxHeight: 96),
        child: trailing,
      ),
      children: <Widget>[
        Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              color: colorTheme.primary.withAlpha(48),
            ),
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            child: Text(
              description,
              style: textTheme.caption,
            ),
          ),
        ),
      ],
    );
  }
}

class IntegerPropertyListTile extends StatefulWidget {
  const IntegerPropertyListTile({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.description,
    required this.value,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final String fieldName;
  final String description;
  final int value;
  final void Function(int value)? onChanged;

  @override
  State<IntegerPropertyListTile> createState() =>
      _IntegerPropertyListTileState();
}

class _IntegerPropertyListTileState extends State<IntegerPropertyListTile> {
  late TextEditingController _controller;
  @override
  void initState() {
    final onChanged = widget.onChanged;
    _controller = TextEditingController(text: widget.value.toString());
    if (onChanged != null) {
      _controller.addListener(() {
        int? parsed = int.tryParse(_controller.text);
        if (parsed == null) {
          onChanged(0);
        } else {
          onChanged(parsed);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PropertyListTile(
      description: widget.description,
      fieldName: widget.fieldName,
      title: widget.title,
      trailing: TextField(
        controller: _controller,
        style: textTheme.caption,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-*\d+$'))
        ],
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class StringPropertyListTile extends StatefulWidget {
  const StringPropertyListTile({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.description,
    required this.value,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final String fieldName;
  final String description;
  final String value;
  final void Function(String value)? onChanged;

  @override
  State<StringPropertyListTile> createState() => _StringPropertyListTileState();
}

class _StringPropertyListTileState extends State<StringPropertyListTile> {
  late TextEditingController _controller;
  @override
  void initState() {
    final onChanged = widget.onChanged;
    _controller = TextEditingController(text: widget.value.toString());
    if (onChanged != null) {
      _controller.addListener(() {
        onChanged(_controller.text);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PropertyListTile(
      description: widget.description,
      fieldName: widget.fieldName,
      title: widget.title,
      trailing: TextField(
        style: textTheme.caption,
        controller: _controller,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class BoolPropertyListTile extends StatefulWidget {
  const BoolPropertyListTile({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.description,
    required this.value,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final String fieldName;
  final String description;
  final bool value;
  final void Function(bool? value)? onChanged;

  @override
  State<BoolPropertyListTile> createState() => _BoolPropertyListTileState();
}

class _BoolPropertyListTileState extends State<BoolPropertyListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onChanged = widget.onChanged;
    return PropertyListTile(
      description: widget.description,
      fieldName: widget.fieldName,
      title: widget.title,
      trailing: Checkbox(
        value: widget.value,
        onChanged: onChanged,
      ),
    );
  }
}

class EnumIntPropertyListTile extends StatefulWidget {
  const EnumIntPropertyListTile({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.description,
    required this.value,
    required this.selects,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final String fieldName;
  final String description;
  final int value;
  final Map<int, String> selects;
  final void Function(int? value)? onChanged;

  @override
  State<EnumIntPropertyListTile> createState() =>
      _EnumIntPropertyListTileState();
}

class _EnumIntPropertyListTileState extends State<EnumIntPropertyListTile> {
  @override
  Widget build(BuildContext context) {
    final onChanged = widget.onChanged;
    return PropertyListTile(
      description: widget.description,
      fieldName: widget.fieldName,
      title: widget.title,
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          isExpanded: true,
          itemHeight: 32,
          value: widget.value,
          items: widget.selects.entries
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e.key,
                  child: Align(
                    child: Text(
                      e.value,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class EnumStringPropertyListTile extends StatefulWidget {
  const EnumStringPropertyListTile({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.description,
    required this.value,
    required this.selects,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final String fieldName;
  final String description;
  final String value;
  final Map<String, String> selects;
  final void Function(String? value)? onChanged;

  @override
  State<EnumStringPropertyListTile> createState() =>
      _EnumStringPropertyListTileState();
}

class _EnumStringPropertyListTileState
    extends State<EnumStringPropertyListTile> {
  @override
  Widget build(BuildContext context) {
    final onChanged = widget.onChanged;
    return PropertyListTile(
      description: widget.description,
      fieldName: widget.fieldName,
      title: widget.title,
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          itemHeight: 32,
          value: widget.value,
          items: widget.selects.entries
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e.value,
                  child: Align(
                    child: Text(
                      e.key,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
