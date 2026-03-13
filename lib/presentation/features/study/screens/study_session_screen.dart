import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../mode/study_mode_view_model.dart';
import '../mode/study_mode_view_strategy.dart';
import '../providers/study_match_selection_provider.dart';
import '../providers/study_speech_playback_provider.dart';
import '../providers/study_mode_view_strategy_factory_provider.dart';
import '../providers/study_session_provider.dart';
import 'widgets/blocks/study_session_content.dart';
import 'widgets/blocks/study_session_review_content.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
  const StudySessionScreen({
    required this.deckId,
    required this.deckName,
    this.sessionId,
    super.key,
  });

  final int deckId;
  final String deckName;
  final int? sessionId;

  @override
  ConsumerState<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen> {
  static const String _reviewMenuReplayAudio = 'REPLAY_AUDIO';

  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StudySessionLaunchRequest request = _request;
    final AsyncValue<StudySessionData> sessionAsync = ref.watch(
      studySessionControllerProvider(request),
    );
    final modeStrategyFactory = ref.watch(studyModeViewStrategyFactoryProvider);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    StudySessionData? currentSession;
    StudyModeViewModel? appBarViewModel;
    sessionAsync.whenData((StudySessionData session) {
      currentSession = session;
      final StudyModeViewStrategy modeStrategy = modeStrategyFactory.resolve(
        session.activeMode,
      );
      appBarViewModel = modeStrategy.buildViewModel(session: session);
    });
    ref.listen<AsyncValue<StudySessionData>>(
      studySessionControllerProvider(request),
      (
        AsyncValue<StudySessionData>? previous,
        AsyncValue<StudySessionData> next,
      ) {
        next.whenData((StudySessionData session) {
          ref
              .read(
                studyMatchSelectionControllerProvider(
                  session.sessionId,
                ).notifier,
              )
              .syncPairs(session.currentItem.matchPairs);
          ref
              .read(
                studySpeechPlaybackControllerProvider(
                  session.sessionId,
                ).notifier,
              )
              .syncCurrentItem(
                flashcardId: session.currentItem.flashcardId,
                speech: session.currentItem.speech,
              );
        });
      },
    );
    return Scaffold(
      appBar: _buildAppBar(
        l10n: l10n,
        session: currentSession,
        viewModel: appBarViewModel,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.none),
        child: sessionAsync.when(
          loading: () => const Center(child: LumosLoadingIndicator()),
          error: (Object error, StackTrace stackTrace) {
            return Center(
              child: LumosErrorState(
                errorMessage: error.toString(),
                onRetry: () {
                  ref.invalidate(studySessionControllerProvider(request));
                },
              ),
            );
          },
          data: (StudySessionData session) {
            final StudyModeViewStrategy modeStrategy = modeStrategyFactory
                .resolve(session.activeMode);
            final StudyModeViewModel viewModel = modeStrategy.buildViewModel(
              session: session,
            );
            final StudyMatchSelectionState matchSelectionState = ref.watch(
              studyMatchSelectionControllerProvider(session.sessionId),
            );
            final StudySpeechPlaybackState speechPlaybackState = ref.watch(
              studySpeechPlaybackControllerProvider(session.sessionId),
            );
            return StudySessionContent(
              session: session,
              viewModel: viewModel,
              answerController: _answerController,
              matchSelectionState: matchSelectionState,
              speechPlaybackState: speechPlaybackState,
              onSubmitTypedAnswer: _submitTypedAnswer,
              onSubmitMatchedPairs: _submitMatchedPairs,
              onChoicePressed: _submitChoice,
              onSelectMatchLeft: _selectMatchLeft,
              onSelectMatchRight: _selectMatchRight,
              onActionPressed: _handleActionPressed,
              onPlaySpeech: _playSpeech,
              onReplaySpeech: _replaySpeech,
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    required AppLocalizations l10n,
    required StudySessionData? session,
    required StudyModeViewModel? viewModel,
  }) {
    if (session == null ||
        session.activeMode != StudySessionReviewContentConst.reviewMode) {
      return LumosAppBar(title: widget.deckName);
    }
    return LumosAppBar(
      title: viewModel?.modeLabel ?? widget.deckName,
      actions: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: LumosIcon(Icons.text_fields_rounded),
        ),
        LumosIconButton(
          icon: Icons.volume_up_rounded,
          tooltip: l10n.flashcardPlayAudioTooltip,
          onPressed: session.currentItem.speech.available ? _playSpeech : null,
        ),
        PopupMenuButton<String>(
          icon: const LumosIcon(Icons.more_vert_rounded),
          onSelected: _handleReviewMenuSelection,
          itemBuilder: (BuildContext context) {
            final List<PopupMenuEntry<String>> items =
                <PopupMenuEntry<String>>[];
            if (session.currentItem.speech.available) {
              items.add(
                PopupMenuItem<String>(
                  value: _reviewMenuReplayAudio,
                  child: LumosText(
                    l10n.studySpeechReplayAction,
                    style: LumosTextStyle.bodyMedium,
                  ),
                ),
              );
            }
            return items;
          },
        ),
      ],
    );
  }

  Future<void> _submitTypedAnswer() async {
    await ref
        .read(studySessionControllerProvider(_request).notifier)
        .submitAnswer(_answerController.text);
  }

  Future<void> _submitChoice(String answer) async {
    await ref
        .read(studySessionControllerProvider(_request).notifier)
        .submitAnswer(answer);
  }

  Future<void> _submitMatchedPairs() async {
    final StudySessionData session = _readCurrentSession();
    final StudyMatchSelectionState selectionState = ref.read(
      studyMatchSelectionControllerProvider(session.sessionId),
    );
    await ref
        .read(studySessionControllerProvider(_request).notifier)
        .submitMatchedPairs(selectionState.matchedPairs);
  }

  Future<void> _handleActionPressed(String actionId) async {
    final StudySessionController notifier = ref.read(
      studySessionControllerProvider(_request).notifier,
    );
    switch (actionId) {
      case 'REVEAL_ANSWER':
        await notifier.revealAnswer();
        return;
      case 'MARK_REMEMBERED':
        await notifier.markRemembered();
        return;
      case 'RETRY_ITEM':
        await notifier.retryItem();
        return;
      case 'GO_NEXT':
        _answerController.clear();
        await notifier.goNext();
        return;
    }
    throw UnsupportedError('Unsupported study action: $actionId');
  }

  void _selectMatchLeft(String leftId) {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(studyMatchSelectionControllerProvider(session.sessionId).notifier)
        .selectLeft(leftId);
  }

  void _selectMatchRight(String rightId) {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(studyMatchSelectionControllerProvider(session.sessionId).notifier)
        .selectRight(rightId);
  }

  Future<void> _playSpeech() async {
    final StudySessionData session = _readCurrentSession();
    await ref
        .read(studySpeechPlaybackControllerProvider(session.sessionId).notifier)
        .play(
          flashcardId: session.currentItem.flashcardId,
          speech: session.currentItem.speech,
        );
  }

  Future<void> _replaySpeech() async {
    final StudySessionData session = _readCurrentSession();
    await ref
        .read(studySpeechPlaybackControllerProvider(session.sessionId).notifier)
        .stop();
    await ref
        .read(studySpeechPlaybackControllerProvider(session.sessionId).notifier)
        .play(
          flashcardId: session.currentItem.flashcardId,
          speech: session.currentItem.speech,
        );
  }

  void _handleReviewMenuSelection(String actionId) {
    if (actionId == _reviewMenuReplayAudio) {
      _replaySpeech();
      return;
    }
    _handleActionPressed(actionId);
  }

  StudySessionData _readCurrentSession() {
    final AsyncValue<StudySessionData> sessionState = ref.read(
      studySessionControllerProvider(_request),
    );
    return sessionState.when(
      data: (StudySessionData session) => session,
      error: (Object error, StackTrace stackTrace) {
        throw StateError('Study session is unavailable: $error');
      },
      loading: () {
        throw StateError('Study session is still loading.');
      },
    );
  }

  StudySessionLaunchRequest get _request {
    return StudySessionLaunchRequest(
      deckId: widget.deckId,
      sessionId: widget.sessionId,
    );
  }
}
