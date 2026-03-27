import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/app_score_input.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';

class AppScoreInputDialog extends StatefulWidget {
  const AppScoreInputDialog({
    super.key,
    required this.title,
    this.message,
    this.initialScore,
    this.minScore = 1,
    this.maxScore = 5,
    this.allowClear = false,
    this.confirmLabel = 'Save',
    this.cancelLabel = 'Cancel',
    this.onConfirmed,
    this.onCancelled,
    this.scoreLabelBuilder,
  });

  final String title;
  final String? message;
  final int? initialScore;
  final int minScore;
  final int maxScore;
  final bool allowClear;
  final String confirmLabel;
  final String cancelLabel;
  final ValueChanged<int?>? onConfirmed;
  final VoidCallback? onCancelled;
  final String Function(int score)? scoreLabelBuilder;

  @override
  State<AppScoreInputDialog> createState() => _AppScoreInputDialogState();
}

class _AppScoreInputDialogState extends State<AppScoreInputDialog> {
  late int? _score = widget.initialScore;

  @override
  void didUpdateWidget(covariant AppScoreInputDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialScore != widget.initialScore) {
      _score = widget.initialScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppTitleText(text: widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message != null) ...[
              AppBodyText(text: widget.message!),
              const AppSpacing(size: AppSpacingSize.sm),
            ],
            AppScoreInput(
              score: _score,
              minScore: widget.minScore,
              maxScore: widget.maxScore,
              allowClear: widget.allowClear,
              scoreLabelBuilder: widget.scoreLabelBuilder,
              onChanged: (score) {
                setState(() {
                  _score = score;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        AppTextButton(text: widget.cancelLabel, onPressed: widget.onCancelled),
        AppPrimaryButton(
          text: widget.confirmLabel,
          onPressed: widget.onConfirmed == null
              ? null
              : () => widget.onConfirmed?.call(_score),
        ),
      ],
    );
  }
}
