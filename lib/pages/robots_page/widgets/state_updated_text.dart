import 'dart:async';

import 'package:flutter/material.dart';

String _getTimePast(Duration duration) {
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

class StateUpdatedText extends StatefulWidget {
  final DateTime updatedAt;

  const StateUpdatedText({
    Key? key,
    required this.updatedAt,
  }) : super(key: key);

  @override
  State<StateUpdatedText> createState() => _StateUpdatedTextState();
}

class _StateUpdatedTextState extends State<StateUpdatedText> {
  Timer? _timer;

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedTime = DateTime.now().difference(widget.updatedAt);

    return Text('State updated ${_getTimePast(elapsedTime)} ago');
  }
}
