import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/common/utils/converter.dart';

part 'verification.freezed.dart';

part 'verification.g.dart';

@freezed
class Verification with _$Verification {
  const factory Verification({
    @JsonKey(name: "_id") required String id,
    @JsonKey(name: "check_in") required bool checkIn,
    @JsonKey(name: "date_valid") required bool dateValid,
    @JsonKey(name: "detected_date")
    @NullableIso8601DateConverter()
        DateTime? detectedDate,
    @JsonKey(name: "fully_vaccinated") required bool fullyVaccinated,
    @JsonKey(name: "green_ratio") required double greenRatio,
    @JsonKey(name: "location_actual") required String locationActual,
    @JsonKey(name: "location_detected") required String locationDetected,
    @JsonKey(name: "location_valid") required bool locationValid,
    @JsonKey(name: "raw_ocr") required String rawOcr,
    @JsonKey(name: "robot_serial") required String serial,
    @JsonKey(name: "safe_entry") required bool safeEntry,
  }) = _Verification;

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);
}

extension VerificationExt on Verification {
  /// Whether the certificate is a valid TraceTogether check-in certificate.
  bool get isValid {
    final isTTCheckIn = safeEntry && checkIn || fullyVaccinated;
    final fieldValid = dateValid && locationValid;

    return isTTCheckIn && fieldValid;
  }

  DateTime get actualDate {
    // Date is taken from MongoDB document id
    final timestampStr = id.substring(0, 8);
    final msEpoch = int.parse(timestampStr, radix: 16) * 1000;

    return DateTime.fromMillisecondsSinceEpoch(msEpoch);
  }
}
