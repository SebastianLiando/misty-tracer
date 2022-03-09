import 'package:flutter/material.dart';
import 'package:misty_tracer/theme/assets.dart';

class RobotIndicator extends StatelessWidget {
  /// Whether the robot is online.
  final bool online;
  final double radius;
  final double? height;
  final double? width;

  const RobotIndicator({
    Key? key,
    required this.online,
    this.radius = 8,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundColor: online ? Colors.lightGreen : Colors.grey,
                radius: radius,
              ),
            ),
            AnimatedOpacity(
              opacity: online ? 1 : 0.3,
              child: Image.asset(mistyHead),
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
