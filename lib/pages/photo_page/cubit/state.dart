import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class PhotoPageState with _$PhotoPageState {
  const PhotoPageState._();

  const factory PhotoPageState({
    @Default(0) int selectedImageIndex,
  }) = _PhotoPageState;

  static const List<String> _imageTitles = [
    'Original',
    'Cropped',
    'Enhanced',
    'Mask',
  ];

  static const List<String> _imageDescriptions = [
    'The actual photo taken by Misty.',
    'The cropped cell phone image from the actual photo.',
    'The cropped cell phone image after image processing.',
    'The extracted green color pixels from the cropped cell phone image.'
  ];

  String get selectedImageTitle => _imageTitles[selectedImageIndex];

  String get selectedImageDesc => _imageDescriptions[selectedImageIndex];

  int get imagesCount => _imageTitles.length;
}
