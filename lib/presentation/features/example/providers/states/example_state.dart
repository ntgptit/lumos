import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_state.freezed.dart';

@freezed
abstract class ExampleState with _$ExampleState {
  const factory ExampleState({
    required String title,
  }) = _ExampleState;

  factory ExampleState.initial() {
    return const ExampleState(title: 'Example Feature');
  }
}
