import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:misty_tracer/pages/photo_page/cubit/state.dart';

class PhotoPageCubit extends Cubit<PhotoPageState> {
  PhotoPageCubit([
    PhotoPageState initialState = const PhotoPageState(),
  ]) : super(initialState);

  void onImageChange(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }
}
