import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class MainPageState with _$MainPageState {
  const factory MainPageState({
    @Default(0) int tabIndex,
  }) = _MainPageState;
}
