import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/common/utils/converter.dart';

part 'confirmation_email.freezed.dart';

part 'confirmation_email.g.dart';

@freezed
class ConfirmationEmail with _$ConfirmationEmail {
  const factory ConfirmationEmail({
    @JsonKey(name: "_id") required String id,
    required String fullname,
    required bool confirmed,
    @JsonKey(name: "confirmed_by") String? confirmedBy,
    @JsonKey(name: "confirmed_at")
    @NullableIso8601DateConverter()
        DateTime? confirmedAt,
  }) = _ConfirmationEmail;

  factory ConfirmationEmail.fromJson(Map<String, dynamic> json) => _$ConfirmationEmailFromJson(json);
}
