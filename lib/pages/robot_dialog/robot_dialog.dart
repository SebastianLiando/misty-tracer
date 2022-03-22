import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/form_field.dart';
import 'package:misty_tracer/pages/robots_page/widgets/robot_indicator.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_badge.dart';
import 'package:misty_tracer/pages/robots_page/widgets/state_updated_text.dart';

class RobotDialog extends StatefulWidget {
  const RobotDialog({Key? key}) : super(key: key);

  @override
  State<RobotDialog> createState() => _RobotDialogState();
}

class _RobotDialogState extends State<RobotDialog> {
  final locationController = TextEditingController();

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Robot Configuration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const RobotIndicator(
                online: true,
                width: 70,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    const FieldValue(
                      label: 'SERIAL',
                      value: Text('2022020202'),
                    ),
                    FieldValue(label: 'STATUS', value: StateBadge.idle()),
                    StateUpdatedText(
                      updatedAt: DateTime.now(),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g. BLK 202',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('SAVE CHANGES'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
