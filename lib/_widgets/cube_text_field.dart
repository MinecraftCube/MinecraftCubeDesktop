import 'package:flutter/material.dart';

class CubeTextField extends StatelessWidget {
  const CubeTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.contentPadding,
    this.keyboardType,
    this.maxLines,
  }) : super(key: key);
  final TextEditingController controller;
  final String? hintText;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inputBorder = const InputDecoration.collapsed(
      hintText: '',
      filled: true,
      fillColor: Colors.white60,
    ).copyWith(
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.secondary,
        ),
        // borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.secondary,
        ),
        // borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    );

    return TextFormField(
      decoration: inputBorder.copyWith(hintText: hintText),
      controller: controller,
      style: TextStyle(color: colorScheme.primary),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
    );
  }
}
