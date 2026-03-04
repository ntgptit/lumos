import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderSkeletonView extends StatelessWidget {
  const FolderSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        LumosScreenFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const LumosSkeletonBox(height: AppSpacing.canvas),
              const SizedBox(height: AppSpacing.lg),
              ...List<Widget>.generate(
                6,
                (int index) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: LumosSkeletonBox(height: AppSpacing.canvas),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
