import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';

class LumosSearchField extends StatefulWidget {
  const LumosSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.clearTooltip,
    this.label,
    this.supportingText,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? clearTooltip;
  final String? label;
  final String? supportingText;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  State<LumosSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<LumosSearchField> {
  late final TextEditingController _internalController;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant LumosSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.controller ?? _internalController;
    final newController = widget.controller ?? _internalController;
    if (oldController != newController) {
      oldController.removeListener(_handleControllerChanged);
      newController.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _internalController).removeListener(
      _handleControllerChanged,
    );
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LumosTextField(
      label: widget.label,
      supportingText: widget.supportingText,
      controller: _controller,
      focusNode: widget.focusNode,
      hintText: widget.hintText ?? context.l10n.searchLabel,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      prefixIcon: Icon(Icons.search_rounded, size: context.iconSize.lg),
      suffixIcon: _controller.text.isEmpty
          ? null
          : IconButton(
              onPressed: widget.enabled ? _clear : null,
              tooltip: widget.clearTooltip ?? context.l10n.clearSearchTooltip,
              icon: Icon(Icons.close_rounded, size: context.iconSize.md),
            ),
    );
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
