import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../inputs/lumos_form_widgets.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosMatchPairs extends StatelessWidget {
  const LumosMatchPairs({
    required this.leftItems,
    required this.rightItems,
    required this.onMatchComplete,
    super.key,
    this.isCompleted = false,
  });

  final List<PairItem> leftItems;
  final List<PairItem> rightItems;
  final ValueChanged<List<MatchedPair>> onMatchComplete;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const LumosText('Match pairs', style: LumosTextStyle.titleMedium),
        const SizedBox(height: Insets.gapBetweenItems),
        Wrap(
          spacing: Insets.spacing8,
          runSpacing: Insets.spacing8,
          children: leftItems
              .map((PairItem item) => Chip(label: Text(item.label)))
              .toList(),
        ),
        const SizedBox(height: Insets.spacing8),
        Wrap(
          spacing: Insets.spacing8,
          runSpacing: Insets.spacing8,
          children: rightItems
              .map((PairItem item) => Chip(label: Text(item.label)))
              .toList(),
        ),
        const SizedBox(height: Insets.gapBetweenItems),
        LumosButton(
          label: isCompleted ? 'Completed' : 'Submit matches',
          onPressed: () {
            onMatchComplete(const <MatchedPair>[]);
          },
          expanded: true,
        ),
      ],
    );
  }
}

class LumosReorderWords extends StatelessWidget {
  const LumosReorderWords({
    required this.words,
    required this.correctOrder,
    required this.onSubmitted,
    super.key,
  });

  final List<String> words;
  final String correctOrder;
  final ValueChanged<bool> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const LumosText('Reorder words', style: LumosTextStyle.titleMedium),
        const SizedBox(height: Insets.gapBetweenItems),
        Wrap(
          spacing: Insets.spacing8,
          runSpacing: Insets.spacing8,
          children: words
              .map((String word) => Chip(label: Text(word)))
              .toList(),
        ),
        const SizedBox(height: Insets.gapBetweenItems),
        LumosButton(
          label: 'Check order',
          onPressed: () {
            final String candidate = words.join(' ');
            onSubmitted(candidate == correctOrder);
          },
          expanded: true,
        ),
      ],
    );
  }
}

class LumosListeningExercise extends StatelessWidget {
  const LumosListeningExercise({
    required this.audioUrl,
    required this.options,
    required this.correctAnswer,
    required this.onAnswer,
    super.key,
  });

  final String audioUrl;
  final List<String> options;
  final String correctAnswer;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const LumosText(
          'Listening exercise',
          style: LumosTextStyle.titleMedium,
        ),
        const SizedBox(height: Insets.spacing8),
        LumosText(
          audioUrl,
          style: LumosTextStyle.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Insets.gapBetweenItems),
        ...options.map(
          (String option) => Padding(
            padding: const EdgeInsets.only(bottom: Insets.spacing8),
            child: LumosButton(
              label: option,
              onPressed: () {
                onAnswer(option);
              },
              type: LumosButtonType.outline,
              expanded: true,
            ),
          ),
        ),
      ],
    );
  }
}

class LumosAnswerInputExercise extends StatelessWidget {
  const LumosAnswerInputExercise({
    required this.mode,
    required this.onSubmit,
    super.key,
    this.userAnswer,
    this.onAnswerChanged,
    this.wordBank,
  });

  final LumosAnswerMode mode;
  final VoidCallback onSubmit;
  final String? userAnswer;
  final ValueChanged<String>? onAnswerChanged;
  final List<String>? wordBank;

  @override
  Widget build(BuildContext context) {
    return LumosAnswerInput(
      mode: mode,
      userAnswer: userAnswer,
      onAnswerChanged: onAnswerChanged,
      onSubmit: onSubmit,
      wordBank: wordBank,
    );
  }
}
