import 'package:flutter/material.dart';

import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';

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
