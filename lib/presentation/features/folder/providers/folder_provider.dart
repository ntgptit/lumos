import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../data/repositories/folder_repository.dart';
import '../../../../domain/entities/folder_models.dart';
import 'states/folder_state.dart';

part 'folder_provider.g.dart';

@Riverpod(keepAlive: true)
class FolderAsyncController extends _$FolderAsyncController {
  @override
  Future<FolderState> build() async {
    return _loadState(parentId: null);
  }

  Future<void> refresh() async {
    final int? parentId = state.asData?.value.currentParentId;
    state = const AsyncLoading<FolderState>();
    state = await AsyncValue.guard<FolderState>(() async {
      return _loadState(parentId: parentId);
    });
  }

  Future<void> openRoot() async {
    state = const AsyncLoading<FolderState>();
    state = await AsyncValue.guard<FolderState>(() async {
      return _loadState(parentId: null);
    });
  }

  Future<void> openFolder(int folderId) async {
    state = const AsyncLoading<FolderState>();
    state = await AsyncValue.guard<FolderState>(() async {
      return _loadState(parentId: folderId);
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
    await _runMutation(
      mutationType: FolderMutationType.creating,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.createFolder(name: name, parentId: currentParentId);
      },
    );
  }

  Future<void> renameFolder({
    required int folderId,
    required String name,
  }) async {
    await _runMutation(
      mutationType: FolderMutationType.renaming,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.renameFolder(folderId: folderId, name: name);
      },
    );
  }

  Future<void> deleteFolder(int folderId) async {
    await _runMutation(
      mutationType: FolderMutationType.deleting,
      mutation: (FolderRepository repository, int? currentParentId) {
        return repository.deleteFolder(folderId: folderId);
      },
    );
  }

  Future<void> _runMutation({
    required FolderMutationType mutationType,
    required Future<Either<Failure, Unit>> Function(
      FolderRepository repository,
      int? currentParentId,
    ) mutation,
  }) async {
    final FolderState current = state.asData?.value ?? FolderState.initial();
    state = AsyncData<FolderState>(
      current.copyWith(
        mutationType: mutationType,
        inlineErrorMessage: null,
      ),
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
      state = AsyncData<FolderState>(
        current.copyWith(
          mutationType: FolderMutationType.none,
          inlineErrorMessage: failure.message,
        ),
      );
      return;
    }

    state = const AsyncLoading<FolderState>();
    state = await AsyncValue.guard<FolderState>(() async {
      return _loadState(parentId: current.currentParentId);
    });
  }

  Future<FolderState> _loadState({required int? parentId}) async {
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
      return FolderState(
        tree: FolderTreeState(
          folders: folders,
          breadcrumbItems: const <BreadcrumbNode>[],
          currentParentId: null,
        ),
        mutationType: FolderMutationType.none,
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

    return FolderState(
      tree: FolderTreeState(
        folders: folders,
        breadcrumbItems: breadcrumbResult.getOrElse(() => <BreadcrumbNode>[]),
        currentParentId: parentId,
      ),
      mutationType: FolderMutationType.none,
      inlineErrorMessage: null,
    );
  }
}
