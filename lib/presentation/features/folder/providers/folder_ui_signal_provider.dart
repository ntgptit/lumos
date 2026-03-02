import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_ui_signal_provider.g.dart';

abstract final class FolderUiSignalConst {
  FolderUiSignalConst._();

  static const int initialSignalVersion = 0;
}

@Riverpod(keepAlive: true)
class FolderUiSignalController extends _$FolderUiSignalController {
  @override
  int build() {
    return FolderUiSignalConst.initialSignalVersion;
  }

  void requestScrollToTop() {
    state = state + 1;
  }
}
