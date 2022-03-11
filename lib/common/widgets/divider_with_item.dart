import 'package:flutter/material.dart';

class DividerWithItem extends StatelessWidget {
  final Color? color;
  final Widget item;
  final EdgeInsets? itemPadding;

  const DividerWithItem({
    Key? key,
    this.color,
    required this.item,
    this.itemPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: color),
        ),
        Padding(
          padding: itemPadding ?? const EdgeInsets.symmetric(horizontal: 4),
          child: item,
        ),
        Expanded(
          child: Divider(color: color),
        ),
      ],
    );
  }
}
