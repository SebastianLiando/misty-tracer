import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/robot_dialog/cubit/state.dart';

class RobotDialogCubit extends Cubit<RobotDialogState> {
  final WebsocketRepository wsRepo;
  StreamSubscription? sub;

  RobotDialogCubit(
    RobotDialogState initialState,
    this.wsRepo,
  ) : super(initialState) {
    sub = wsRepo.subDataForId(initialState.initial.id).listen((robot) {
      emit(state.copyWith(initial: robot));
    });
  }

  @override
  Future<void> close() {
    sub?.cancel();
    return super.close();
  }

  void onRobotLocationChanged(String location) =>
      emit(state.copyWith(current: state.current.copyWith(location: location)));

  /// The server's endpoint to make update to robot location.
  Uri get updateRobotEndpoint => Uri.parse(
        // The server is HTTP
        'http://${state.ip}:${state.port}/robot/${state.initial.serial}',
      );

  void onSaveChanges() async {
    emit(state.copyWith(isSaving: true));

    // Send POST request to server
    final response = await post(
      updateRobotEndpoint,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'location': state.current.location.toUpperCase(),
      }),
    );

    emit(state.copyWith(isSaving: false));

    // Make sure successful
    if (response.statusCode != 200) {
      log('${response.statusCode}: ${response.body}');
      throw HttpException(response.body);
    }

    // Update robot data
    final updatedRobot = Robot.fromJson(jsonDecode(response.body));
    emit(state.copyWith(initial: updatedRobot, current: updatedRobot));
  }
}
