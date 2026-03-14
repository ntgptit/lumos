import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class StudyProgressLoadingView extends StatelessWidget {
  const StudyProgressLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: LumosLoadingIndicator());
  }
}
