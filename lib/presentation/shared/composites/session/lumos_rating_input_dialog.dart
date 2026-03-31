import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_text_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_score_input.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosRatingInputDialog extends StatefulWidget {
  const LumosRatingInputDialog({
    super.key,
    required this.title,
    this.message,
    this.initialScore,
    this.minScore = 1,
    this.maxScore = 5,
    this.allowClear = false,
    this.confirmLabel,
    this.cancelLabel,
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
  final String? confirmLabel;
  final String? cancelLabel;
  final ValueChanged<int?>? onConfirmed;
  final VoidCallback? onCancelled;
  final String Function(int score)? scoreLabelBuilder;

  @override
  State<LumosRatingInputDialog> createState() => _LumosRatingInputDialogState();
}

class _LumosRatingInputDialogState extends State<LumosRatingInputDialog> {
  late int? _score = widget.initialScore;

  @override
  void didUpdateWidget(covariant LumosRatingInputDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialScore != widget.initialScore) {
      _score = widget.initialScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedConfirmLabel =
        widget.confirmLabel ?? context.l10n.commonSave;
    final String resolvedCancelLabel =
        widget.cancelLabel ?? context.l10n.commonCancel;
    return AlertDialog(
      title: LumosTitleText(text: widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message != null) ...[
              LumosBodyText(text: widget.message!),
              const LumosSpacing(size: AppSpacingSize.sm),
            ],
            LumosScoreInput(
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
        LumosTextButton(
          text: resolvedCancelLabel,
          onPressed: widget.onCancelled,
        ),
        LumosPrimaryButton(
          text: resolvedConfirmLabel,
          onPressed: widget.onConfirmed == null
              ? null
              : () => widget.onConfirmed?.call(_score),
        ),
      ],
    );
  }
}
