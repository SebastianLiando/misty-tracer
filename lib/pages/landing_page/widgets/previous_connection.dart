import 'package:flutter/material.dart';

import '../../../common/widgets/text_icon.dart';
import '../../../theme/icons.dart';

class PreviousConnection extends StatelessWidget {
  final String ip;
  final int port;
  final void Function() onTap;

  const PreviousConnection({
    Key? key,
    required this.ip,
    required this.port,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Or connect to the previous session',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      children: [
                        TextIcon(
                          icon: const Icon(CustomIcon.worldwide),
                          text: Text(ip),
                        ),
                        const SizedBox(width: 16),
                        TextIcon(
                          icon: const Icon(CustomIcon.ethernet),
                          text: Text(port.toString()),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
