import 'dart:math';

import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/common/widgets/text_icon.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';
import 'package:misty_tracer/pages/photo_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/photo_page/photo_page.dart';
import 'package:misty_tracer/pages/photos_page/cubit/cubit.dart';
import 'package:misty_tracer/pages/photos_page/cubit/state.dart';
import 'package:misty_tracer/pages/photos_page/widgets/verification_thumbnail.dart';

class PhotosPage extends StatelessWidget {
  const PhotosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosPageCubit, PhotosPageState>(
      builder: (context, data) {
        final cubit = context.read<PhotosPageCubit>();
        final verificationsMap = data.filteredVerification;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              cubit.onPanelExpanded(panelIndex, !isExpanded);
            },
            children:
                verificationsMap.keys.sorted().mapIndexed((index, location) {
              final verifications = verificationsMap[location]!;

              return _createPanel(
                context,
                location: location,
                verifications: verifications,
                isExpanded: cubit.isPanelExpanded(index),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  ExpansionPanel _createPanel(
    BuildContext context, {
    required String location,
    required List<Verification> verifications,
    bool isExpanded = false,
  }) {
    final cubit = context.read<PhotosPageCubit>();

    return ExpansionPanel(
      headerBuilder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextIcon(
            icon: Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.primary,
            ),
            text: Expanded(
              child: Text(location),
            ),
          ),
        );
      },
      body: SizedBox(
        height: max(240, MediaQuery.of(context).size.height * 0.3),
        child: Scrollbar(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final verification = verifications[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: OpenContainer(
                  transitionDuration: const Duration(milliseconds: 200),
                  closedBuilder: (context, open) {
                    return InkWell(
                      onTap: () => open(),
                      child: VerificationThumbnail(
                        // Example:
                        // 'http://192.168.0.103:8000/trace-together/images/6218a75b918343cbb16bd4fe/thumbnail.jpg'
                        url: cubit.getImageThumbnailUri(verification),
                        accepted: verification.isValid,
                      ),
                    );
                  },
                  openBuilder: (context, close) {
                    return BlocProvider(
                      create: (context) => PhotoPageCubit(),
                      child: PhotoPage(
                        ip: cubit.connectedIp,
                        port: cubit.connectedPort,
                        verification: verification,
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: verifications.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
      isExpanded: isExpanded,
    );
  }
}
