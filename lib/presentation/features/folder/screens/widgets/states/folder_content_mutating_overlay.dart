import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'folder_mutating_overlay.dart';

class FolderContentMutatingOverlay extends StatelessWidget {
  const FolderContentMutatingOverlay({required this.isMutating, super.key});

  final bool isMutating;

  @override
  Widget build(BuildContext context) {
    if (!isMutating) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: Theme.of(
            context,
          ).colorScheme.scrim.withValues(alpha: AppOpacity.strong),
          child: const FolderMutatingOverlay(),
        ),
      ),
    );
  }
}

