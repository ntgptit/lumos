import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/async_value_error_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/repositories/folder_repository.dart';
import '../../../../domain/entities/folder_models.dart';
import '../widgets/folder_content_widget.dart';
import '../widgets/folder_display_widgets.dart';

part 'folder_management_screen.g.dart';

class FolderViewState {
  const FolderViewState({
    required this.folders,
    required this.breadcrumbItems,
    required this.currentParentId,
    required this.isMutating,
    required this.inlineErrorMessage,
  });

  final List<FolderNode> folders;
  final List<BreadcrumbNode> breadcrumbItems;
  final int? currentParentId;
  final bool isMutating;
  final String? inlineErrorMessage;

  factory FolderViewState.initial() {
    return const FolderViewState(
      folders: <FolderNode>[],
      breadcrumbItems: <BreadcrumbNode>[],
      currentParentId: null,
      isMutating: false,
      inlineErrorMessage: null,
    );
  }

  FolderViewState copyWith({
    List<FolderNode>? folders,
    List<BreadcrumbNode>? breadcrumbItems,
    int? currentParentId,
    bool clearParentId = false,
    bool? isMutating,
    String? inlineErrorMessage,
    bool clearInlineError = false,
  }) {
    final int? parentId = clearParentId
        ? null
        : (currentParentId ?? this.currentParentId);
    final String? message = clearInlineError
        ? null
        : (inlineErrorMessage ?? this.inlineErrorMessage);
    return FolderViewState(
      folders: folders ?? this.folders,
      breadcrumbItems: breadcrumbItems ?? this.breadcrumbItems,
      currentParentId: parentId,
      isMutating: isMutating ?? this.isMutating,
      inlineErrorMessage: message,
    );
  }
}

@Riverpod(keepAlive: true)
class FolderAsyncController extends _$FolderAsyncController {
  @override
  Future<FolderViewState> build() async {
    return _loadViewState(parentId: null);
  }

  Future<void> refresh() async {
    final int? parentId = state.asData?.value.currentParentId;
    state = const AsyncLoading<FolderViewState>();
    state = await AsyncValue.guard<FolderViewState>(() async {
      return _loadViewState(parentId: parentId);
    });
  }

  Future<void> openRoot() async {
    state = const AsyncLoading<FolderViewState>();
    state = await AsyncValue.guard<FolderViewState>(() async {
      return _loadViewState(parentId: null);
    });
  }

  Future<void> openFolder(int folderId) async {
    state = const AsyncLoading<FolderViewState>();
    state = await AsyncValue.guard<FolderViewState>(() async {
      return _loadViewState(parentId: folderId);
    });
  }

  Future<void> goToBreadcrumb(int? folderId) async {
    if (folderId == null) {
      await openRoot();
      return;
    }
    await openFolder(folderId);
  }

  Future<void> createFolder(String name) async {
    await _runMutation((FolderRepository repository, int? currentParentId) {
      return repository.createFolder(name: name, parentId: currentParentId);
    });
  }

  Future<void> renameFolder({
    required int folderId,
    required String name,
  }) async {
    await _runMutation((FolderRepository repository, int? currentParentId) {
      return repository.renameFolder(folderId: folderId, name: name);
    });
  }

  Future<void> deleteFolder(int folderId) async {
    await _runMutation((FolderRepository repository, int? currentParentId) {
      return repository.deleteFolder(folderId: folderId);
    });
  }

  Future<void> _runMutation(
    Future<Either<Failure, Unit>> Function(
      FolderRepository repository,
      int? currentParentId,
    )
    mutation,
  ) async {
    final FolderViewState current =
        state.asData?.value ?? FolderViewState.initial();
    state = AsyncData<FolderViewState>(
      current.copyWith(isMutating: true, clearInlineError: true),
    );
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    final Either<Failure, Unit> result = await mutation(
      repository,
      current.currentParentId,
    );

    if (result.isLeft()) {
      final Failure failure = result.swap().getOrElse(
        () => const Failure.unknown(message: 'Unknown error'),
      );
      state = AsyncData<FolderViewState>(
        current.copyWith(
          isMutating: false,
          inlineErrorMessage: failure.message,
        ),
      );
      return;
    }

    state = const AsyncLoading<FolderViewState>();
    state = await AsyncValue.guard<FolderViewState>(() async {
      return _loadViewState(parentId: current.currentParentId);
    });
  }

  Future<FolderViewState> _loadViewState({required int? parentId}) async {
    final FolderRepository repository = ref.read(folderRepositoryProvider);
    final Either<Failure, List<FolderNode>> foldersResult = await repository
        .getFolders();

    if (foldersResult.isLeft()) {
      final Failure failure = foldersResult.swap().getOrElse(
        () => const Failure.unknown(message: 'Unknown error'),
      );
      throw failure;
    }

    final List<FolderNode> folders = foldersResult.getOrElse(
      () => <FolderNode>[],
    );
    if (parentId == null) {
      return FolderViewState(
        folders: folders,
        breadcrumbItems: const <BreadcrumbNode>[],
        currentParentId: null,
        isMutating: false,
        inlineErrorMessage: null,
      );
    }

    final Either<Failure, List<BreadcrumbNode>> breadcrumbResult =
        await repository.getBreadcrumb(folderId: parentId);
    if (breadcrumbResult.isLeft()) {
      final Failure failure = breadcrumbResult.swap().getOrElse(
        () => const Failure.unknown(message: 'Unknown error'),
      );
      throw failure;
    }
    final List<BreadcrumbNode> breadcrumbs = breadcrumbResult.getOrElse(
      () => <BreadcrumbNode>[],
    );
    return FolderViewState(
      folders: folders,
      breadcrumbItems: breadcrumbs,
      currentParentId: parentId,
      isMutating: false,
      inlineErrorMessage: null,
    );
  }
}

class FolderManagementScreen extends ConsumerStatefulWidget {
  const FolderManagementScreen({super.key});

  @override
  ConsumerState<FolderManagementScreen> createState() =>
      _FolderManagementScreenState();
}

class _FolderManagementScreenState
    extends ConsumerState<FolderManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      ref.read(folderAsyncControllerProvider.future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<FolderViewState> folderAsync = ref.watch(
      folderAsyncControllerProvider,
    );
    return folderAsync.whenWithLoading(
      loadingBuilder: (BuildContext context) => const FolderSkeletonView(),
      dataBuilder: (BuildContext context, FolderViewState state) {
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
