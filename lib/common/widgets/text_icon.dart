import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final Widget text;
  final Widget icon;

  const TextIcon({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 4),
        text,
      ],
    );
  }
}
