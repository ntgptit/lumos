import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderLoadMoreIndicator extends StatelessWidget {
  const FolderLoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: LumosLoadingIndicator());
  }
}
