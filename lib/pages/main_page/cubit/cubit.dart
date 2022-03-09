import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/pages/main_page/cubit/state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit([MainPageState initialState = const MainPageState()])
      : super(initialState);

  void onTabChange(int index) => emit(state.copyWith(tabIndex: index));
}
