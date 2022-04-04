import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/common/widgets/background_blur.dart';
import 'package:misty_tracer/common/widgets/carousel_indicator.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';
import 'package:misty_tracer/pages/fullscreen_photo_page/fullscreen_photo_page.dart';
import 'package:misty_tracer/pages/photo_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/photo_page/cubit/state.dart';
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
      Theme.of(context).colorScheme.primary.withOpacity(0.25);

  bool get isLandscape {
    final size = MediaQuery.of(context).size;
    return size.width >= size.height;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoPageCubit, PhotoPageState>(
      builder: (context, state) {
        final cubit = context.read<PhotoPageCubit>();

        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: isLandscape
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildPhotoSection(cubit, context, state),
                            flex: 7,
                          ),
                          Expanded(
                            child: _buildDetailsSection(),
                            flex: 3,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildPhotoSection(cubit, context, state),
                            flex: 7,
                          ),
                          Expanded(
                            child: _buildDetailsSection(),
                            flex: 3,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsSection() {
    return VerificationDetails(
      location: widget.verification.locationActual,
      detectedLocation: widget.verification.locationDetected,
      serial: widget.verification.serial,
      date: widget.verification.actualDate,
      detectedDate: widget.verification.detectedDate,
    );
  }

  Widget _buildPhotoSection(
    PhotoPageCubit cubit,
    BuildContext context,
    PhotoPageState state,
  ) {
    return Stack(
      children: [
        VerificationPhotos(
          ip: widget.ip,
          port: widget.port,
          verificationId: widget.verification.id,
          controller: _carouselController,
          onPageChanged: (index) => cubit.onImageChange(index),
          onTapImage: (url) {
            showDialog(
              context: context,
              builder: (context) {
                return FullScreenPhotoPage(url: url);
              },
            );
          },
        ),
        Positioned(
          child: BackgroundBlur(
            child: BottomAppBar(
              elevation: 0,
              color: _appBarColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: VerificationPhotoDetails(
                  title: state.selectedImageTitle,
                  desc: state.selectedImageDesc,
                  isValid: widget.verification.isValid,
                  fullyVaccinated: widget.verification.fullyVaccinated,
                ),
              ),
            ),
          ),
          bottom: 0,
          left: 0,
          right: 0,
        ),
        _buildAppBar(context),
        Positioned(
          left: 0,
          right: 0,
          top: 16,
          child: CarouselIndicator(
            count: 4,
            selected: state.selectedImageIndex,
            onTap: (index) {
              _carouselController.animateToPage(index);
              cubit.onImageChange(index);
            },
            selectedColor: Colors.white,
            disabledColor: Colors.grey.shade600,
          ),
        )
      ],
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
