import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/folder_provider.dart';
import '../providers/states/folder_state.dart';
import 'folder_content.dart';
import 'widgets/states/folder_failure_view.dart';
import 'widgets/states/folder_skeleton_view.dart';

class FolderScreen extends ConsumerStatefulWidget {
  const FolderScreen({super.key});

  @override
  ConsumerState<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends ConsumerState<FolderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      ref.read(folderAsyncControllerProvider.future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<FolderState> folderAsync = ref.watch(
      folderAsyncControllerProvider,
    );
    return LumosScreenTransition(
      switchKey: ValueKey<String>(
        'folder-${folderAsync.runtimeType}-${folderAsync.asData?.value.currentParentId ?? -1}',
      ),
      moveForward: true,
      child: folderAsync.whenWithLoading(
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
      ),
    );
  }
}
