import 'package:flutter/material.dart';

class FieldValue extends StatelessWidget {
  final String label;
  final Widget value;

  const FieldValue({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.caption),
        const SizedBox(width: 8),
        value,
      ],
    );
  }
}
