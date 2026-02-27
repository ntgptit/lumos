import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderSkeletonView extends StatelessWidget {
  const FolderSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Insets.spacing16),
      children: <Widget>[
        const LumosSkeletonBox(height: Insets.spacing64),
        const SizedBox(height: Insets.spacing16),
        ...List<Widget>.generate(
          6,
          (int index) => const Padding(
            padding: EdgeInsets.only(bottom: Insets.spacing8),
            child: LumosSkeletonBox(height: Insets.spacing64),
          ),
        ),
      ],
    );
  }
}
