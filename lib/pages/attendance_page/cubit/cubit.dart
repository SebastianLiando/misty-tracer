import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/common/utils/list_ext.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/attendance_page/cubit/state.dart';

class AttendancePageCubit extends Cubit<AttendancePageState> {
  final WebsocketRepository wsRepo;
  late final StreamSubscription sub;

  AttendancePageCubit(
    this.wsRepo, [
    AttendancePageState initialState = const AttendancePageState(),
  ]) : super(initialState) {
    wsRepo.subscribe(topicConfirmationEmail);

    sub = wsRepo.emails.listen((emails) {
      final currentEmails = state.emails;
      final updatedEmails = currentEmails.updateOnSameId(
        emails,
        (email) => email.id,
      );

      updatedEmails
          .sort((prev, next) => next.confirmedAt!.compareTo(prev.confirmedAt!));

      emit(state.copyWith(emails: updatedEmails));
    });
  }

  @override
  Future<void> close() {
    sub.cancel();
    wsRepo.unsubscribe(topicConfirmationEmail);
    return super.close();
  }
}
