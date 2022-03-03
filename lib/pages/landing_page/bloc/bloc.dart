import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/pages/landing_page/bloc/state.dart';

class LandingPageBloc extends Cubit<LandingPageState> {
  LandingPageBloc([
    LandingPageState initialState = const LandingPageState(),
  ]) : super(initialState);

  void onStepperNext() {
    final curIndex = state.stepperIndex;

    emit(state.copyWith(stepperIndex: curIndex + 1));
  }

  void onStepperPrevious() {
    final curIndex = state.stepperIndex;

    emit(state.copyWith(stepperIndex: curIndex - 1));
  }
}
