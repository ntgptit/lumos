import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/study_session_provider.dart';

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
    final AsyncValue<dynamic> sessionAsync = ref.watch(
      studySessionControllerProvider(widget.deckId),
    );
    return Scaffold(
      appBar: LumosAppBar(title: widget.deckName),
      body: sessionAsync.when(
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
        data: (dynamic rawSession) {
          final session = rawSession;
          final currentItem = session.currentItem;
          final bool showAnswer = session.modeState == 'WAITING_FEEDBACK';
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: <Widget>[
              LumosText(
                '${session.sessionType} · ${session.activeMode}',
                style: LumosTextStyle.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              LumosProgressBar(value: session.progress.sessionProgress),
              const SizedBox(height: AppSpacing.lg),
              LumosCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LumosText(
                        currentItem.instruction,
                        style: LumosTextStyle.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LumosText(
                        currentItem.prompt,
                        style: LumosTextStyle.headlineSmall,
                        align: TextAlign.center,
                      ),
                      if (showAnswer) ...<Widget>[
                        const SizedBox(height: AppSpacing.lg),
                        LumosText(
                          currentItem.answer,
                          style: LumosTextStyle.titleLarge,
                          align: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._buildChoiceButtons(currentItem: currentItem),
              ..._buildAnswerInput(session: session, currentItem: currentItem),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: <Widget>[
                  if (session.allowedActions.contains('REVEAL_ANSWER'))
                    LumosSecondaryButton(
                      onPressed: () async {
                        await ref
                            .read(studySessionControllerProvider(widget.deckId).notifier)
                            .revealAnswer();
                      },
                      label: 'Reveal',
                    ),
                  if (session.allowedActions.contains('MARK_REMEMBERED'))
                    LumosSecondaryButton(
                      onPressed: () async {
                        await ref
                            .read(studySessionControllerProvider(widget.deckId).notifier)
                            .markRemembered();
                      },
                      label: 'Remembered',
                    ),
                  if (session.allowedActions.contains('RETRY_ITEM'))
                    LumosOutlineButton(
                      onPressed: () async {
                        await ref
                            .read(studySessionControllerProvider(widget.deckId).notifier)
                            .retryItem();
                      },
                      label: 'Retry later',
                    ),
                  if (session.allowedActions.contains('GO_NEXT'))
                    LumosPrimaryButton(
                      onPressed: () async {
                        _answerController.clear();
                        await ref
                            .read(studySessionControllerProvider(widget.deckId).notifier)
                            .goNext();
                      },
                      label: session.sessionCompleted ? 'Done' : 'Next',
                      icon: Icons.navigate_next_rounded,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildAnswerInput({
    required dynamic session,
    required dynamic currentItem,
  }) {
    if (currentItem.choices.isNotEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      LumosTextField(
        controller: _answerController,
        label: currentItem.inputPlaceholder.isEmpty
            ? 'Answer'
            : currentItem.inputPlaceholder,
      ),
      const SizedBox(height: AppSpacing.md),
      LumosPrimaryButton(
        onPressed: session.allowedActions.contains('SUBMIT_ANSWER')
            ? () async {
                await ref
                    .read(studySessionControllerProvider(widget.deckId).notifier)
                    .submitAnswer(_answerController.text);
              }
            : null,
        label: 'Submit answer',
        icon: Icons.check_rounded,
      ),
    ];
  }

  List<Widget> _buildChoiceButtons({required dynamic currentItem}) {
    if (currentItem.choices.isEmpty) {
      return const <Widget>[];
    }
    return currentItem.choices.map<Widget>((dynamic choice) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: LumosOutlineButton(
          onPressed: () async {
            await ref
                .read(studySessionControllerProvider(widget.deckId).notifier)
                .submitAnswer(choice.label);
          },
          label: choice.label,
        ),
      );
    }).toList(growable: false);
  }
}
