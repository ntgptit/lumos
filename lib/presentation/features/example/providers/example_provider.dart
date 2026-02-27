import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'states/example_state.dart';

part 'example_provider.g.dart';

@Riverpod(keepAlive: true)
class ExampleAsyncController extends _$ExampleAsyncController {
  @override
  Future<ExampleState> build() async {
    return ExampleState.initial();
  }
}
