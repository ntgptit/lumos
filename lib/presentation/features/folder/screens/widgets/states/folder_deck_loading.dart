import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderDeckLoading extends StatelessWidget {
  const FolderDeckLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: LumosLoadingIndicator());
  }
}
