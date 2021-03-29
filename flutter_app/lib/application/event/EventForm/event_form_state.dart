part of 'event_form_cubit.dart';


@freezed
class EventFormState with _$EventFormState {

  const factory EventFormState({
    required Event event,
    required bool showErrorMessages,
    required bool isEditing,
    required bool isSaving,
    required bool isLoading,
    required Option<EventFailure> eventFailure,
    required Option<Either<EventFailure, Unit>> saveFailureOrSuccessOption
  }) = _EventFormStateMain;


  factory EventFormState.initial() => EventFormState(
    event: Event.empty(),
    isEditing: false,
    isSaving: false,
    isLoading: false,
    showErrorMessages: false,
    eventFailure: none(),
    saveFailureOrSuccessOption: none()
  );

  factory EventFormState.loaded(Event event) => EventFormState(
      event: event,
      isEditing: true,
      isSaving: false,
      isLoading: false,
      showErrorMessages: false,
      eventFailure: none(),
      saveFailureOrSuccessOption: none()
  );

  factory EventFormState.error(EventFailure failure) => EventFormState(
      event: Event.empty(),
      isEditing: true,
      isSaving: false,
      isLoading: false,
      showErrorMessages: false,
      eventFailure: some(failure),
      saveFailureOrSuccessOption: none()
  );

  factory EventFormState.loading() => EventFormState(
      event: Event.empty(),
      isEditing: false,
      isSaving: false,
      isLoading: true,
      showErrorMessages: false,
      eventFailure: none(),
      saveFailureOrSuccessOption: none()
  );




}

