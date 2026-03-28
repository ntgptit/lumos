import 'package:flutter/material.dart';

class LumosRadioGroup<T> extends StatelessWidget {
  const LumosRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
  });

  final List<T> options;
  final T value;
  final ValueChanged<T?> onChanged;
  final String Function(T value) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        return RadioListTile<T>(
          value: option,
          groupValue: value,
          onChanged: onChanged,
          title: Text(labelBuilder(option)),
        );
      }).toList(growable: false),
    );
  }
}
