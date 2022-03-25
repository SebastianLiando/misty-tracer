import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/error_image.dart';

class FullScreenPhotoPage extends StatelessWidget {
  final String url;

  const FullScreenPhotoPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: InteractiveViewer(
        maxScale: 10,
        child: CachedNetworkImage(
          imageUrl: url,
          errorWidget: (context, url, error) => const ErrorImage(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
