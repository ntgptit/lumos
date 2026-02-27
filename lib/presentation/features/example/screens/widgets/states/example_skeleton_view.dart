import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class ExampleSkeletonView extends StatelessWidget {
  const ExampleSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: LumosLoadingIndicator());
  }
}
