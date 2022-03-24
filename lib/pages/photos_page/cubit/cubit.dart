import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';
import 'package:misty_tracer/network/websocket.dart';
import 'package:misty_tracer/pages/photos_page/cubit/state.dart';
import 'package:collection/collection.dart';

class PhotosPageCubit extends Cubit<PhotosPageState> {
  final WebsocketRepository wsRepo;
  final TextEditingController locationController;

  late final void Function() _listener;
  late final StreamSubscription _sub;

  String get connectedIp => wsRepo.connectedIp!;

  int get connectedPort => wsRepo.connectedPort!;

  PhotosPageCubit({
    PhotosPageState initialState = const PhotosPageState(),
    required this.locationController,
    required this.wsRepo,
  }) : super(initialState) {
    // Listen to location search
    _listener = () {
      emit(state.copyWith(locationFilter: locationController.text));
    };
    locationController.addListener(_listener);

    // Listen to verification data
    wsRepo.subscribe(Topic.verification);
    _sub = wsRepo.verifications.listen((verifications) {
      final grouped = verifications.groupListsBy((v) => v.locationActual);

      // Currently there is no update or delete
      // Therefore, can just add the data to the list
      final updatedMap = Map.of(state.verifications);

      grouped.forEach((location, items) {
        final updatedList = List<Verification>.of(updatedMap[location] ?? []);
        updatedList.addAll(items);
        updatedMap[location] = updatedList;
      });

      log(updatedMap[updatedMap.keys.first].toString());

      emit(state.copyWith(verifications: updatedMap));
    });
  }

  @override
  Future<void> close() {
    locationController.removeListener(_listener);
    _sub.cancel();
    wsRepo.unsubscribe(Topic.verification);

    return super.close();
  }

  void onPanelExpanded(int index, bool expanded) {
    final expandedPanels = Set.of(state.expandedPanels);

    if (expanded) {
      expandedPanels.add(index);
      log('Expanded $index');
    } else {
      expandedPanels.remove(index);
      log('Collapsed $index');
    }

    emit(state.copyWith(expandedPanels: expandedPanels));
  }

  String getImageThumbnailUri(Verification verification) {
    return "http://$connectedIp:$connectedPort/trace-together/images/${verification.id}/thumbnail.jpg";
  }

  bool isPanelExpanded(int index) => state.expandedPanels.contains(index);
}
