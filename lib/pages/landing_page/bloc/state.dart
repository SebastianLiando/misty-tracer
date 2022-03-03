import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class LandingPageState with _$LandingPageState {
  const factory LandingPageState({
    @Default("") String ip,
    @Default("") String port,
    @Default(0) int stepperIndex,
  }) = _LandingPageState;
}

extension LandingPageStateExt on LandingPageState {
  int get portNumber => int.parse(port);

  bool get showFooter => stepperIndex == 2;

  bool get hasPreviousSession {
    return false;
  }
}
