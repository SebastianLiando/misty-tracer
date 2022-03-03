import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class LandingPageState with _$LandingPageState {
  const factory LandingPageState({
    @Default(0) int stepperIndex,
  }) = _LandingPageState;
}

extension LandingPageStateExt on LandingPageState {
  bool get showFooter => stepperIndex == 2;

  bool get hasPreviousSession {
    return false;
  }
}