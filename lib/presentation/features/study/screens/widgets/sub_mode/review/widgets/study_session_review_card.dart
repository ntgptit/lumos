import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionReviewCard extends StatelessWidget {
  const StudySessionReviewCard({
    required this.content,
    required this.trailing,
    this.textStyle,
    super.key,
  });

  final String content;
  final Widget trailing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(alignment: Alignment.topRight, child: trailing),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: LumosInlineText(
                      content,
                      align: TextAlign.center,
                      style: textStyle?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
