import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class StudyProgressErrorView extends StatelessWidget {
  const StudyProgressErrorView({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LumosErrorState(errorMessage: errorMessage, onRetry: onRetry),
    );
  }
}
