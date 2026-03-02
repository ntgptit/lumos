import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../providers/folder_provider.dart';
import '../providers/states/folder_state.dart';
import 'folder_content.dart';
import 'widgets/states/folder_failure_view.dart';
import 'widgets/states/folder_skeleton_view.dart';

class FolderScreen extends ConsumerWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<FolderState> folderAsync = ref.watch(
      folderAsyncControllerProvider,
    );
    return folderAsync.whenWithLoading(
      loadingBuilder: (BuildContext context) => const FolderSkeletonView(),
      dataBuilder: (BuildContext context, FolderState state) {
        return FolderContent(state: state);
      },
      errorBuilder: (BuildContext context, Failure failure) {
        return FolderFailureView(
          message: failure.message,
          onRetry: () =>
              ref.read(folderAsyncControllerProvider.notifier).refresh(),
        );
      },
    );
  }
}
