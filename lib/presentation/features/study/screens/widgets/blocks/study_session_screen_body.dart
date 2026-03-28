import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../mode/study_mode_view_strategy_factory.dart';
import '../../../providers/study_session_provider.dart';
import 'study_session_resolved_body_content.dart';

class StudySessionScreenBody extends ConsumerWidget {
  const StudySessionScreenBody({
    required this.request,
    required this.sessionAsync,
    required this.cachedSession,
    required this.modeStrategyFactory,
    required this.answerController,
    required this.onSubmitTypedAnswer,
    required this.onChoicePressed,
    required this.onSelectMatchLeft,
    required this.onSelectMatchRight,
    required this.onActionPressed,
    required this.onFillInputChanged,
    required this.onRetryInputPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionLaunchRequest request;
  final AsyncValue<StudySessionData> sessionAsync;
  final StudySessionData? cachedSession;
  final StudyModeViewStrategyFactory modeStrategyFactory;
  final TextEditingController answerController;
  final VoidCallback onSubmitTypedAnswer;
  final ValueChanged<String> onChoicePressed;
  final ValueChanged<String> onSelectMatchLeft;
  final ValueChanged<String> onSelectMatchRight;
  final Future<void> Function(String) onActionPressed;
  final ValueChanged<String> onFillInputChanged;
  final VoidCallback onRetryInputPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget resolvedBody = sessionAsync.when(
      data: (StudySessionData session) {
        return StudySessionResolvedBodyContent(
          session: session,
          modeStrategyFactory: modeStrategyFactory,
          answerController: answerController,
          onSubmitTypedAnswer: onSubmitTypedAnswer,
          onChoicePressed: onChoicePressed,
          onSelectMatchLeft: onSelectMatchLeft,
          onSelectMatchRight: onSelectMatchRight,
          onActionPressed: onActionPressed,
          onFillInputChanged: onFillInputChanged,
          onRetryInputPressed: onRetryInputPressed,
          onPlaySpeech: onPlaySpeech,
          onReplaySpeech: onReplaySpeech,
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final EdgeInsets shellPadding = ResponsiveDimensions.compactInsets(
              context: context,
              baseInsets: const EdgeInsets.all(LumosSpacing.lg),
            );
            final double maxWidth = constraints.isDesktop
                ? WidgetSizes.maxContentWidth
                : constraints.maxWidth;
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: shellPadding,
                  child: LumosErrorState(
                    errorMessage: error.toString(),
                    onRetry: () {
                      ref.invalidate(studySessionControllerProvider(request));
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () {
        final StudySessionData? resolvedSession = cachedSession;
        if (resolvedSession == null) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final EdgeInsets shellPadding =
                  ResponsiveDimensions.compactInsets(
                    context: context,
                    baseInsets: const EdgeInsets.all(LumosSpacing.lg),
                  );
              return Padding(
                padding: shellPadding,
                child: const Center(child: LumosLoadingIndicator()),
              );
            },
          );
        }
        return StudySessionResolvedBodyContent(
          session: resolvedSession,
          modeStrategyFactory: modeStrategyFactory,
          answerController: answerController,
          onSubmitTypedAnswer: onSubmitTypedAnswer,
          onChoicePressed: onChoicePressed,
          onSelectMatchLeft: onSelectMatchLeft,
          onSelectMatchRight: onSelectMatchRight,
          onActionPressed: onActionPressed,
          onFillInputChanged: onFillInputChanged,
          onRetryInputPressed: onRetryInputPressed,
          onPlaySpeech: onPlaySpeech,
          onReplaySpeech: onReplaySpeech,
        );
      },
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.isDesktop
            ? WidgetSizes.maxContentWidth
            : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: resolvedBody,
          ),
        );
      },
    );
  }
}
