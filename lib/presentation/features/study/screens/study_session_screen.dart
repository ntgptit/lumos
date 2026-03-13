import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../mode/study_mode_view_model.dart';
import '../mode/study_mode_view_strategy.dart';
import '../mode/study_mode_view_strategy_factory.dart';
import '../providers/study_match_selection_provider.dart';
import '../providers/study_speech_playback_provider.dart';
import '../providers/study_mode_view_strategy_factory_provider.dart';
import '../providers/study_session_provider.dart';
import 'widgets/blocks/study_session_screen_app_bar.dart';
import 'widgets/blocks/study_session_screen_body.dart';

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
  final TextEditingController _answerController = TextEditingController();
  StudySessionData? _lastResolvedSession;
  bool _isCompletingMatchMode = false;

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
    final StudyModeViewStrategyFactory modeStrategyFactory = ref.watch(
      studyModeViewStrategyFactoryProvider,
    );
    StudySessionData? currentSession;
    sessionAsync.when(
      data: (StudySessionData session) {
        currentSession = session;
        _lastResolvedSession = session;
      },
      error: (Object error, StackTrace stackTrace) {
        currentSession = null;
      },
      loading: () {
        currentSession = _lastResolvedSession;
      },
    );
    final StudyModeViewModel? appBarViewModel = _buildModeViewModel(
      session: currentSession,
      modeStrategyFactory: modeStrategyFactory,
    );
    _listenSessionUpdates(request);
    return Scaffold(
      appBar: StudySessionScreenAppBar(
        deckName: widget.deckName,
        session: currentSession,
        viewModel: appBarViewModel,
        onPlaySpeech: _playSpeech,
        onStudyMenuSelected: _handleStudyMenuSelection,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.none),
        child: StudySessionScreenBody(
          request: request,
          sessionAsync: sessionAsync,
          cachedSession: currentSession,
          modeStrategyFactory: modeStrategyFactory,
          answerController: _answerController,
          onSubmitTypedAnswer: _submitTypedAnswer,
          onChoicePressed: _submitChoice,
          onSelectMatchLeft: _selectMatchLeft,
          onSelectMatchRight: _selectMatchRight,
          onActionPressed: _handleActionPressed,
          onPlaySpeech: _playSpeech,
          onReplaySpeech: _replaySpeech,
        ),
      ),
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
      case StudySessionScreenAppBarConst.resetCurrentModeActionId:
        _answerController.clear();
        await notifier.resetCurrentMode();
        return;
    }
    throw UnsupportedError('Unsupported study action: $actionId');
  }

  void _selectMatchLeft(String leftId) {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(studyMatchSelectionControllerProvider(session.sessionId).notifier)
        .selectLeft(leftId);
    unawaited(_maybeCompleteMatchMode(session.sessionId));
  }

  void _selectMatchRight(String rightId) {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(studyMatchSelectionControllerProvider(session.sessionId).notifier)
        .selectRight(rightId);
    unawaited(_maybeCompleteMatchMode(session.sessionId));
  }

  Future<void> _maybeCompleteMatchMode(int sessionId) async {
    if (_isCompletingMatchMode) {
      return;
    }
    final StudyMatchSelectionState selectionState = ref.read(
      studyMatchSelectionControllerProvider(sessionId),
    );
    if (!selectionState.canSubmit) {
      return;
    }
    _isCompletingMatchMode = true;
    try {
      await _submitMatchedPairs();
      final StudySessionData updatedSession = _readCurrentSession();
      if (!updatedSession.allowedActions.contains('GO_NEXT')) {
        return;
      }
      await ref
          .read(studySessionControllerProvider(_request).notifier)
          .goNext();
    } finally {
      _isCompletingMatchMode = false;
    }
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

  void _handleStudyMenuSelection(String actionId) {
    if (actionId == StudySessionScreenAppBarConst.reviewMenuReplayAudio) {
      _replaySpeech();
      return;
    }
    if (actionId == StudySessionScreenAppBarConst.resetCurrentModeActionId) {
      _showResetCurrentModeDialog();
      return;
    }
    _handleActionPressed(actionId);
  }

  void _listenSessionUpdates(StudySessionLaunchRequest request) {
    ref.listen<AsyncValue<StudySessionData>>(
      studySessionControllerProvider(request),
      (
        AsyncValue<StudySessionData>? previous,
        AsyncValue<StudySessionData> next,
      ) {
        next.whenData((StudySessionData session) {
          _lastResolvedSession = session;
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

  StudyModeViewModel? _buildModeViewModel({
    required StudySessionData? session,
    required StudyModeViewStrategyFactory modeStrategyFactory,
  }) {
    final StudySessionData? resolvedSession = session;
    if (resolvedSession == null) {
      return null;
    }
    final StudyModeViewStrategy modeStrategy = modeStrategyFactory.resolve(
      resolvedSession.activeMode,
    );
    return modeStrategy.buildViewModel(session: resolvedSession);
  }

  Future<void> _showResetCurrentModeDialog() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return LumosDialog(
          title: l10n.studyResetCurrentModeTitle,
          content: l10n.studyResetCurrentModeMessage,
          cancelText: l10n.commonCancel,
          confirmText: l10n.studyResetCurrentModeConfirm,
          onCancel: () {
            dialogContext.pop();
          },
          onConfirm: () {
            dialogContext.pop();
            _handleActionPressed(
              StudySessionScreenAppBarConst.resetCurrentModeActionId,
            );
          },
        );
      },
    );
  }
}
