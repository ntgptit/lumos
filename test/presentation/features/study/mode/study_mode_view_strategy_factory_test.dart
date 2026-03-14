import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/entities/study/study_speech_contract.dart';
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
    test(
      'review strategy builds self-assessment actions in configured order',
      () {
        final session = _buildSession(
          activeMode: 'REVIEW',
          allowedActions: const <String>['MARK_REMEMBERED', 'RETRY_ITEM'],
        );

        final viewModel = factory
            .resolve(session.activeMode)
            .buildViewModel(session: session);

        expect(
          viewModel.actions.map((action) => action.actionId).toList(),
          const <String>['MARK_REMEMBERED', 'RETRY_ITEM'],
        );
        expect(viewModel.showAnswerInput, isFalse);
        expect(viewModel.showAnswer, isTrue);
      },
    );

    test(
      'match strategy keeps pair interaction and does not expose footer actions',
      () {
        final session = _buildSession(
          activeMode: 'MATCH',
          allowedActions: const <String>['GO_NEXT'],
          matchPairs: const <StudyMatchPair>[
            StudyMatchPair(
              leftId: 'left-101',
              leftLabel: '안녕하세요',
              rightId: 'right-101',
              rightLabel: 'xin chao',
            ),
          ],
        );

        final viewModel = factory
            .resolve(session.activeMode)
            .buildViewModel(session: session);

        expect(viewModel.matchPairs, hasLength(1));
        expect(viewModel.showAnswerInput, isFalse);
        expect(viewModel.actions, isEmpty);
      },
    );

    test(
      'guess strategy keeps choice interaction and does not expose continue action',
      () {
        final session = _buildSession(
          activeMode: 'GUESS',
          allowedActions: const <String>['SUBMIT_ANSWER', 'GO_NEXT'],
          choices: const <StudyChoice>[
            StudyChoice(id: 'choice-0', label: 'xin chao'),
            StudyChoice(id: 'choice-1', label: 'cam on'),
          ],
        );

        final viewModel = factory
            .resolve(session.activeMode)
            .buildViewModel(session: session);

        expect(viewModel.choices, hasLength(2));
        expect(viewModel.showAnswerInput, isFalse);
        expect(viewModel.actions, isEmpty);
      },
    );

    test('fill strategy enables answer input when submit is allowed', () {
      final session = _buildSession(
        activeMode: 'FILL',
        allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
        inputPlaceholder: 'Type your answer',
      );

      final viewModel = factory
          .resolve(session.activeMode)
          .buildViewModel(session: session);

      expect(viewModel.showAnswerInput, isTrue);
      expect(viewModel.prompt, 'xin chao');
      expect(viewModel.answer, '안녕하세요');
      expect(viewModel.inputLabel, 'Type your answer');
      expect(viewModel.submitLabel, 'Kiểm tra');
      expect(
        viewModel.actions.map((action) => action.actionId).toList(),
        const <String>['REVEAL_ANSWER'],
      );
    });

    test('fill strategy keeps retry input available after failed feedback', () {
      final session = _buildSession(
        activeMode: 'FILL',
        modeState: 'WAITING_FEEDBACK',
        allowedActions: const <String>['SUBMIT_ANSWER', 'REVEAL_ANSWER'],
      );

      final viewModel = factory
          .resolve(session.activeMode)
          .buildViewModel(session: session);

      expect(viewModel.showAnswer, isTrue);
      expect(viewModel.showAnswerInput, isTrue);
      expect(
        viewModel.actions.map((action) => action.actionId).toList(),
        const <String>['REVEAL_ANSWER'],
      );
    });

    test('recall strategy exposes next action for timeout branch', () {
      final session = _buildSession(
        activeMode: 'RECALL',
        allowedActions: const <String>[
          'REVEAL_ANSWER',
          'MARK_REMEMBERED',
          'RETRY_ITEM',
          'GO_NEXT',
        ],
      );

      final viewModel = factory
          .resolve(session.activeMode)
          .buildViewModel(session: session);

      expect(
        viewModel.actions.map((action) => action.actionId).toList(),
        const <String>[
          'REVEAL_ANSWER',
          'MARK_REMEMBERED',
          'RETRY_ITEM',
          'GO_NEXT',
        ],
      );
    });
  });
}

StudySessionData _buildSession({
  required String activeMode,
  required List<String> allowedActions,
  String modeState = 'IN_PROGRESS',
  List<StudyChoice> choices = const <StudyChoice>[],
  List<StudyMatchPair> matchPairs = const <StudyMatchPair>[],
  String inputPlaceholder = '',
}) {
  return StudySessionData(
    sessionId: 33,
    deckId: 10,
    deckName: 'Korean Basics',
    sessionType: 'FIRST_LEARNING',
    activeMode: activeMode,
    modeState: modeState,
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
      matchPairs: matchPairs,
      speech: const SpeechCapability(
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
        speechText: '안녕하세요',
      ),
    ),
    sessionCompleted: false,
  );
}
