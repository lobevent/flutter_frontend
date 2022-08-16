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

abstract class MyLocationsFormState {}

class MyLocationsFormInitial extends MyLocationsFormState {}
class MyLocationFormAdding extends MyLocationsFormState{
  final MyLocation location;

  MyLocationFormAdding(this.location);
}

class MyLocationFormSuccsessfullySubmitted extends MyLocationsFormState{}
class MyLocationFormError extends MyLocationsFormState{
  final NetWorkFailure failure;

  MyLocationFormError(this.failure);
}

