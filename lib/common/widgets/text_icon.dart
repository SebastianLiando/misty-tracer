import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final Widget text;
  final Widget icon;
  final double gap;

  const TextIcon({
    Key? key,
    required this.icon,
    required this.text,
    this.gap = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: gap),
        text,
      ],
    );
  }
}
