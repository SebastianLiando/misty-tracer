import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:misty_tracer/theme/icons.dart';

class VerificationDetails extends StatelessWidget {
  final String location;
  final String detectedLocation;
  final String serial;
  final DateTime date;
  final DateTime? detectedDate;

  const VerificationDetails({
    Key? key,
    required this.location,
    required this.detectedLocation,
    required this.serial,
    required this.date,
    required this.detectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.location_pin, color: primaryColor),
          title: Text(location),
          subtitle: Text(
            'Detected: ${detectedLocation.isEmpty ? "NONE" : detectedLocation}',
          ),
        ),
        ListTile(
          leading: Icon(CustomIcon.robot, color: primaryColor),
          title: Text(serial),
        ),
        ListTile(
          leading: Icon(Icons.calendar_month_rounded, color: primaryColor),
          title: Text(_formatDate(date)),
          subtitle: Text('Detected: $detectedDateLabel'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) => DateFormat.yMMMd().format(date);

  String get detectedDateLabel =>
      detectedDate != null ? _formatDate(detectedDate!) : "NONE";
}
