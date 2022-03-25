import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/error_image.dart';

class VerificationPhotos extends StatelessWidget {
  final String ip;
  final int port;
  final String verificationId;

  final CarouselController? controller;
  final void Function(int) onPageChanged;

  const VerificationPhotos({
    Key? key,
    required this.ip,
    required this.port,
    required this.verificationId,
    required this.onPageChanged,
    this.controller,
  }) : super(key: key);

  String get _baseImageUrl =>
      'http://$ip:$port/trace-together/images/$verificationId';

  List<String> get _imageUrls => [
        '$_baseImageUrl/original.jpg',
        '$_baseImageUrl/cropped.jpg',
        '$_baseImageUrl/enhanced.jpg',
        '$_baseImageUrl/mask.jpg',
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            height: constraints.maxHeight,
            viewportFraction: 1,
            onPageChanged: (index, _) => onPageChanged(index),
          ),
          items: _imageUrls.map(
            (url) {
              return CachedNetworkImage(
                imageUrl: url,
                width: constraints.maxWidth,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return const ErrorImage();
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}
