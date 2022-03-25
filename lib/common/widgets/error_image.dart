import 'package:flutter/material.dart';

class ErrorImage extends StatelessWidget {
  const ErrorImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.grey,
          child: Icon(
            Icons.image_not_supported_rounded,
            color: Colors.white,
            size: constraints.maxWidth * 0.5,
          ),
        );
      },
    );
  }
}
