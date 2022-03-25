import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundBlur extends StatelessWidget {
  final Widget child;
  final double strength;

  const BackgroundBlur({
    Key? key,
    required this.child,
    this.strength = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: strength, sigmaY: strength),
        child: child,
      ),
    );
  }
}
