import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';
import 'package:lumos/presentation/features/study/mode/recall_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_action_button_style.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_action_view_model.dart';
import 'package:lumos/presentation/features/study/mode/study_recall_layout_resolver.dart';

void main() {
  test(
    'timeout branch creates fallback next action when backend omits GO_NEXT',
    () {
      const RecallStudyModeViewStrategy strategy =
          RecallStudyModeViewStrategy();
      final StudySessionData session = _buildSession(
        allowedActions: const <String>[
          'REVEAL_ANSWER',
          'MARK_REMEMBERED',
          'RETRY_ITEM',
        ],
      );

      final visibleActions = StudyRecallLayoutResolver.resolveVisibleActions(
        viewModel: strategy.buildViewModel(session: session),
        showsNextActionOnly: true,
        fallbackNextAction: const StudyModeActionViewModel(
          actionId: 'GO_NEXT',
          label: 'Tiếp theo',
          style: StudyModeActionButtonStyle.primary,
        ),
      );

      expect(visibleActions, hasLength(1));
      expect(visibleActions.first.actionId, 'GO_NEXT');
      expect(visibleActions.first.label, 'Tiếp theo');
    },
  );
}

StudySessionData _buildSession({required List<String> allowedActions}) {
  return StudySessionData(
    sessionId: 33,
    deckId: 10,
    deckName: 'Korean Basics',
    sessionType: 'FIRST_LEARNING',
    activeMode: 'RECALL',
    modeState: 'WAITING_FEEDBACK',
    modePlan: const <String>['REVIEW', 'MATCH', 'GUESS', 'RECALL', 'FILL'],
    allowedActions: allowedActions,
    progress: const StudyProgressSummary(
      completedItems: 1,
      totalItems: 3,
      completedModes: 0,
      totalModes: 5,
      itemProgress: 0.33,
      modeProgress: 0,
      sessionProgress: 0.06,
    ),
    currentItem: const StudySessionItemData(
      flashcardId: 101,
      prompt: '연구자',
      answer: 'Researcher',
      note: 'Nhà nghiên cứu',
      pronunciation: 'yeonguja',
      instruction: 'Study instruction',
      inputPlaceholder: '',
      choices: <StudyChoice>[],
      matchPairs: <StudyMatchPair>[],
      speech: SpeechCapability(
        enabled: true,
        autoPlay: false,
        available: true,
        adapter: studySpeechAdapterFlutterTts,
        locale: 'ko-KR',
        voice: 'ko-KR-neutral',
        speed: 1,
        pitch: 1,
        fieldName: 'prompt',
        sourceType: 'text',
        audioUrl: '',
        allowedActions: <String>['play_speech', 'replay_speech'],
        speechText: '연구자',
      ),
    ),
    sessionCompleted: false,
  );
}
