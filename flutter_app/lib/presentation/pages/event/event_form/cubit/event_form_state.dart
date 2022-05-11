part of 'event_form_cubit.dart';

@freezed
class EventFormState with _$EventFormState {
  const factory EventFormState({
    required Event event,
    required bool showErrorMessages,
    required bool isEditing,
    required bool isSaving,
    required bool isLoading,
    required bool isLoadingFriends,
    required bool isLoadingSeries,
    required Option<NetWorkFailure> eventFailure,
    required Option<Either<NetWorkFailure, Unit>> saveFailureOrSuccessOption,
    required List<Profile> friends,
    required List<Invitation> invitedFriends,
    required List<EventSeries> series,
    XFile? picture
  }) = _EventFormStateMain;

  factory EventFormState.initial() => EventFormState(
        event: Event.empty() as Event,
        isEditing: false,
        isSaving: false,
        isLoading: false,
        showErrorMessages: false,
        eventFailure: none(),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: false,
        isLoadingSeries: true,
        series: []
      );

  factory EventFormState.loaded(Event event) => EventFormState(
        event: event,
        isEditing: true,
        isSaving: false,
        isLoading: false,
        showErrorMessages: false,
        eventFailure: none(),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: true,
        isLoadingSeries: true,
        series: []
      );

  factory EventFormState.error(NetWorkFailure failure) => EventFormState(
        event: Event.empty() as Event,
        isEditing: true,
        isSaving: false,
        isLoading: false,
        showErrorMessages: false,
        eventFailure: some(failure),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: false,
        isLoadingSeries: true,
        series: []
      );

  factory EventFormState.loading() => EventFormState(
        event: Event.empty() as Event,
        isEditing: true,
        isSaving: false,
        isLoading: true,
        showErrorMessages: false,
        eventFailure: none(),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: true,
        isLoadingSeries: true,
        series: []
      );

  factory EventFormState.readyLoadingMeta(
          List<Profile> friends, List<Invitation> attendingFriends, Event event, List<EventSeries> series) =>
      EventFormState(
        event: event,
        isEditing: event.longitude != Event.empty().longitude &&
            event.latitude != Event.empty().latitude &&
            event.id !=
                Event.empty()
                    .id, // at the moment the best idea to check if its editing or not (without parameter)
        isSaving: false,
        isLoading: false,
        showErrorMessages: false,
        eventFailure: none(),
        saveFailureOrSuccessOption: none(),
        friends: friends,
        invitedFriends: attendingFriends,
        isLoadingFriends: false,
        isLoadingSeries: false,
        series: series
      );
}
