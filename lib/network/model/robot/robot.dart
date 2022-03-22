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
class Robot with _$Robot implements Comparable<Robot> {
  const Robot._();

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

  @override
  int compareTo(Robot other) {
    if (!isConfigured && !other.isConfigured ||
        isConfigured && other.isConfigured) {
      // Sort by serial number if both are configured/not configured
      return serial.compareTo(other.serial);
    } else if (!isConfigured) {
      // Non-configured robot should be at the front of the list
      return -1;
    } else {
      return 1;
    }
  }
}

extension RobotExt on Robot {
  bool get isConfigured => location.isNotEmpty;

  bool get isOnline => currentState != RobotState.offline;
}
