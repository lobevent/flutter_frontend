part of 'event_form_cubit.dart';


@freezed
class EventFormState with _$EventFormState {

  const factory EventFormState({
    required Event event,
    required bool showErrorMessages,
    required bool isEditing,
    required bool isSaving,
    required bool isLoading,
    required Option<NetWorkFailure> eventFailure,
    required Option<Either<NetWorkFailure, Unit>> saveFailureOrSuccessOption,
    required List<Profile> friends,
  }) = _EventFormStateMain;


  factory EventFormState.initial() => EventFormState(
    event: Event.empty(),
    isEditing: false,
    isSaving: false,
    isLoading: false,
    showErrorMessages: false,
    eventFailure: none(),
    saveFailureOrSuccessOption: none(), friends: []
  );

  factory EventFormState.loaded(Event event) => EventFormState(
      event: event,
      isEditing: true,
      isSaving: false,
      isLoading: false,
      showErrorMessages: false,
      eventFailure: none(),
      saveFailureOrSuccessOption: none(), friends: []
  );

  factory EventFormState.error(NetWorkFailure failure) => EventFormState(
      event: Event.empty(),
      isEditing: true,
      isSaving: false,
      isLoading: false,
      showErrorMessages: false,
      eventFailure: some(failure),
      saveFailureOrSuccessOption: none(), friends: []
  );

  factory EventFormState.loading() => EventFormState(
      event: Event.empty(),
      isEditing: true,
      isSaving: false,
      isLoading: true,
      showErrorMessages: false,
      eventFailure: none(),
      saveFailureOrSuccessOption: none(), friends: []
  );

  factory EventFormState.friendsLoaded() => EventFormState(
      event: Event.empty(),
      isEditing: false,
      isSaving: false,
      isLoading: false,
      showErrorMessages: false,
      eventFailure: none(),
      saveFailureOrSuccessOption: none(), friends: [],

  );


}

