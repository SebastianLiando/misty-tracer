import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:misty_tracer/theme/colors.dart';

class VerificationThumbnail extends StatelessWidget {
  final String url;
  final bool accepted;
  final double aspectRatio;

  const VerificationThumbnail({
    Key? key,
    required this.url,
    required this.accepted,
    this.aspectRatio = 0.75,
  }) : super(key: key);

  Widget get resultIcon => Icon(
        accepted ? Icons.verified : Icons.warning,
        color: accepted ? acceptChip : rejectChip,
        size: 48,
      );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: Uri.parse(url).toString(),
            errorWidget: _errorPlaceholder,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Positioned(child: resultIcon, bottom: 8, right: 8),
        ],
      ),
    );
  }

  Widget _errorPlaceholder(
    BuildContext context,
    String url,
    dynamic error,
  ) {
    log(error.toString());

    return Stack(
      children: [
        Container(color: Colors.grey),
        const Positioned.fill(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.white,
            size: 60,
          ),
        ),
      ],
    );
  }
}
