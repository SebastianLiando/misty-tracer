import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/error_image.dart';
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
            errorWidget: (context, url, error) => const ErrorImage(),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Positioned(child: resultIcon, bottom: 8, right: 8),
        ],
      ),
    );
  }
}
