import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
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
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight =
            constraints.maxHeight < StudySessionLayoutMetrics.compactPanelHeightBreakpoint;
        final double errorFieldPadding =
            StudySessionLayoutMetrics.actionSpacing(
              context,
              baseValue: compactHeight
                  ? context.spacing.xxl
                  : context.spacing.xxxl,
            );
        final EdgeInsets
        errorBannerPadding = StudySessionLayoutMetrics.cardPadding(
          context,
          horizontal: compactHeight
              ? context.spacing.md
              : context.spacing.lg,
          vertical:
              context.spacing.sm,
        );
        final double horizontalInset = context.compactValue(
          baseValue: compactHeight
              ? context.spacing.md
              : context.spacing.lg,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        final double bottomInset = context.compactValue(
          baseValue: compactHeight
              ? context.spacing.md
              : context.spacing.lg,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        return LumosCard(
          margin: EdgeInsets.zero,
          variant: LumosCardVariant.filled,
          borderRadius: context.shapes.hero,
          padding: EdgeInsets.zero,
          child: SizedBox.expand(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: AnimatedPadding(
                    duration: AppMotion.fast,
                    curve: Curves.easeOut,
                    padding: showsRequiredInputError
                        ? EdgeInsets.only(bottom: errorFieldPadding)
                        : EdgeInsets.zero,
                    child: Theme(
                      data: theme.copyWith(
                        inputDecorationTheme:
                            StudySessionFillPanelStyle.termInputDecorationTheme,
                      ),
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
                        onChanged: onChanged,
                        onSubmitted: (_) {
                          onSubmit();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: horizontalInset,
                  right: horizontalInset,
                  bottom: bottomInset,
                  child: IgnorePointer(
                    child: AnimatedSwitcher(
                      duration: AppMotion.fast,
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: showsRequiredInputError
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: errorBannerPadding,
                                decoration: BoxDecoration(
                                  color: colorScheme.errorContainer,
                                  borderRadius: context.shapes.pill,
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
                                      child: LumosIcon(
                                        Icons.error_outline_rounded,
                                        size: context.iconSize.sm,
                                      ),
                                    ),
                                    SizedBox(
                                      width: context.spacing.sm,
                                    ),
                                    Flexible(
                                      child: LumosText(
                                        l10n.studyFillAnswerRequiredValidation,
                                        style: LumosTextStyle.bodySmall,
                                        containerRole: LumosTextContainerRole
                                            .errorContainer,
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
      },
    );
  }
}
