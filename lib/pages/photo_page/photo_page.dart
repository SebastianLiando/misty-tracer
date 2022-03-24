import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';
import 'package:misty_tracer/pages/photo_page/widgets/verification_details.dart';

class PhotoPage extends StatelessWidget {
  final String ip;
  final int port;

  final Verification verification;

  const PhotoPage({
    Key? key,
    required this.ip,
    required this.port,
    required this.verification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: constraints.maxHeight,
                        viewportFraction: 1
                      ),
                      items: [
                        CachedNetworkImage(
                          imageUrl:
                          'http://$ip:$port/trace-together/images/${verification.id}/thumbnail.jpg',
                          width: constraints.maxWidth,
                          fit: BoxFit.cover,
                        ),
                        CachedNetworkImage(
                          imageUrl:
                          'http://$ip:$port/trace-together/images/${verification.id}/thumbnail.jpg',
                          width: constraints.maxWidth,
                          fit: BoxFit.cover,
                        ),
                      ],
                    );
                  },
                ),
                flex: 7,
              ),
              Expanded(
                child: VerificationDetails(
                  location: verification.locationActual,
                  detectedLocation: verification.locationDetected,
                  serial: verification.serial,
                  date: verification.actualDate,
                  detectedDate: verification.detectedDate,
                ),
                flex: 3,
              ),
            ],
          ),
        ),
        _buildAppBar(context),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      top: 0,
      left: 0,
      right: 0,
    );
  }
}
