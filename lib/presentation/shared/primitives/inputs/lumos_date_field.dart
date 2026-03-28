import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';

class LumosDateField extends StatefulWidget {
  const LumosDateField({
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
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.selectableDayPredicate,
    this.dateFormat,
  });

  final String? label;
  final String? supportingText;
  final Widget? labelTrailing;
  final bool isRequired;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool clearable;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final SelectableDayPredicate? selectableDayPredicate;
  final DateFormat? dateFormat;

  @override
  State<LumosDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<LumosDateField> {
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
  void didUpdateWidget(covariant LumosDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.dateFormat != widget.dateFormat) {
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
    return LumosTextField(
      label: widget.label,
      supportingText: widget.supportingText,
      labelTrailing: widget.labelTrailing,
      isRequired: widget.isRequired,
      controller: _controller,
      hintText: widget.hintText ?? context.l10n.selectDateLabel,
      helperText: widget.helperText,
      errorText: widget.errorText,
      enabled: widget.enabled,
      readOnly: true,
      onTap: widget.enabled ? _pickDate : null,
      suffixIcon: _DateSuffix(
        hasValue: widget.value != null,
        clearable: widget.clearable,
        enabled: widget.enabled,
        onClear: _clear,
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = widget.firstDate ?? DateTime(now.year - 10);
    final lastDate = widget.lastDate ?? DateTime(now.year + 10);
    final initialDate =
        widget.value ??
        _clampDate(widget.initialDate ?? now, firstDate, lastDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: widget.selectableDayPredicate,
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

  String _formatted(DateTime? value) {
    if (value == null) {
      return '';
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = widget.dateFormat ?? DateFormat.yMMMd(locale);
    return formatter.format(value);
  }

  DateTime _clampDate(DateTime value, DateTime firstDate, DateTime lastDate) {
    if (value.isBefore(firstDate)) {
      return firstDate;
    }
    if (value.isAfter(lastDate)) {
      return lastDate;
    }
    return value;
  }
}

class _DateSuffix extends StatelessWidget {
  const _DateSuffix({
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
            tooltip: context.l10n.clearDateTooltip,
            icon: Icon(Icons.close_rounded, size: context.iconSize.md),
          ),
        Icon(Icons.calendar_today_rounded, size: context.iconSize.md),
        SizedBox(width: context.spacing.sm),
      ],
    );
  }
}
