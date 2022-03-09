import 'package:freezed_annotation/freezed_annotation.dart';

part 'data.freezed.dart';

part 'data.g.dart';

enum MessageType {
  @JsonValue('SUBSCRIBE')
  subscribe,
  @JsonValue('UNSUBSCRIBE')
  unsubscribe,
  @JsonValue('SUBSCRIPTION_DATA')
  subscriptionData,
  @JsonValue('CONNECTED')
  connected
}

@freezed
class WebSocketData with _$WebSocketData {
  const factory WebSocketData({
    required MessageType type,
    required Map<String, dynamic> data,
  }) = _WebSocketData;

  factory WebSocketData.fromJson(Map<String, dynamic> json) =>
      _$WebSocketDataFromJson(json);
}
