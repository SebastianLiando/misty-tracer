import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';

part 'state.freezed.dart';

@freezed
class RobotDialogState with _$RobotDialogState {
  const factory RobotDialogState({
    required String ip,
    required int port,
    required Robot initial,
    required Robot current,
    @Default(false) bool isSaving,
  }) = _RobotDialogState;
}

extension RobotDialogStateExt on RobotDialogState {
  bool get canSave {
    return initial != current && current.location.trim().isNotEmpty;
  }

  String? get locationError {
    if (current.location.trim().isEmpty) return "Location must not be empty!";

    return null;
  }
}
