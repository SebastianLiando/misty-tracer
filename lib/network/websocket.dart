import 'dart:convert';
import 'dart:developer';
import 'package:misty_tracer/network/model/data/data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketRepository {
  late final WebSocketChannel channel;
  late final Future<WebSocketData> connected;

  void connect(
    String ip,
    int port, {
    Function? onConnected,
    Function(WebSocketChannelException)? onError,
  }) {
    final uri = Uri.parse('ws://$ip:$port');
    log('Connecting to $uri');
    channel = WebSocketChannel.connect(uri);

    final dataStream = channel.stream.map((event) {
      Map<String, dynamic> json = const JsonDecoder().convert(event);
      return WebSocketData.fromJson(json);
    }).asBroadcastStream();

    connected =
        dataStream.firstWhere((data) => data.type == MessageType.connected);
  }

  void disconnect() {
    channel.sink.close();
  }
}
