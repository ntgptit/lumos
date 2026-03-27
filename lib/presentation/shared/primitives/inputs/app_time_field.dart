import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/inputs/app_text_field.dart';

class AppTimeField extends StatefulWidget {
  const AppTimeField({
    super.key,
    this.label,
    this.supportingText,
    this.labelTrailing,
    this.isRequired = false,
    this.value,
    this.onChanged,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.clearable = true,
  });

  final String? label;
  final String? supportingText;
  final Widget? labelTrailing;
  final bool isRequired;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool clearable;

  @override
  State<AppTimeField> createState() => _AppTimeFieldState();
}

class _AppTimeFieldState extends State<AppTimeField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncControllerText();
  }

  @override
  void didUpdateWidget(covariant AppTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _syncControllerText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      supportingText: widget.supportingText,
      labelTrailing: widget.labelTrailing,
      isRequired: widget.isRequired,
      controller: _controller,
      hintText: widget.hintText ?? context.l10n.selectTimeLabel,
      helperText: widget.helperText,
      errorText: widget.errorText,
      enabled: widget.enabled,
      readOnly: true,
      onTap: widget.enabled ? _pickTime : null,
      suffixIcon: _TimeSuffix(
        hasValue: widget.value != null,
        clearable: widget.clearable,
        enabled: widget.enabled,
        onClear: _clear,
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.value ?? TimeOfDay.now(),
    );
    if (picked == null) {
      return;
    }
    widget.onChanged?.call(picked);
  }

  void _clear() {
    widget.onChanged?.call(null);
  }

  void _syncControllerText() {
    final nextText = _formatted(widget.value);
    if (_controller.text != nextText) {
      _controller.text = nextText;
    }
  }

  String _formatted(TimeOfDay? value) {
    if (value == null) {
      return '';
    }
    return MaterialLocalizations.of(context).formatTimeOfDay(value);
  }
}

class _TimeSuffix extends StatelessWidget {
  const _TimeSuffix({
    required this.hasValue,
    required this.clearable,
    required this.enabled,
    required this.onClear,
  });

  final bool hasValue;
  final bool clearable;
  final bool enabled;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (clearable && hasValue)
          IconButton(
            onPressed: enabled ? onClear : null,
            tooltip: context.l10n.clearTimeTooltip,
            icon: Icon(Icons.close_rounded, size: context.iconSize.md),
          ),
        Icon(Icons.schedule_rounded, size: context.iconSize.md),
        SizedBox(width: context.spacing.sm),
      ],
    );
  }
}
