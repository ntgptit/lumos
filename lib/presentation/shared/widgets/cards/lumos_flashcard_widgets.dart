import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../buttons/lumos_buttons.dart';
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
    return LumosCard(
      onTap: onFlip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(question, style: LumosTextStyle.titleLarge),
          ..._buildExample(sectionSpacing),
          ..._buildTags(sectionSpacing, chipSpacing),
          ..._buildImageHint(sectionSpacing),
        ],
      ),
    );
  }

  List<Widget> _buildExample(double sectionSpacing) {
    if (example == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
      LumosText(
        example!,
        style: LumosTextStyle.bodyMedium,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildTags(double sectionSpacing, double chipSpacing) {
    if (tags == null) {
      return const <Widget>[];
    }
    if (tags!.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
      Wrap(
        spacing: chipSpacing,
        runSpacing: chipSpacing,
        children: tags!
            .map(
              (String tag) =>
                  Chip(label: Text(tag, overflow: TextOverflow.ellipsis)),
            )
            .toList(),
      ),
    ];
  }

  List<Widget> _buildImageHint(double sectionSpacing) {
    if (imageUrl == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
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
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xxl,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double buttonSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      onTap: onFlip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(answer, style: LumosTextStyle.titleLarge),
          ..._buildExplanation(sectionSpacing),
          ..._buildExample(sectionSpacing),
          ..._buildActions(
            context,
            actionSpacing: actionSpacing,
            buttonSpacing: buttonSpacing,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExplanation(double sectionSpacing) {
    if (explanation == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
      LumosText(
        explanation!,
        style: LumosTextStyle.bodyMedium,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildExample(double sectionSpacing) {
    if (example == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
      LumosText(
        example!,
        style: LumosTextStyle.bodySmall,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildActions(
    BuildContext context, {
    required double actionSpacing,
    required double buttonSpacing,
  }) {
    if (onKnown == null && onAgain == null) {
      return const <Widget>[];
    }
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return <Widget>[
      SizedBox(height: actionSpacing),
      Row(
        children: <Widget>[
          Expanded(
            child: LumosOutlineButton(
              label: l10n.flashcardAgainAction,
              onPressed: onAgain,
              size: LumosButtonSize.small,
            ),
          ),
          SizedBox(width: buttonSpacing),
          Expanded(
            child: LumosPrimaryButton(
              label: l10n.flashcardKnownAction,
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
    final double borderRadius = context.appCard.radius;
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double compactSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final Widget child = _buildContent(
      context,
      borderRadius: borderRadius,
      sectionSpacing: sectionSpacing,
      compactSpacing: compactSpacing,
    );
    if (!isInteractive) {
      return child;
    }
    return InkWell(
      onTap: _resolveTapAction(),
      borderRadius: BorderRadii.circular(borderRadius),
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

  Widget _buildContent(
    BuildContext context, {
    required double borderRadius,
    required double sectionSpacing,
    required double compactSpacing,
  }) {
    return AnimatedContainer(
      duration: MotionDurations.animationMedium,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadii.circular(borderRadius),
        color: _resolveStatusColor(context),
      ),
      child: LumosCard(
        borderRadius: BorderRadii.circular(borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(promptText, style: LumosTextStyle.headlineSmall),
            ..._buildPronunciation(sectionSpacing),
            ..._buildTranslation(sectionSpacing),
            ..._buildImageHint(compactSpacing),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPronunciation(double sectionSpacing) {
    if (pronunciation == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
      LumosText(
        pronunciation!,
        style: LumosTextStyle.labelMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildTranslation(double sectionSpacing) {
    final bool shouldShowTranslation = isFlipped || showResultImmediately;
    if (!shouldShowTranslation) {
      return const <Widget>[];
    }
    if (translation == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: sectionSpacing),
      LumosText(
        translation!,
        style: LumosTextStyle.bodyLarge,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildImageHint(double compactSpacing) {
    if (imageUrl == null) {
      return const <Widget>[];
    }
    return <Widget>[
      SizedBox(height: compactSpacing),
      LumosText(
        imageUrl!,
        style: LumosTextStyle.labelSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  Color? _resolveStatusColor(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    if (status == FlashcardStatus.correct) {
      return context.appColors.successContainer.withValues(
        alpha: AppOpacity.stateHover,
      );
    }
    if (status == FlashcardStatus.incorrect) {
      return colorScheme.errorContainer.withValues(
        alpha: AppOpacity.stateHover,
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
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xxl,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
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
        SizedBox(height: sectionSpacing),
        LumosProgressBar(value: (currentIndex + 1) / cards.length),
      ],
    );
  }
}
