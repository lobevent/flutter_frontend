part of 'event_form_cubit.dart';


@freezed
abstract class EventFormState with _$EventFormState {

  const factory EventFormState({
    @required Event event,
    @required bool showErrorMessages,
    @required bool isEditing,
    @required bool isSaving,
    @required bool isLoading,
    @required Option<Either<EventFailure, Unit>> saveFailureOrSuccessOption
  }) = _EventFormState;


  factory EventFormState.initial() => EventFormState(
    event: Event.empty(),
    isEditing: false,
    isSaving: false,
    isLoading: false,
    showErrorMessages: false,
    saveFailureOrSuccessOption: none()
  );

}

