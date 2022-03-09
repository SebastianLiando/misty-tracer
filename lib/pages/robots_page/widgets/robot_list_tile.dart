import 'dart:async';

import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/text_icon.dart';
import 'package:misty_tracer/pages/robots_page/widgets/robot_indicator.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_badge.dart';

class RobotListTile extends StatefulWidget {
  final bool online;
  final String serial;
  final String location;
  final String state;
  final DateTime updatedAt;

  const RobotListTile({
    Key? key,
    required this.online,
    required this.serial,
    required this.location,
    required this.state,
    required this.updatedAt,
  }) : super(key: key);

  @override
  State<RobotListTile> createState() => _RobotListTileState();
}

class _RobotListTileState extends State<RobotListTile> {
  Widget get stateChip {
    switch (widget.state.toUpperCase()) {
      case 'PENDING':
        return StateBadge.pending();
      case 'IDLE':
        return StateBadge.idle();
      case 'ENGAGING':
        return StateBadge.engaging();
      case 'CAPTURING':
        return StateBadge.capturing();
      case 'VERIFYING':
        return StateBadge.verifying();
      case 'ACCEPT':
        return StateBadge.accept();
      case 'REJECT':
        return StateBadge.reject();
      default:
        return StateBadge.offline();
    }
  }

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Remove any ongoing timer
    _timer?.cancel();
    // Start a new timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  String getTimePast(Duration duration) {
    if (duration < const Duration(minutes: 1)) {
      return "${duration.inSeconds} seconds";
    } else if (duration < const Duration(hours: 1)) {
      return "${duration.inMinutes} minutes";
    } else if (duration < const Duration(days: 1)) {
      return "${duration.inHours} hours";
    } else {
      return "${duration.inDays} days";
    }
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = DateTime.now().difference(widget.updatedAt);

    return ListTile(
      leading: RobotIndicator(online: widget.online),
      trailing: stateChip,
      title: Text(widget.serial),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextIcon(
            icon: Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.primary,
            ),
            text: Text(widget.location),
          ),
          Text('State updated ${getTimePast(elapsedTime)} ago'),
        ],
      ),
      isThreeLine: true,
    );
  }
}
