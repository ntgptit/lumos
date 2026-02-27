import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required int selectedIndex,
    required int previousIndex,
  }) = _HomeState;

  factory HomeState.initial() {
    return const HomeState(selectedIndex: 0, previousIndex: 0);
  }
}
