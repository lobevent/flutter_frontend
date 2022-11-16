part of 'my_locations_cubit.dart';

// @immutable
// abstract class MyLocationsState {}
//
// class MyLocationsInitial extends MyLocationsState {}
// class MyLocationsLoading extends MyLocationsState {}
// class MyLocationsLoaded extends MyLocationsState {
//   final List<MyLocation> myLocations;
//   MyLocationsLoaded(this.myLocations);
// }
// class MyLocationsError extends MyLocationsState {
//   final NetWorkFailure failure;
//   MyLocationsError(this.failure);
// }

enum MyLocationStatus {loading, loaded, error}
@CopyWith()
class MyLocationsState{
  final List<MyLocation> myLocations;
  final NetWorkFailure? failure;
  final MyLocationStatus status;

  factory MyLocationsState.initial()=> MyLocationsState(status: MyLocationStatus.loading);
  factory MyLocationsState.loading()=> MyLocationsState(status: MyLocationStatus.loading);
  factory MyLocationsState.loaded({required List<MyLocation> myLocations})=> MyLocationsState(status: MyLocationStatus.loaded, myLocations: myLocations);




  MyLocationsState({this.failure, required this.status, this.myLocations = const []}){}
  
}