import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/data/preference_repository.dart';
import 'package:misty_tracer/pages/landing_page/cubit/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  late final PreferenceRepository _prefRepo;

  LandingPageCubit([
    LandingPageState initialState = const LandingPageState(),
  ]) : super(initialState) {
    SharedPreferences.getInstance().then((sharedPref) {
      _prefRepo = PreferenceRepository(sharedPref);
      _loadPreferenceData();

      // On first load, if the skip tutorial is checked, immediately go to last step
      if (state.skipTutorial) {
        log('User skipped tutorial, stepping to last step');
        emit(state.copyWith(stepperIndex: 2));
      }
    });
  }

  void _loadPreferenceData() {
    emit(state.copyWith(
      previousIp: _prefRepo.prevSessionIp,
      previousPort: _prefRepo.prevSessionPort,
      skipTutorial: _prefRepo.skipTutorial,
    ));
  }

  void onStepperNext() {
    final curIndex = state.stepperIndex;

    emit(state.copyWith(stepperIndex: curIndex + 1));
  }

  void onStepperPrevious() {
    final curIndex = state.stepperIndex;

    emit(state.copyWith(stepperIndex: curIndex - 1));
  }

  void onChangedIp(String ip) => emit(state.copyWith(ip: ip));

  void onChangedPortNumber(String port) => emit(state.copyWith(port: port));

  void onSaveServerAddress(String ip, int port) async {
    await _prefRepo.setLastSessionIp(ip);
    await _prefRepo.setLastSessionPort(port);
    _loadPreferenceData();
  }

  void onCheckedChangeSkipTutorial(bool skip) async {
    await _prefRepo.setSkipTutorial(skip);
    _loadPreferenceData();
  }

  void onConnecting(bool connecting) =>
      emit(state.copyWith(isConnecting: connecting));
}
