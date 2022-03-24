import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misty_tracer/network/model/verification/verification.dart';

part 'state.freezed.dart';

@freezed
class PhotosPageState with _$PhotosPageState {
  const PhotosPageState._();

  const factory PhotosPageState({
    @Default({}) Map<String, List<Verification>> verifications,

    /// Indexes of [ExpansionPanel] that are expanded.
    @Default({}) Set<int> expandedPanels,
    @Default("") locationFilter,
  }) = _PhotosPageState;

  Map<String, List<Verification>> get filteredVerification {
    final current = Map.of(verifications);

    current.removeWhere((location, _) => !location.contains(locationFilter));

    return current;
  }
}
