import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../feedback/lumos_progress_bar.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';
import 'lumos_card.dart';

class LumosFlashcardFront extends StatelessWidget {
  const LumosFlashcardFront({
    required this.question,
    super.key,
    this.example,
    this.imageUrl,
    this.tags,
    this.onFlip,
  });

  final String question;
  final String? example;
  final String? imageUrl;
  final List<String>? tags;
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      onTap: onFlip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(question, style: LumosTextStyle.titleLarge),
          ..._buildExample(),
          ..._buildTags(),
          ..._buildImageHint(),
        ],
      ),
    );
  }

  List<Widget> _buildExample() {
    if (example == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      LumosText(
        example!,
        style: LumosTextStyle.bodyMedium,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildTags() {
    if (tags == null) {
      return const <Widget>[];
    }
    if (tags!.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      Wrap(
        spacing: Insets.spacing8,
        runSpacing: Insets.spacing8,
        children: tags!
            .map(
              (String tag) =>
                  Chip(label: Text(tag, overflow: TextOverflow.ellipsis)),
            )
            .toList(),
      ),
    ];
  }

  List<Widget> _buildImageHint() {
    if (imageUrl == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      LumosText(
        imageUrl!,
        style: LumosTextStyle.labelSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }
}

class LumosFlashcardBack extends StatelessWidget {
  const LumosFlashcardBack({
    required this.answer,
    super.key,
    this.explanation,
    this.example,
    this.onFlip,
    this.onKnown,
    this.onAgain,
  });

  final String answer;
  final String? explanation;
  final String? example;
  final VoidCallback? onFlip;
  final VoidCallback? onKnown;
  final VoidCallback? onAgain;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      onTap: onFlip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(answer, style: LumosTextStyle.titleLarge),
          ..._buildExplanation(),
          ..._buildExample(),
          ..._buildActions(),
        ],
      ),
    );
  }

  List<Widget> _buildExplanation() {
    if (explanation == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      LumosText(
        explanation!,
        style: LumosTextStyle.bodyMedium,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildExample() {
    if (example == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      LumosText(
        example!,
        style: LumosTextStyle.bodySmall,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildActions() {
    if (onKnown == null && onAgain == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenSections),
      Row(
        children: <Widget>[
          Expanded(
            child: LumosButton(
              label: 'Again',
              onPressed: onAgain,
              type: LumosButtonType.outline,
              size: LumosButtonSize.small,
            ),
          ),
          const SizedBox(width: Insets.gapBetweenItems),
          Expanded(
            child: LumosButton(
              label: 'Known',
              onPressed: onKnown,
              size: LumosButtonSize.small,
            ),
          ),
        ],
      ),
    ];
  }
}

class LumosFlashcard extends StatelessWidget {
  const LumosFlashcard({
    required this.promptText,
    super.key,
    this.translation,
    this.pronunciation,
    this.imageUrl,
    this.isFlipped = false,
    this.onFlip,
    this.isInteractive = true,
    this.status = FlashcardStatus.unanswered,
    this.showResultImmediately = false,
  });

  final String promptText;
  final String? translation;
  final String? pronunciation;
  final String? imageUrl;
  final bool isFlipped;
  final ValueChanged<bool>? onFlip;
  final bool isInteractive;
  final FlashcardStatus status;
  final bool showResultImmediately;

  @override
  Widget build(BuildContext context) {
    final Widget child = _buildContent(context);
    if (!isInteractive) {
      return child;
    }
    return InkWell(
      onTap: _resolveTapAction(),
      borderRadius: BorderRadii.large,
      child: child,
    );
  }

  VoidCallback? _resolveTapAction() {
    if (onFlip == null) {
      return null;
    }
    return () {
      onFlip!.call(!isFlipped);
    };
  }

  Widget _buildContent(BuildContext context) {
    return AnimatedContainer(
      duration: MotionDurations.animationMedium,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadii.large,
        color: _resolveStatusColor(context),
      ),
      child: LumosCard(
        borderRadius: BorderRadii.large,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(promptText, style: LumosTextStyle.headlineSmall),
            ..._buildPronunciation(),
            ..._buildTranslation(),
            ..._buildImageHint(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPronunciation() {
    if (pronunciation == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      LumosText(
        pronunciation!,
        style: LumosTextStyle.labelMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildTranslation() {
    final bool shouldShowTranslation = isFlipped || showResultImmediately;
    if (!shouldShowTranslation) {
      return const <Widget>[];
    }
    if (translation == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      LumosText(
        translation!,
        style: LumosTextStyle.bodyLarge,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildImageHint() {
    if (imageUrl == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing8),
      LumosText(
        imageUrl!,
        style: LumosTextStyle.labelSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  Color? _resolveStatusColor(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (status == FlashcardStatus.correct) {
      return colorScheme.tertiaryContainer.withValues(
        alpha: WidgetSizes.inputFillOpacity,
      );
    }
    if (status == FlashcardStatus.incorrect) {
      return colorScheme.errorContainer.withValues(
        alpha: WidgetSizes.inputFillOpacity,
      );
    }
    return null;
  }
}

class LumosFlashcardStack extends StatelessWidget {
  const LumosFlashcardStack({
    required this.cards,
    required this.currentIndex,
    required this.onCardResult,
    required this.onSessionComplete,
    super.key,
  });

  final List<FlashcardItem> cards;
  final int currentIndex;
  final ValueChanged<FlashcardResult> onCardResult;
  final VoidCallback onSessionComplete;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }
    if (currentIndex >= cards.length) {
      onSessionComplete.call();
      return const SizedBox.shrink();
    }
    final FlashcardItem currentCard = cards[currentIndex];
    return Column(
      children: <Widget>[
        LumosFlashcard(
          promptText: currentCard.promptText,
          translation: currentCard.translation,
          pronunciation: currentCard.pronunciation,
          imageUrl: currentCard.imageUrl,
          isFlipped: false,
        ),
        const SizedBox(height: Insets.gapBetweenSections),
        LumosProgressBar(value: (currentIndex + 1) / cards.length),
      ],
    );
  }
}
