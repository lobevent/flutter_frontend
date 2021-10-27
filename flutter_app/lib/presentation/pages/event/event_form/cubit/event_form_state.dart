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
    required Option<NetWorkFailure> eventFailure,
    required Option<Either<NetWorkFailure, Unit>> saveFailureOrSuccessOption,
    required List<Profile> friends,
    required List<Profile> invitedFriends,
  }) = _EventFormStateMain;

  factory EventFormState.initial() => EventFormState(
        event: Event.empty(),
        isEditing: false,
        isSaving: false,
        isLoading: false,
        showErrorMessages: false,
        eventFailure: none(),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: false,
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
        isLoadingFriends: false,
      );

  factory EventFormState.error(NetWorkFailure failure) => EventFormState(
        event: Event.empty(),
        isEditing: true,
        isSaving: false,
        isLoading: false,
        showErrorMessages: false,
        eventFailure: some(failure),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: false,
      );

  factory EventFormState.loading() => EventFormState(
        event: Event.empty(),
        isEditing: true,
        isSaving: false,
        isLoading: true,
        showErrorMessages: false,
        eventFailure: none(),
        saveFailureOrSuccessOption: none(),
        friends: [],
        invitedFriends: [],
        isLoadingFriends: false,
      );

  factory EventFormState.friendsLoaded(
          List<Profile> friends, List<Profile> attendingFriends, Event event) =>
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
      );
}
