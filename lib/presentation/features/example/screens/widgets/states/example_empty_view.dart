import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class ExampleEmptyView extends StatelessWidget {
  const ExampleEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LumosEmptyState(
      title: 'No data',
      message: 'No content available yet.',
      icon: Icons.inbox_outlined,
    );
  }
}
