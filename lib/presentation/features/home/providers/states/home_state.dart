import 'package:freezed_annotation/freezed_annotation.dart';

export 'enums/home_tab_id.dart';
export 'home_navigation_item.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required int selectedIndex,
    required int previousIndex,
    required List<int> visitedTabIndices,
    required bool isSwitchLoading,
  }) = _HomeState;

  factory HomeState.initial() {
    return const HomeState(
      selectedIndex: 0,
      previousIndex: 0,
      visitedTabIndices: <int>[0],
      isSwitchLoading: false,
    );
  }
}
