import 'dart:convert';
import 'dart:developer';

import 'package:misty_tracer/network/model/confirm_email/confirmation_email.dart';
import 'package:misty_tracer/network/model/data/data.dart';
import 'package:misty_tracer/network/model/robot/robot.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const topicRobot = 'ROBOT';
const topicVerification = 'VERIFICATION';
const topicConfirmationEmail = 'CONFIRMATION_EMAIL';

class WebsocketRepository {
  late final WebSocketChannel channel;
  late final Future<WebSocketData> connected;

  String? connectedIp;
  int? connectedPort;

  late final Stream<WebSocketData> dataStream;
  late final Stream<List<Robot>> robots;
  late final Stream<List<Verification>> verifications;
  late final Stream<List<ConfirmationEmail>> emails;

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

    dataStream = channel.stream.map((event) {
      Map<String, dynamic> json = toJson(event);
      return WebSocketData.fromJson(json);
    }).asBroadcastStream();

    connected =
        dataStream.firstWhere((data) => data.type == MessageType.connected);
    connectedIp = ip;
    connectedPort = port;

    final subData =
        dataStream.where((event) => event.type == MessageType.subscriptionData);

    // Robot data stream
    robots = subData
        .where((event) => event.data['topic'] == topicRobot)
        .map((event) {
      final List<dynamic> robotsJson = event.data['data'];

      return robotsJson.map((json) => Robot.fromJson(json)).toList();
    });

    // TraceTogether verification data stream
    verifications = subData
        .where((event) => event.data['topic'] == topicVerification)
        .map((event) {
      final List<dynamic> jsons = event.data['data'];

      return jsons.map((json) => Verification.fromJson(json)).toList();
    });

    // Confirmation email data stream
    emails = subData
        .where((event) => event.data['topic'] == topicConfirmationEmail)
        .map((event) {
      final List<dynamic> jsons = event.data['data'];

      return jsons.map((json) => ConfirmationEmail.fromJson(json)).toList();
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

  void subscribe(String topic) {
    final payload = {
      'type': 'SUBSCRIBE',
      'data': {
        'topic': topic,
      },
    };

    _sendJsonToServer(payload);
    log('Subscribed to $topic');
  }

  void unsubscribe(String topic) {
    final payload = {
      'type': 'UNSUBSCRIBE',
      'data': {
        'topic': topic,
      },
    };

    _sendJsonToServer(payload);
    log('Unsubscribed to $topic');
  }
}
