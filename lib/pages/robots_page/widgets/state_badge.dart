import 'package:flutter/material.dart';
import 'package:misty_tracer/theme/colors.dart';

class StateBadge extends StatelessWidget {
  final String state;
  final Color color;

  const StateBadge({
    Key? key,
    required this.state,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(state),
      backgroundColor: color,
    );
  }

  factory StateBadge.offline() =>
      const StateBadge(state: 'OFFLINE', color: offlineChip);

  factory StateBadge.pending() =>
      const StateBadge(state: 'PENDING', color: pendingChip);

  factory StateBadge.idle() => const StateBadge(state: 'IDLE', color: idleChip);

  factory StateBadge.engaging() =>
      const StateBadge(state: 'ENGAGING', color: engagingChip);

  factory StateBadge.capturing() =>
      const StateBadge(state: 'CAPTURING', color: capturingChip);

  factory StateBadge.verifying() =>
      const StateBadge(state: 'VERIFYING', color: verifyingChip);

  factory StateBadge.accept() =>
      const StateBadge(state: 'ACCEPT', color: acceptChip);

  factory StateBadge.reject() =>
      const StateBadge(state: 'REJECT', color: rejectChip);

  factory StateBadge.fromState(String state) {
    switch (state.toUpperCase()) {
      case 'OFFLINE':
        return StateBadge.offline();
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
        throw UnsupportedError("State $state is not supported!");
    }
  }
}
