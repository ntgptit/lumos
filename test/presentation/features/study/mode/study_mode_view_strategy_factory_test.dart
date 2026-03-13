import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/mode/fill_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/guess_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/match_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/recall_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/review_study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_view_strategy.dart';
import 'package:lumos/presentation/features/study/mode/study_mode_view_strategy_factory.dart';

void main() {
  const StudyModeViewStrategyFactory factory = StudyModeViewStrategyFactory(
    strategies: <StudyModeViewStrategy>[
      ReviewStudyModeViewStrategy(),
      MatchStudyModeViewStrategy(),
      GuessStudyModeViewStrategy(),
      RecallStudyModeViewStrategy(),
      FillStudyModeViewStrategy(),
    ],
  );

  group('StudyModeViewStrategyFactory', () {
    test('review strategy builds reveal-driven actions in configured order', () {
      final session = _buildSession(
        activeMode: 'REVIEW',
        allowedActions: const <String>[
          'REVEAL_ANSWER',
          'MARK_REMEMBERED',
          'RETRY_ITEM',
        ],
      );

      final viewModel = factory.resolve(session.activeMode).buildViewModel(
            session: session,
          );

      expect(
        viewModel.actions.map((action) => action.actionId).toList(),
        const <String>[
          'REVEAL_ANSWER',
          'MARK_REMEMBERED',
          'RETRY_ITEM',
        ],
      );
      expect(viewModel.showAnswerInput, isFalse);
      expect(viewModel.showAnswer, isFalse);
    });

    test('match strategy keeps choice-based interaction and hides answer input', () {
      final session = _buildSession(
        activeMode: 'MATCH',
        allowedActions: const <String>[
          'SUBMIT_ANSWER',
          'REVEAL_ANSWER',
          'RETRY_ITEM',
        ],
        choices: const <StudyChoice>[
          StudyChoice(id: 'choice-0', label: 'xin chao'),
          StudyChoice(id: 'choice-1', label: 'cam on'),
        ],
      );

      final viewModel = factory.resolve(session.activeMode).buildViewModel(
            session: session,
          );

      expect(viewModel.choices, hasLength(2));
      expect(viewModel.showAnswerInput, isFalse);
      expect(
        viewModel.actions.map((action) => action.actionId).toList(),
        const <String>['REVEAL_ANSWER', 'RETRY_ITEM'],
      );
    });

    test('fill strategy enables answer input when submit is allowed', () {
      final session = _buildSession(
        activeMode: 'FILL',
        allowedActions: const <String>[
          'SUBMIT_ANSWER',
          'REVEAL_ANSWER',
          'RETRY_ITEM',
          'GO_NEXT',
        ],
        inputPlaceholder: 'Type your answer',
      );

      final viewModel = factory.resolve(session.activeMode).buildViewModel(
            session: session,
          );

      expect(viewModel.showAnswerInput, isTrue);
      expect(viewModel.inputLabel, 'Type your answer');
      expect(
        viewModel.actions.map((action) => action.actionId).toList(),
        const <String>['REVEAL_ANSWER', 'RETRY_ITEM', 'GO_NEXT'],
      );
    });
  });
}

StudySessionData _buildSession({
  required String activeMode,
  required List<String> allowedActions,
  List<StudyChoice> choices = const <StudyChoice>[],
  String inputPlaceholder = '',
}) {
  return StudySessionData(
    sessionId: 33,
    deckId: 10,
    deckName: 'Korean Basics',
    sessionType: 'FIRST_LEARNING',
    activeMode: activeMode,
    modeState: 'IN_PROGRESS',
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
    currentItem: StudySessionItemData(
      flashcardId: 101,
      prompt: '안녕하세요',
      answer: 'xin chao',
      note: 'note',
      pronunciation: 'annyeonghaseyo',
      instruction: 'Study instruction',
      inputPlaceholder: inputPlaceholder,
      choices: choices,
      speech: const SpeechCapability(
        enabled: true,
        autoPlay: false,
        available: true,
        locale: 'ko-KR',
        voice: 'ko-KR-neutral',
        speed: 1,
        speechText: '안녕하세요',
      ),
    ),
    sessionCompleted: false,
  );
}
