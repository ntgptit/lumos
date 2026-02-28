import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../buttons/lumos_icon_button.dart';
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
    this.prefixIcon,
    this.suffixIcon,
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
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final InputDecoration decoration = InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      alignLabelWithHint: maxLines != 1,
    );
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      decoration: decoration,
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
    return SearchBar(
      controller: controller,
      hintText: hint,
      onChanged: onSearch,
      onSubmitted: onSearch,
      autoFocus: autoFocus,
      leading: const Icon(Icons.search),
      trailing: _buildTrailingActions(),
      constraints: const BoxConstraints(minHeight: WidgetSizes.minTouchTarget),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: Insets.spacing12),
      ),
      elevation: const WidgetStatePropertyAll<double>(WidgetSizes.none),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder()),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
    );
  }

  List<Widget>? _buildTrailingActions() {
    if (onClear == null) {
      return null;
    }
    return <Widget>[
      LumosIconButton(
        icon: Icons.close_rounded,
        tooltip: _resolveClearTooltip(),
        onPressed: onClear,
      ),
    ];
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
    if (direction == Axis.horizontal) {
      return RadioGroup<T>(
        groupValue: value,
        onChanged: onChanged,
        child: Wrap(spacing: Insets.spacing8, children: tiles),
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
    return Wrap(
      spacing: Insets.spacing8,
      runSpacing: Insets.spacing8,
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
      return _buildMultipleChoice();
    }
    if (mode == LumosAnswerMode.speaking) {
      return _buildSpeaking();
    }
    return _buildTyping();
  }

  Widget _buildTyping() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosTextField(
          hint: 'Type your answer',
          initialValue: userAnswer,
          onChanged: onAnswerChanged,
        ),
        const SizedBox(height: Insets.gapBetweenItems),
        LumosButton(label: 'Submit', onPressed: onSubmit),
      ],
    );
  }

  Widget _buildSpeaking() {
    return LumosButton(
      label: 'Tap to speak',
      icon: Icons.mic,
      onPressed: onSubmit,
      expanded: true,
    );
  }

  Widget _buildMultipleChoice() {
    final List<String> options = wordBank ?? const <String>[];
    return Wrap(
      spacing: Insets.spacing8,
      runSpacing: Insets.spacing8,
      children: options
          .map(
            (String option) => LumosButton(
              label: option,
              onPressed: () {
                if (onAnswerChanged != null) {
                  onAnswerChanged!(option);
                }
                onSubmit.call();
              },
              type: LumosButtonType.outline,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(sentence, overflow: TextOverflow.ellipsis, maxLines: 2),
        const SizedBox(height: Insets.gapBetweenItems),
        if (options != null)
          Wrap(
            spacing: Insets.spacing8,
            runSpacing: Insets.spacing8,
            children: options!
                .map(
                  (String option) => LumosButton(
                    label: option,
                    onPressed: () {
                      onAnswer(option);
                    },
                    type: LumosButtonType.outline,
                    size: LumosButtonSize.small,
                  ),
                )
                .toList(),
          ),
        if (options == null)
          LumosTextField(hint: 'Fill the blank', onChanged: onAnswer),
      ],
    );
  }
}
