import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:misty_tracer/pages/attendance_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/attendance_page/cubit/state.dart';

import '../../theme/colors.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendancePageCubit, AttendancePageState>(
        builder: (context, data) {
      if (data.emails.isEmpty) return _buildEmptyPlaceholder(context);

      final attendances = data.emails;
      return ListView.builder(
        itemBuilder: (context, index) {
          final item = attendances[index];

          return ListTile(
            title: Text(item.fullname.toUpperCase()),
            subtitle: Text('Robot: ${item.confirmedBy}'),
            leading: const Icon(Icons.verified, color: acceptChip),
            trailing: Column(
              children: [
                const Icon(Icons.alarm),
                Text(DateFormat.Hm().format(item.confirmedAt!)),
              ],
            ),
          );
        },
        itemCount: attendances.length,
      );
    });
  }

  Widget _buildEmptyPlaceholder(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;

    return Center(
      child: Column(
        children: [
          const Expanded(child: SizedBox()),
          Icon(Icons.hourglass_full_rounded, color: disabledColor, size: 80),
          const SizedBox(height: 16),
          Text(
            'Waiting for Users',
            style: TextStyle(
              color: disabledColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No users checked in with the robot yet :)',
            style: TextStyle(color: disabledColor),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
