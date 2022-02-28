import 'package:flutter/material.dart';
import 'package:misty_tracer/theme/assets.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(appLogo, width: (MediaQuery.of(context).size.width * 0.35).clamp(100, 150)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MISTY TRACER', style: textTheme.headline6),
            const SizedBox(height: 8),
            Text(
              'Checking TraceTogether\nmade easier.',
              style: textTheme.caption,
            ),
          ],
        )
      ],
    );
  }
}
