part of 'my_locations_form_cubit.dart';




// @freezed
// class MyLocationsFormState with _$MyLocationsFormState {
//
//   const MyLocationsFormState._();
//
//   factory MyLocationsFormState.initial() = InitialState;
//
//   factory MyLocationsFormState.editing({MyLocation location}) = Editing;
// }

enum MLFStatus {initial, loading, saving, error, finished}
@CopyWith()
class MyLocationsFormState {
  final MyLocation location;
  final MLFStatus status;
  final NetWorkFailure? failure;

  const MyLocationsFormState({required this.status, required this.location, this.failure});

  factory MyLocationsFormState.initial() => MyLocationsFormState(
      status: MLFStatus.initial,
      location: MyLocation(latitude: 0.0, longitude: 0.0, address: MyLocationAddress(""), name: MyLocationName(""), id: UniqueId()));
}