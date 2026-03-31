import 'package:flutter/material.dart';

import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';

class FolderDeckLoading extends StatelessWidget {
  const FolderDeckLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: LumosLoadingIndicator());
  }
}
