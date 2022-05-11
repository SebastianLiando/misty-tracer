import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/network/model/confirm_email/confirmation_email.dart';

part 'state.freezed.dart';

@freezed
class AttendancePageState with _$AttendancePageState {
  const factory AttendancePageState({
    @Default([]) List<ConfirmationEmail> emails,
  }) = _AttendancePageState;
}
