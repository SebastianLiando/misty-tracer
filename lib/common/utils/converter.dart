import 'package:freezed_annotation/freezed_annotation.dart';

class Iso8601DateConverter implements JsonConverter<DateTime, String> {
  const Iso8601DateConverter();

  @override
  DateTime fromJson(String json) {
    // Example data from server: 2022-03-09T11:02:06.103000
    final date = DateTime.parse(json + "Z");
    return date.toLocal();
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
