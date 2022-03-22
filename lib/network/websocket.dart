import 'dart:convert';
import 'dart:developer';
import 'package:misty_tracer/network/model/data/data.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum Topic { robot, verification }

class WebsocketRepository {
  late final WebSocketChannel channel;
  late final Future<WebSocketData> connected;

  String? connectedIp;
  int? connectedPort;

  late final Stream<List<Robot>> robots;

  Map<String, dynamic> toJson(String input) =>
      const JsonDecoder().convert(input);

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
      Map<String, dynamic> json = toJson(event);
      return WebSocketData.fromJson(json);
    }).asBroadcastStream();

    connected =
        dataStream.firstWhere((data) => data.type == MessageType.connected);
    connectedIp = ip;
    connectedPort = port;

    final subData =
        dataStream.where((event) => event.type == MessageType.subscriptionData);

    robots = subData
        .where((event) => event.data['topic'] == Topic.robot.name.toUpperCase())
        .map((event) {
      final List<dynamic> robotsJson = event.data['data'];

      return robotsJson.map((json) => Robot.fromJson(json)).toList();
    });
  }

  /// Subscription data only of the robot with the given [id].
  Stream<Robot> subDataForId(String id) {
    return robots.expand((element) => element).where((robot) => robot.id == id);
  }

  void disconnect() {
    channel.sink.close();
  }

  void _sendJsonToServer(Map<String, dynamic> json) {
    final encoded = const JsonEncoder().convert(json);
    channel.sink.add(encoded);
  }

  void subscribe(Topic topic) {
    final payload = {
      'type': 'SUBSCRIBE',
      'data': {
        'topic': topic.name.toUpperCase(),
      },
    };

    _sendJsonToServer(payload);
    log('Subscribed to $topic');
  }

  void unsubscribe(Topic topic) {
    final payload = {
      'type': 'UNSUBSCRIBE',
      'data': {
        'topic': topic.name.toUpperCase(),
      },
    };

    _sendJsonToServer(payload);
    log('Unsubscribed to $topic');
  }
}
