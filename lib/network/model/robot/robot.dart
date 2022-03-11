import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/common/utils/converter.dart';

part 'robot.freezed.dart';

part 'robot.g.dart';

enum RobotState {
  @JsonValue("OFFLINE")
  offline,
  @JsonValue("PENDING")
  pending,
  @JsonValue("IDLE")
  idle,
  @JsonValue("ENGAGING")
  engaging,
  @JsonValue("CAPTURING")
  capturing,
  @JsonValue("VERIFYING")
  verifying,
  @JsonValue("ACCEPT")
  accept,
  @JsonValue("REJECT")
  reject
}

@freezed
class Robot with _$Robot {
  const factory Robot({
    @JsonKey(name: "_id") required String id,
    required String serial,
    @JsonKey(name: "current_state") required RobotState currentState,
    @JsonKey(name: "state_updated_at")
    @Iso8601DateConverter()
        required DateTime stateUpdatedAt,
    @Default("") String location,
  }) = _Robot;

  factory Robot.fromJson(Map<String, dynamic> json) => _$RobotFromJson(json);
}

extension RobotExt on Robot {
  bool get isConfigured => location.isNotEmpty;
}
