import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../widgets/study_session_layout_metrics.dart';
import 'study_session_fill_panel_style.dart';

class StudySessionFillInputPanel extends StatelessWidget {
  const StudySessionFillInputPanel({
    required this.controller,
    required this.label,
    required this.showsRequiredInputError,
    required this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool showsRequiredInputError;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double errorFieldPadding = StudySessionLayoutMetrics.actionSpacing(
      context,
      baseValue: AppSpacing.xxxl,
    );
    final EdgeInsets errorBannerPadding = StudySessionLayoutMetrics.cardPadding(
      context,
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    );
    final double horizontalInset = StudySessionLayoutMetrics.sectionSpacing(
      context,
      baseValue: AppSpacing.lg,
    );
    final double bottomInset = StudySessionLayoutMetrics.sectionSpacing(
      context,
      baseValue: AppSpacing.lg,
    );
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedPadding(
                duration: AppDurations.fast,
                curve: Curves.easeOut,
                padding: showsRequiredInputError
                    ? EdgeInsets.only(bottom: errorFieldPadding)
                    : EdgeInsets.zero,
                child: LumosTextField(
                  controller: controller,
                  autofocus: true,
                  expands: true,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  textStyle: StudySessionFillPanelStyle.termTextStyle(
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                  decoration: StudySessionFillPanelStyle.termInputDecoration,
                  onChanged: onChanged,
                  onSubmitted: (_) {
                    onSubmit();
                  },
                ),
              ),
            ),
            Positioned(
              left: horizontalInset,
              right: horizontalInset,
              bottom: bottomInset,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: showsRequiredInputError
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: errorBannerPadding,
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              borderRadius: BorderRadii.pill,
                              border: Border.all(
                                color: colorScheme.error.withValues(
                                  alpha: AppOpacity.stateHover,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconTheme(
                                  data: IconThemeData(
                                    color: colorScheme.onErrorContainer,
                                  ),
                                  child: const LumosIcon(
                                    Icons.error_outline_rounded,
                                    size: IconSizes.iconSmall,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Flexible(
                                  child: LumosText(
                                    l10n.studyFillAnswerRequiredValidation,
                                    style: LumosTextStyle.bodySmall,
                                    containerRole:
                                        LumosTextContainerRole.errorContainer,
                                    align: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
