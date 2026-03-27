import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart'
    show ProviderListenable, ProviderOrFamily;

extension WidgetRefExt on WidgetRef {
  void invalidateAll(Iterable<ProviderOrFamily> providers) {
    for (final provider in providers) {
      invalidate(provider);
    }
  }

  List<T> readAll<T>(Iterable<ProviderListenable<T>> providers) {
    return [for (final provider in providers) read(provider)];
  }

  List<T> watchAll<T>(Iterable<ProviderListenable<T>> providers) {
    return [for (final provider in providers) watch(provider)];
  }
}
