import 'package:flutter/foundation.dart';
import 'package:lumos/core/config/app_limits.dart';

class AppPaginationController {
  AppPaginationController({this.pageSize = AppLimits.defaultPageSize});

  final int pageSize;
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  int _nextPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  int _loadedItemCount = 0;

  ValueListenable<int> get changes => _revision;
  int get nextPage => _nextPage;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int get loadedItemCount => _loadedItemCount;
  bool get canLoadMore => !_isLoading && _hasMore;

  void startLoading() {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _notify();
  }

  void completePage({required int receivedItemCount, bool? hasMore}) {
    _loadedItemCount += receivedItemCount;
    _isLoading = false;
    _hasMore = hasMore ?? receivedItemCount >= pageSize;
    if (_hasMore) {
      _nextPage += 1;
    }
    _notify();
  }

  void fail() {
    if (!_isLoading) {
      return;
    }
    _isLoading = false;
    _notify();
  }

  void reset() {
    _nextPage = 1;
    _isLoading = false;
    _hasMore = true;
    _loadedItemCount = 0;
    _notify();
  }

  bool shouldLoadMore({
    required double pixels,
    required double maxScrollExtent,
    double threshold = 200,
  }) {
    return canLoadMore && pixels >= maxScrollExtent - threshold;
  }

  void dispose() {
    _revision.dispose();
  }

  void _notify() {
    _revision.value += 1;
  }
}
