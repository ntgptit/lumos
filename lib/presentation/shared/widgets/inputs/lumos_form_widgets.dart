import 'package:flutter/material.dart';

import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
import '../buttons/lumos_buttons.dart';
import '../lumos_models.dart';

class LumosTextField extends StatelessWidget {
  const LumosTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.expands = false,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textStyle,
    this.decoration,
  });

  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool expands;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextStyle? textStyle;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final int? resolvedMaxLines = expands ? null : maxLines;
    final Widget? resolvedPrefixIcon = _wrapIcon(context, child: prefixIcon);
    final Widget? resolvedSuffixIcon = _wrapIcon(context, child: suffixIcon);
    final InputDecoration resolvedDecoration =
        decoration ??
        InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: resolvedPrefixIcon,
          suffixIcon: resolvedSuffixIcon,
          alignLabelWithHint: expands || resolvedMaxLines != 1,
        );
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: resolvedMaxLines,
      expands: expands,
      enabled: enabled,
      autofocus: autofocus,
      onFieldSubmitted: onSubmitted,
      textInputAction: textInputAction,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      style: textStyle ?? context.textTheme.bodyMedium,
      decoration: resolvedDecoration,
    );
  }

  Widget? _wrapIcon(BuildContext context, {required Widget? child}) {
    if (child == null) {
      return null;
    }
    return IconTheme.merge(
      data: IconThemeData(size: context.appInput.iconSize),
      child: child,
    );
  }
}

class LumosSearchBar extends StatelessWidget {
  const LumosSearchBar({
    required this.onSearch,
    super.key,
    this.onClear,
    this.clearTooltip,
    this.hint,
    this.autoFocus = false,
    this.controller,
  }) : assert(onClear == null || clearTooltip != null || hint != null);

  final ValueChanged<String> onSearch;
  final VoidCallback? onClear;
  final String? clearTooltip;
  final String? hint;
  final bool autoFocus;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return LumosTextField(
      controller: controller,
      hint: hint,
      onChanged: onSearch,
      onSubmitted: onSearch,
      autofocus: autoFocus,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: _buildClearAction(),
    );
  }

  Widget? _buildClearAction() {
    if (onClear == null) {
      return null;
    }
    return IconButton(
      icon: const Icon(Icons.close_rounded),
      tooltip: _resolveClearTooltip(),
      onPressed: onClear,
    );
  }

  String? _resolveClearTooltip() {
    if (clearTooltip != null) {
      return clearTooltip;
    }
    return hint;
  }
}

class LumosDropdown<T> extends StatelessWidget {
  const LumosDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.label,
    this.hint,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      items: items,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}

class LumosRadioGroup<T> extends StatelessWidget {
  const LumosRadioGroup({
    required this.options,
    required this.labelBuilder,
    required this.value,
    required this.onChanged,
    super.key,
    this.direction = Axis.vertical,
  });

  final List<T> options;
  final String Function(T) labelBuilder;
  final T? value;
  final ValueChanged<T?> onChanged;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = _buildTiles();
    final double compactSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    if (direction == Axis.horizontal) {
      return RadioGroup<T>(
        groupValue: value,
        onChanged: onChanged,
        child: Wrap(spacing: compactSpacing, children: tiles),
      );
    }
    return RadioGroup<T>(
      groupValue: value,
      onChanged: onChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tiles,
      ),
    );
  }

  List<Widget> _buildTiles() {
    return options
        .map(
          (T option) => RadioListTile<T>(
            title: Text(labelBuilder(option), overflow: TextOverflow.ellipsis),
            value: option,
            contentPadding: EdgeInsets.zero,
          ),
        )
        .toList();
  }
}

class LumosWordBank extends StatelessWidget {
  const LumosWordBank({
    required this.words,
    required this.onWordSelected,
    super.key,
    this.isEnabled = true,
    this.disabledWords,
  });

  final List<String> words;
  final ValueChanged<String> onWordSelected;
  final bool isEnabled;
  final List<String>? disabledWords;

  @override
  Widget build(BuildContext context) {
    final double chipSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Wrap(
      spacing: chipSpacing,
      runSpacing: chipSpacing,
      children: words.map(_buildWordChip).toList(),
    );
  }

  Widget _buildWordChip(String word) {
    final bool disabled = _isDisabled(word);
    return ActionChip(
      label: Text(word, overflow: TextOverflow.ellipsis),
      onPressed: _resolveWordAction(word, disabled),
    );
  }

  bool _isDisabled(String word) {
    if (!isEnabled) {
      return true;
    }
    if (disabledWords == null) {
      return false;
    }
    return disabledWords!.contains(word);
  }

  VoidCallback? _resolveWordAction(String word, bool disabled) {
    if (disabled) {
      return null;
    }
    return () {
      onWordSelected(word);
    };
  }
}

class LumosAnswerInput extends StatelessWidget {
  const LumosAnswerInput({
    required this.mode,
    required this.onSubmit,
    super.key,
    this.userAnswer,
    this.onAnswerChanged,
    this.isCorrect,
    this.wordBank,
    this.ignoreTypos = false,
  });

  final LumosAnswerMode mode;
  final String? userAnswer;
  final ValueChanged<String>? onAnswerChanged;
  final VoidCallback onSubmit;
  final bool? isCorrect;
  final List<String>? wordBank;
  final bool ignoreTypos;

  @override
  Widget build(BuildContext context) {
    if (mode == LumosAnswerMode.multipleChoice) {
      return _buildMultipleChoice(context);
    }
    if (mode == LumosAnswerMode.speaking) {
      return _buildSpeaking(context);
    }
    return _buildTyping(context);
  }

  Widget _buildTyping(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosTextField(
          hint: l10n.formAnswerHint,
          initialValue: userAnswer,
          onChanged: onAnswerChanged,
        ),
        SizedBox(height: sectionSpacing),
        LumosPrimaryButton(label: l10n.commonSubmit, onPressed: onSubmit),
      ],
    );
  }

  Widget _buildSpeaking(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosPrimaryButton(
      label: l10n.formTapToSpeakAction,
      icon: Icons.mic,
      onPressed: onSubmit,
      expanded: true,
    );
  }

  Widget _buildMultipleChoice(BuildContext context) {
    final List<String> options = wordBank ?? const <String>[];
    final double chipSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Wrap(
      spacing: chipSpacing,
      runSpacing: chipSpacing,
      children: options
          .map(
            (String option) => LumosOutlineButton(
              label: option,
              onPressed: () {
                if (onAnswerChanged != null) {
                  onAnswerChanged!(option);
                }
                onSubmit.call();
              },
              size: LumosButtonSize.small,
            ),
          )
          .toList(),
    );
  }
}

class LumosFillBlank extends StatelessWidget {
  const LumosFillBlank({
    required this.sentence,
    required this.correctAnswer,
    required this.onAnswer,
    super.key,
    this.options,
  });

  final String sentence;
  final List<String>? options;
  final String correctAnswer;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double chipSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(sentence, overflow: TextOverflow.ellipsis, maxLines: 2),
        SizedBox(height: sectionSpacing),
        if (options != null)
          Wrap(
            spacing: chipSpacing,
            runSpacing: chipSpacing,
            children: options!
                .map(
                  (String option) => LumosOutlineButton(
                    label: option,
                    onPressed: () {
                      onAnswer(option);
                    },
                    size: LumosButtonSize.small,
                  ),
                )
                .toList(),
          ),
        if (options == null)
          LumosTextField(hint: l10n.formFillBlankHint, onChanged: onAnswer),
      ],
    );
  }
}
