import 'package:flutter/material.dart';

class DisconnectDialog extends StatelessWidget {
  final Function onDisconnect;

  const DisconnectDialog({
    Key? key,
    required this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      title: const Text('Disconnect?'),
      content: const Text(
        'Are you sure you want to disconnect from the server?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: () {
            // Close this dialog
            Navigator.pop(context);
            // Invoke callback
            onDisconnect();
          },
          child: const Text('YES'),
        ),
      ],
    );
  }
}
