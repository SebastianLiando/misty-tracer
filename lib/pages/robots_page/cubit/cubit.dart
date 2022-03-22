import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/robots_page/cubit/state.dart';

class RobotsPageCubit extends Cubit<RobotsPageState> {
  final WebsocketRepository wsRepo;
  late final StreamSubscription sub;

  /// The IP address of the server.
  String get connectedIp => wsRepo.connectedIp!;

  /// The port number of the connection.
  int get connectedPort => wsRepo.connectedPort!;

  RobotsPageCubit(
    this.wsRepo, [
    RobotsPageState initialState = const RobotsPageState(),
  ]) : super(initialState) {
    // Subscribes to robots
    wsRepo.subscribe(Topic.robot);

    // Listen to data changes
    sub = wsRepo.robots.listen((robots) {
      updateRobots(robots);
    });
  }

  void updateRobots(List<Robot> newRobots) {
    final currentRobots = state.robots;
    final idsToIndex = <String, int>{};

    for (int i = 0; i < currentRobots.length; i++) {
      final id = currentRobots[i].id;
      idsToIndex[id] = i;
    }

    final updatedRobots = List.of(currentRobots);
    for (final robot in newRobots) {
      final index = idsToIndex[robot.id];

      if (index != null) {
        // Update on existing robot data
        updatedRobots[index] = robot;
      } else {
        // New robot data
        updatedRobots.add(robot);
      }
    }

    updatedRobots.sort();
    emit(state.copyWith(robots: updatedRobots));
  }

  @override
  Future<void> close() {
    // Unsubscribe from robots
    sub.cancel();
    wsRepo.unsubscribe(Topic.robot);
    return super.close();
  }

  void onChangeShowOnline(bool show) => emit(state.copyWith(showOnline: show));

  void onChangeShowOffline(bool show) =>
      emit(state.copyWith(showOffline: show));
}
