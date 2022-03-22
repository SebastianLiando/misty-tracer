import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/text_icon.dart';
import 'package:misty_tracer/pages/robots_page/widgets/robot_indicator.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_badge.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_updated_text.dart';

class RobotListTile extends StatefulWidget {
  final bool online;
  final String serial;
  final String location;
  final String state;
  final DateTime updatedAt;
  final void Function()? onTap;

  const RobotListTile({
    Key? key,
    required this.online,
    required this.serial,
    required this.location,
    required this.state,
    required this.updatedAt,
    this.onTap,
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RobotIndicator(online: widget.online),
      trailing: stateChip,
      title: Text(widget.serial),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextIcon(
            icon: Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.primary,
            ),
            text: Expanded(
              child: Text(widget.location.isEmpty ? '-' : widget.location),
            ),
          ),
          StateUpdatedText(updatedAt: widget.updatedAt),
        ],
      ),
      isThreeLine: true,
      onTap: widget.onTap,
    );
  }
}
