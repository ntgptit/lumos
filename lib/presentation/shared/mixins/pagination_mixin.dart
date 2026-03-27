import 'package:flutter/material.dart';

mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  late final ScrollController paginationScrollController = ScrollController();
  VoidCallback? _paginationListener;

  @protected
  void setupPaginationListener({
    required Future<void> Function() onLoadMore,
    double threshold = 200,
  }) {
    if (_paginationListener != null) {
      paginationScrollController.removeListener(_paginationListener!);
    }
    _paginationListener = () {
      if (!paginationScrollController.hasClients) {
        return;
      }
      final position = paginationScrollController.position;
      if (position.pixels >= position.maxScrollExtent - threshold) {
        onLoadMore();
      }
    };
    paginationScrollController.addListener(_paginationListener!);
  }

  @protected
  void disposePaginationListener() {
    if (_paginationListener != null) {
      paginationScrollController.removeListener(_paginationListener!);
    }
    paginationScrollController.dispose();
  }
}
