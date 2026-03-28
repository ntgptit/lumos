import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../mode/study_mode_view_model.dart';
import '../mode/study_mode_view_strategy.dart';
import '../mode/study_mode_view_strategy_factory.dart';
import '../providers/study_fill_selection_provider.dart';
import '../providers/study_guess_selection_provider.dart';
import '../providers/study_match_selection_provider.dart';
import '../providers/study_recall_selection_provider.dart';
import '../providers/study_speech_playback_provider.dart';
import '../providers/study_mode_view_strategy_factory_provider.dart';
import '../providers/study_session_provider.dart';
import 'widgets/blocks/study_session_screen_app_bar.dart';
import 'widgets/blocks/study_session_screen_body.dart';
import 'widgets/sub_mode/study_session_sub_mode_const.dart';

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
  bool _isCompletingGuessMode = false;
  bool _isCompletingMatchMode = false;
  bool _isCompletingRecallMode = false;
  bool _isRevealingRecallMode = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool compactPhone =
        context.deviceType == DeviceType.mobile && context.screenHeight < 780;
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
    _listenGuessSelectionUpdates(currentSession?.sessionId);
    _listenMatchSelectionUpdates(currentSession?.sessionId);
    _listenRecallSelectionUpdates(currentSession?.sessionId);
    return Scaffold(
      appBar: StudySessionScreenAppBar(
        deckName: widget.deckName,
        session: currentSession,
        viewModel: appBarViewModel,
        onPlaySpeech: _playSpeech,
        onStudyMenuSelected: _handleStudyMenuSelection,
      ),
      body: SafeArea(
        top: false,
        bottom: !compactPhone,
        child: StudySessionScreenBody(
          request: request,
          sessionAsync: sessionAsync,
          cachedSession: currentSession,
          modeStrategyFactory: modeStrategyFactory,
          answerController: _answerController,
          onSubmitTypedAnswer: _submitTypedAnswer,
          onChoicePressed: _selectGuessChoice,
          onSelectMatchLeft: _selectMatchLeft,
          onSelectMatchRight: _selectMatchRight,
          onActionPressed: _handleActionPressed,
          onFillInputChanged: _handleFillInputChanged,
          onRetryInputPressed: _retryFillInput,
          onPlaySpeech: _playSpeech,
          onReplaySpeech: _replaySpeech,
        ),
      ),
    );
  }

  Future<void> _submitTypedAnswer() async {
    final StudySessionData session = _readCurrentSession();
    if (session.activeMode != StudySessionSubModeConst.fillMode) {
      final String submittedAnswer = _answerController.text;
      await ref
          .read(studySessionControllerProvider(_request).notifier)
          .submitAnswer(submittedAnswer);
      return;
    }
    final StudyFillSelectionController fillSelectionController = ref.read(
      studyFillSelectionControllerProvider(session.sessionId).notifier,
    );
    final String submittedAnswer = StringUtils.normalizeName(
      _answerController.text,
    );
    if (submittedAnswer.isEmpty) {
      fillSelectionController.showRequiredInputError();
      return;
    }
    fillSelectionController.clearRequiredInputError();
    final bool isCorrectSubmission = fillSelectionController.evaluateSubmission(
      submittedAnswer: submittedAnswer,
      expectedAnswer: session.currentItem.prompt,
    );
    final StudySessionController sessionController = ref.read(
      studySessionControllerProvider(_request).notifier,
    );
    try {
      final StudySessionData updatedSession = await sessionController
          .submitAnswer(submittedAnswer);
      if (!isCorrectSubmission) {
        return;
      }
      if (!updatedSession.allowedActions.contains('GO_NEXT')) {
        return;
      }
      await sessionController.goNext();
      _answerController.clear();
    } catch (_) {
      fillSelectionController.resetResult();
      rethrow;
    }
  }

  void _retryFillInput() {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(studyFillSelectionControllerProvider(session.sessionId).notifier)
        .startRetryInput();
    _answerController.clear();
  }

  void _handleFillInputChanged(String value) {
    final AsyncValue<StudySessionData> sessionState = ref.read(
      studySessionControllerProvider(_request),
    );
    final StudySessionData? session = sessionState.asData?.value;
    if (session == null) {
      return;
    }
    ref
        .read(studyFillSelectionControllerProvider(session.sessionId).notifier)
        .clearRequiredInputError();
  }

  void _selectGuessChoice(String answer) {
    final StudySessionData session = _readCurrentSession();
    final bool isCorrect = answer == session.currentItem.answer;
    ref
        .read(studyGuessSelectionControllerProvider(session.sessionId).notifier)
        .selectChoice(choiceLabel: answer, isCorrect: isCorrect);
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
    if (_shouldHandleRecallRevealLocally(actionId)) {
      _queueRecallReveal();
      return;
    }
    if (_shouldHandleRecallFeedbackLocally(actionId)) {
      _queueRecallAction(actionId);
      return;
    }
    final StudySessionController notifier = ref.read(
      studySessionControllerProvider(_request).notifier,
    );
    final StudySessionData session = _readCurrentSession();
    switch (actionId) {
      case 'REVEAL_ANSWER':
        if (session.activeMode == StudySessionSubModeConst.fillMode) {
          ref
              .read(
                studyFillSelectionControllerProvider(
                  session.sessionId,
                ).notifier,
              )
              .markRevealAsIncorrect(
                submittedAnswer: _answerController.text,
                expectedAnswer: session.currentItem.prompt,
              );
        }
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
        final AsyncValue<StudySessionData> updatedSessionState = ref.read(
          studySessionControllerProvider(_request),
        );
        final StudySessionData? updatedSession =
            updatedSessionState.asData?.value;
        if (updatedSession != null) {
          ref
              .read(
                studyFillSelectionControllerProvider(
                  updatedSession.sessionId,
                ).notifier,
              )
              .resetResult();
        }
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

  Future<void> _maybeCompleteGuessMode(int sessionId) async {
    if (_isCompletingGuessMode) {
      return;
    }
    final StudyGuessSelectionState selectionState = ref.read(
      studyGuessSelectionControllerProvider(sessionId),
    );
    if (!selectionState.canSubmit) {
      return;
    }
    final String submittedAnswer = selectionState.pendingSubmittedAnswer!;
    _isCompletingGuessMode = true;
    try {
      await ref
          .read(studySessionControllerProvider(_request).notifier)
          .submitAnswer(submittedAnswer);
      final StudySessionData updatedSession = _readCurrentSession();
      if (!updatedSession.allowedActions.contains('GO_NEXT')) {
        ref
            .read(studyGuessSelectionControllerProvider(sessionId).notifier)
            .reset();
        return;
      }
      _answerController.clear();
      await ref
          .read(studySessionControllerProvider(_request).notifier)
          .goNext();
    } catch (_) {
      ref
          .read(studyGuessSelectionControllerProvider(sessionId).notifier)
          .reset();
      rethrow;
    } finally {
      _isCompletingGuessMode = false;
    }
  }

  Future<void> _maybeCompleteRecallMode(int sessionId) async {
    if (_isCompletingRecallMode) {
      return;
    }
    final StudyRecallSelectionState selectionState = ref.read(
      studyRecallSelectionControllerProvider(sessionId),
    );
    if (!selectionState.canSubmit) {
      return;
    }
    final String actionId = selectionState.pendingSubmittedActionId!;
    _isCompletingRecallMode = true;
    try {
      final StudySessionController notifier = ref.read(
        studySessionControllerProvider(_request).notifier,
      );
      if (actionId == StudyRecallSelectionController.rememberedActionId) {
        await notifier.markRemembered();
      }
      if (actionId == StudyRecallSelectionController.retryActionId) {
        await notifier.retryItem();
      }
      final StudySessionData updatedSession = _readCurrentSession();
      if (!updatedSession.allowedActions.contains('GO_NEXT')) {
        ref
            .read(studyRecallSelectionControllerProvider(sessionId).notifier)
            .reset();
        return;
      }
      _answerController.clear();
      await notifier.goNext();
    } catch (_) {
      ref
          .read(studyRecallSelectionControllerProvider(sessionId).notifier)
          .reset();
      rethrow;
    } finally {
      _isCompletingRecallMode = false;
    }
  }

  Future<void> _maybeRevealRecallMode(int sessionId) async {
    if (_isRevealingRecallMode) {
      return;
    }
    final StudyRecallSelectionState selectionState = ref.read(
      studyRecallSelectionControllerProvider(sessionId),
    );
    if (!selectionState.hasPendingReveal) {
      return;
    }
    _isRevealingRecallMode = true;
    try {
      await ref
          .read(studySessionControllerProvider(_request).notifier)
          .revealAnswer();
    } catch (_) {
      ref
          .read(studyRecallSelectionControllerProvider(sessionId).notifier)
          .restartRevealCountdown();
      rethrow;
    } finally {
      _isRevealingRecallMode = false;
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
    ref.listen<
      AsyncValue<StudySessionData>
    >(studySessionControllerProvider(request), (
      AsyncValue<StudySessionData>? previous,
      AsyncValue<StudySessionData> next,
    ) {
      next.whenData((StudySessionData session) {
        _lastResolvedSession = session;
        ref
            .read(
              studyFillSelectionControllerProvider(session.sessionId).notifier,
            )
            .syncCurrentItem(
              itemKey:
                  '${session.activeMode}:${session.currentItem.flashcardId}',
            );
        ref
            .read(
              studyGuessSelectionControllerProvider(session.sessionId).notifier,
            )
            .syncCurrentItem(
              itemKey:
                  '${session.activeMode}:${session.currentItem.flashcardId}',
            );
        ref
            .read(
              studyMatchSelectionControllerProvider(session.sessionId).notifier,
            )
            .syncPairs(session.currentItem.matchPairs);
        ref
            .read(
              studyRecallSelectionControllerProvider(
                session.sessionId,
              ).notifier,
            )
            .syncCurrentItem(
              itemKey:
                  '${session.activeMode}:${session.currentItem.flashcardId}',
              shouldStartRevealCountdown:
                  session.activeMode == 'RECALL' &&
                  session.allowedActions.contains(
                    StudyRecallSelectionController.revealActionId,
                  ),
            );
        ref
            .read(
              studySpeechPlaybackControllerProvider(session.sessionId).notifier,
            )
            .syncCurrentItem(
              flashcardId: session.currentItem.flashcardId,
              speech: session.currentItem.speech,
            );
      });
    });
  }

  void _listenGuessSelectionUpdates(int? sessionId) {
    final int? resolvedSessionId = sessionId;
    if (resolvedSessionId == null) {
      return;
    }
    ref.listen<StudyGuessSelectionState>(
      studyGuessSelectionControllerProvider(resolvedSessionId),
      (StudyGuessSelectionState? previous, StudyGuessSelectionState next) {
        if (previous?.canSubmit == true) {
          return;
        }
        if (!next.canSubmit) {
          return;
        }
        unawaited(_maybeCompleteGuessMode(resolvedSessionId));
      },
    );
  }

  void _listenMatchSelectionUpdates(int? sessionId) {
    final int? resolvedSessionId = sessionId;
    if (resolvedSessionId == null) {
      return;
    }
    ref.listen<StudyMatchSelectionState>(
      studyMatchSelectionControllerProvider(resolvedSessionId),
      (StudyMatchSelectionState? previous, StudyMatchSelectionState next) {
        if (previous?.canSubmit == true) {
          return;
        }
        if (!next.canSubmit) {
          return;
        }
        unawaited(_maybeCompleteMatchMode(resolvedSessionId));
      },
    );
  }

  void _listenRecallSelectionUpdates(int? sessionId) {
    final int? resolvedSessionId = sessionId;
    if (resolvedSessionId == null) {
      return;
    }
    ref.listen<StudyRecallSelectionState>(
      studyRecallSelectionControllerProvider(resolvedSessionId),
      (StudyRecallSelectionState? previous, StudyRecallSelectionState next) {
        if (previous?.hasPendingReveal != true && next.hasPendingReveal) {
          unawaited(_maybeRevealRecallMode(resolvedSessionId));
        }
        if (previous?.canSubmit == true) {
          return;
        }
        if (!next.canSubmit) {
          return;
        }
        unawaited(_maybeCompleteRecallMode(resolvedSessionId));
      },
    );
  }

  bool _shouldHandleRecallActionLocally(String actionId) {
    final AsyncValue<StudySessionData> sessionState = ref.read(
      studySessionControllerProvider(_request),
    );
    final StudySessionData? session = sessionState.asData?.value;
    if (session == null) {
      return false;
    }
    if (session.activeMode != 'RECALL') {
      return false;
    }
    return actionId == StudyRecallSelectionController.revealActionId ||
        actionId == StudyRecallSelectionController.rememberedActionId ||
        actionId == StudyRecallSelectionController.retryActionId;
  }

  bool _shouldHandleRecallRevealLocally(String actionId) {
    return _shouldHandleRecallActionLocally(actionId) &&
        actionId == StudyRecallSelectionController.revealActionId;
  }

  bool _shouldHandleRecallFeedbackLocally(String actionId) {
    return _shouldHandleRecallActionLocally(actionId) &&
        actionId != StudyRecallSelectionController.revealActionId;
  }

  void _queueRecallAction(String actionId) {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(
          studyRecallSelectionControllerProvider(session.sessionId).notifier,
        )
        .selectAction(actionId: actionId);
  }

  void _queueRecallReveal() {
    final StudySessionData session = _readCurrentSession();
    ref
        .read(
          studyRecallSelectionControllerProvider(session.sessionId).notifier,
        )
        .queueManualReveal();
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

