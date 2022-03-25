import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/background_blur.dart';
import 'package:misty_tracer/common/widgets/carousel_indicator.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';
import 'package:misty_tracer/pages/photo_page/widgets/verification_details.dart';
import 'package:misty_tracer/pages/photo_page/widgets/verification_photo_details.dart';
import 'package:misty_tracer/pages/photo_page/widgets/verification_photos.dart';

class PhotoPage extends StatefulWidget {
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
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final _carouselController = CarouselController();

  Color get _appBarColor =>
      Theme.of(context).colorScheme.primary.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      VerificationPhotos(
                        ip: widget.ip,
                        port: widget.port,
                        verificationId: widget.verification.id,
                        controller: _carouselController,
                      ),
                      Positioned(
                        child: BackgroundBlur(
                          child: BottomAppBar(
                            elevation: 0,
                            color: _appBarColor,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: VerificationPhotoDetails(
                                title: 'Original',
                                desc: 'The actual photo taken by Misty',
                                isValid: widget.verification.isValid,
                                fullyVaccinated:
                                    widget.verification.fullyVaccinated,
                              ),
                            ),
                          ),
                        ),
                        bottom: 0,
                        left: 0,
                        right: 0,
                      ),
                    ],
                  ),
                  flex: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CarouselIndicator(
                    count: 4,
                    onTap: (index) {
                      _carouselController.animateToPage(index);
                    },
                  ),
                ),
                Expanded(
                  child: VerificationDetails(
                    location: widget.verification.locationActual,
                    detectedLocation: widget.verification.locationDetected,
                    serial: widget.verification.serial,
                    date: widget.verification.actualDate,
                    detectedDate: widget.verification.detectedDate,
                  ),
                  flex: 3,
                ),
              ],
            ),
          ),
          _buildAppBar(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      child: BackgroundBlur(
        child: AppBar(elevation: 0, backgroundColor: _appBarColor),
      ),
      top: 0,
      left: 0,
      right: 0,
    );
  }
}
