import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../mode/study_mode_view_model.dart';
import '../../../providers/study_speech_playback_provider.dart';

abstract final class StudySessionReviewContentConst {
  StudySessionReviewContentConst._();

  static const String reviewMode = 'REVIEW';
  static const String rememberedActionId = 'MARK_REMEMBERED';
  static const String retryActionId = 'RETRY_ITEM';
  static const String nextActionId = 'GO_NEXT';
  static const int previousPageIndex = 0;
  static const int currentPageIndex = 1;
  static const int nextPageIndex = 2;
  static const int promptCardFlex = 1;
  static const int answerCardFlex = 1;
  static const double progressHeight = AppSpacing.sm;
  static const EdgeInsetsGeometry contentPadding = EdgeInsets.fromLTRB(
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.xxxl,
  );
  static const EdgeInsetsGeometry cardPadding = EdgeInsets.fromLTRB(
    AppSpacing.xl,
    AppSpacing.lg,
    AppSpacing.xl,
    AppSpacing.xl,
  );
  static const EdgeInsetsGeometry cardTextPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );
}

class StudySessionReviewContent extends StatefulWidget {
  const StudySessionReviewContent({
    required this.session,
    required this.viewModel,
    required this.speechPlaybackState,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudySpeechPlaybackState speechPlaybackState;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  State<StudySessionReviewContent> createState() =>
      _StudySessionReviewContentState();
}

class _StudySessionReviewContentState extends State<StudySessionReviewContent> {
  late final PageController _pageController;
  bool _isPerformingSwipeAction = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: StudySessionReviewContentConst.currentPageIndex,
    );
  }

  @override
  void didUpdateWidget(covariant StudySessionReviewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.currentItem.flashcardId ==
        widget.session.currentItem.flashcardId) {
      return;
    }
    _isPerformingSwipeAction = false;
    _jumpToCurrentPage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: StudySessionReviewContentConst.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _StudySessionReviewProgressRow(
            progressValue: widget.session.progress.sessionProgress,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(child: _buildCardViewport(l10n: l10n)),
        ],
      ),
    );
  }

  void _handlePageChanged(int pageIndex) {
    unawaited(_processPageChanged(pageIndex));
  }

  void _jumpToCurrentPage() {
    if (!_pageController.hasClients) {
      return;
    }
    _pageController.jumpToPage(StudySessionReviewContentConst.currentPageIndex);
  }

  bool _canSwipeHorizontally() {
    return _actionForPage(StudySessionReviewContentConst.previousPageIndex) !=
            null ||
        _actionForPage(StudySessionReviewContentConst.nextPageIndex) != null;
  }

  Future<void> _processPageChanged(int pageIndex) async {
    final String? actionId = _actionForPage(pageIndex);
    if (actionId == null) {
      return;
    }
    if (_isPerformingSwipeAction) {
      return;
    }
    _isPerformingSwipeAction = true;
    _jumpToCurrentPage();
    try {
      await _submitSwipeAction(actionId);
    } finally {
      if (mounted) {
        _isPerformingSwipeAction = false;
        _jumpToCurrentPage();
      }
    }
  }

  String? _actionForPage(int pageIndex) {
    if (pageIndex == StudySessionReviewContentConst.previousPageIndex) {
      if (_allowsAction(StudySessionReviewContentConst.retryActionId)) {
        return StudySessionReviewContentConst.retryActionId;
      }
      if (_allowsAction(StudySessionReviewContentConst.nextActionId)) {
        return StudySessionReviewContentConst.nextActionId;
      }
      return null;
    }
    if (pageIndex == StudySessionReviewContentConst.nextPageIndex) {
      if (_allowsAction(StudySessionReviewContentConst.rememberedActionId)) {
        return StudySessionReviewContentConst.rememberedActionId;
      }
      if (_allowsAction(StudySessionReviewContentConst.nextActionId)) {
        return StudySessionReviewContentConst.nextActionId;
      }
    }
    return null;
  }

  bool _allowsAction(String actionId) {
    return widget.session.allowedActions.contains(actionId);
  }

  Future<void> _submitSwipeAction(String actionId) async {
    await widget.onActionPressed(actionId);
    if (actionId == StudySessionReviewContentConst.nextActionId) {
      return;
    }
    await widget.onActionPressed(StudySessionReviewContentConst.nextActionId);
  }

  Widget _buildCardViewport({required AppLocalizations l10n}) {
    final Widget cards = _StudySessionReviewCardDeck(
      session: widget.session,
      speechPlaybackState: widget.speechPlaybackState,
      onPlaySpeech: widget.onPlaySpeech,
      onReplaySpeech: widget.onReplaySpeech,
      l10n: l10n,
    );
    if (!_canSwipeHorizontally()) {
      return cards;
    }
    return LumosHorizontalPager(
      controller: _pageController,
      itemCount: StudySessionReviewContentConst.nextPageIndex + 1,
      onPageChanged: _handlePageChanged,
      itemBuilder: (BuildContext contextValue, int index) {
        if (index == StudySessionReviewContentConst.currentPageIndex) {
          return cards;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _StudySessionReviewCardDeck extends StatelessWidget {
  const _StudySessionReviewCardDeck({
    required this.session,
    required this.speechPlaybackState,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    required this.l10n,
  });

  final StudySessionData session;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: StudySessionReviewContentConst.promptCardFlex,
          child: _StudySessionReviewCard(
            content: _buildPromptContent(session.currentItem),
            textStyle: context.textTheme.headlineSmall,
            trailing: const LumosIcon(Icons.edit_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          flex: StudySessionReviewContentConst.answerCardFlex,
          child: _StudySessionReviewCard(
            content: _buildAnswerContent(session.currentItem),
            textStyle: context.textTheme.headlineMedium,
            trailing: LumosIconButton(
              icon: speechPlaybackState.isPlaying
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              tooltip: speechPlaybackState.isPlaying
                  ? l10n.studySpeechReplayAction
                  : l10n.flashcardPlayAudioTooltip,
              onPressed: session.currentItem.speech.available
                  ? _handleSpeechPressed
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSpeechPressed() {
    if (speechPlaybackState.isPlaying) {
      onReplaySpeech();
      return;
    }
    onPlaySpeech();
  }

  String _buildPromptContent(StudySessionItemData currentItem) {
    if (currentItem.note.isEmpty) {
      return currentItem.prompt;
    }
    if (currentItem.prompt.isEmpty) {
      return currentItem.note;
    }
    return '${currentItem.prompt} / ${currentItem.note}';
  }

  String _buildAnswerContent(StudySessionItemData currentItem) {
    if (currentItem.answer.isNotEmpty) {
      return currentItem.answer;
    }
    return currentItem.pronunciation;
  }
}

class _StudySessionReviewProgressRow extends StatelessWidget {
  const _StudySessionReviewProgressRow({required this.progressValue});

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final int progressPercent = (progressValue * 100).round();
    final Color progressColor = context.appColors.success;
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosProgressBar(
            value: progressValue,
            height: StudySessionReviewContentConst.progressHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        LumosInlineText(
          '$progressPercent%',
          align: TextAlign.center,
          style: context.textTheme.titleLarge?.copyWith(color: progressColor),
        ),
      ],
    );
  }
}

class _StudySessionReviewCard extends StatelessWidget {
  const _StudySessionReviewCard({
    required this.content,
    required this.trailing,
    this.textStyle,
  });

  final String content;
  final Widget trailing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: StudySessionReviewContentConst.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(alignment: Alignment.topRight, child: trailing),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: StudySessionReviewContentConst.cardTextPadding,
                    child: LumosInlineText(
                      content,
                      align: TextAlign.center,
                      style: textStyle?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
