import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown_field.dart';

class LumosDropdown<T> extends StatelessWidget {
  const LumosDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return LumosDropdownField<T>(
      items: items,
      value: value,
      onChanged: onChanged,
      label: label,
    );
  }
}
