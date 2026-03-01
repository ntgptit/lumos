import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderMutatingOverlay extends StatelessWidget {
  const FolderMutatingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Insets.spacing64 * 2,
        padding: const EdgeInsets.all(Insets.spacing16),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.large,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosSkeletonBox(
              width: Insets.spacing48,
              height: Insets.spacing48,
              borderRadius: BorderRadii.large,
            ),
            SizedBox(height: Insets.spacing12),
            LumosSkeletonBox(height: Insets.spacing12),
          ],
        ),
      ),
    );
  }
}
