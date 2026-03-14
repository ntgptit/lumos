import 'package:flutter/material.dart';

import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../folder_content_support.dart';

class FolderLoadMoreIndicator extends StatelessWidget {
  const FolderLoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: FolderContentSupportConst.loadMoreTopSpacing,
        bottom: FolderContentSupportConst.loadMoreBottomSpacing,
      ),
      child: Center(child: LumosLoadingIndicator()),
    );
  }
}
