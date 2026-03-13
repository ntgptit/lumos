import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../mode/study_mode_view_model.dart';
import '../mode/study_mode_view_strategy.dart';
import '../providers/study_mode_view_strategy_factory_provider.dart';
import '../providers/study_session_provider.dart';
import 'widgets/blocks/study_session_content.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
  const StudySessionScreen({
    required this.deckId,
    required this.deckName,
    super.key,
  });

  final int deckId;
  final String deckName;

  @override
  ConsumerState<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<StudySessionData> sessionAsync = ref.watch(
      studySessionControllerProvider(widget.deckId),
    );
    final modeStrategyFactory = ref.watch(studyModeViewStrategyFactoryProvider);
    return Scaffold(
      appBar: LumosAppBar(title: widget.deckName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.none),
        child: sessionAsync.when(
          loading: () => const Center(child: LumosLoadingIndicator()),
          error: (Object error, StackTrace stackTrace) {
            return Center(
              child: LumosErrorState(
                errorMessage: error.toString(),
                onRetry: () {
                  ref.invalidate(studySessionControllerProvider(widget.deckId));
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
            return StudySessionContent(
              session: session,
              viewModel: viewModel,
              answerController: _answerController,
              onSubmitTypedAnswer: _submitTypedAnswer,
              onChoicePressed: _submitChoice,
              onActionPressed: _handleActionPressed,
            );
          },
        ),
      ),
    );
  }

  Future<void> _submitTypedAnswer() async {
    await ref
        .read(studySessionControllerProvider(widget.deckId).notifier)
        .submitAnswer(_answerController.text);
  }

  Future<void> _submitChoice(String answer) async {
    await ref
        .read(studySessionControllerProvider(widget.deckId).notifier)
        .submitAnswer(answer);
  }

  Future<void> _handleActionPressed(String actionId) async {
    final StudySessionController notifier = ref.read(
      studySessionControllerProvider(widget.deckId).notifier,
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
}
