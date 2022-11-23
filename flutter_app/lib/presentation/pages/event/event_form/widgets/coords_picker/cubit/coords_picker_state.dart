part of 'coords_picker_cubit.dart';

enum CoordsStatus {loading, saving, reloading, ready, error}

@CopyWith()
class CoordsPickerState {
  final List<MyLocation> locations;
  final CoordsStatus status;
  final NetWorkFailure? failure;

  CoordsPickerState({this.locations = const [],  required this.status, this.failure});

  factory CoordsPickerState.initial() => CoordsPickerState(status: CoordsStatus.loading);
}

