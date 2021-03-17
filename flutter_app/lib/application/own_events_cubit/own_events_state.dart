part of 'own_events_cubit.dart';



@freezed
abstract class OwnEventsState with _$OwnEventsState {
  const factory OwnEventsState({
    @required List<Event> ownEventsList,
    @required bool showErrorMessages,
    @required bool isLoading,
    @required Option<Either<EventFailure, Unit>> saveFailureOrSuccessOption
  }) = _OwnEventsState;


  factory OwnEventsState.initial() = _Initial;


  factory OwnEventsState.loading() = _LoadInProgress;

  factory OwnEventsState.loaded({@required List<Event> events}) = _Loaded;

  factory OwnEventsState.error({@required  Option<Either<EventFailure, Unit>> saveFailureOrSuccessOption}) = _LoadFailure;
}




