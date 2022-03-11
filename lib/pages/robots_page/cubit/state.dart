import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';

part 'state.freezed.dart';

@freezed
class RobotsPageState with _$RobotsPageState {
  const factory RobotsPageState({
    @Default([]) List<Robot> robots,
    @Default(true) bool showOnline,
    @Default(true) bool showOffline,
  }) = _RobotsPageState;
}

extension RobotsPageStateExt on RobotsPageState {
  List<Robot> get robotsFiltered {
    var result = robots;

    // If not showing online robots
    if (!showOnline) {
      result = result
          .where((robot) => robot.currentState == RobotState.offline)
          .toList();
    }

    if (!showOffline) {
      result = result
          .where((robot) => robot.currentState != RobotState.offline)
          .toList();
    }

    return result;
  }
}
