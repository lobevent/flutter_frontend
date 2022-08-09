part of 'my_locations_cubit.dart';

@immutable
abstract class MyLocationsState {}

class MyLocationsInitial extends MyLocationsState {}
class MyLocationsLoading extends MyLocationsState {}
class MyLocationsLoaded extends MyLocationsState {
  final List<MyLocation> myLocations;
  MyLocationsLoaded(this.myLocations);
}
class MyLocationsError extends MyLocationsState {
  final NetWorkFailure failure;
  MyLocationsError(this.failure);
}
