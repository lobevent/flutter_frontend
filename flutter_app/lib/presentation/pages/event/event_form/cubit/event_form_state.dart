part of 'event_form_cubit.dart';

// @freezed
// class EventFormState with _$EventFormState {
//   const factory EventFormState({
//     required Event event,
//     required bool showErrorMessages,
//     required bool isEditing,
//     required bool isSaving,
//     required bool isLoading,
//     required bool isLoadingFriends,
//     required bool isLoadingSeries,
//     required Option<NetWorkFailure> eventFailure,
//     required Option<Either<NetWorkFailure, Unit>> saveFailureOrSuccessOption,
//     required List<Profile> friends,
//     required List<Invitation> invitedFriends,
//     required List<EventSeries> series,
//     XFile? picture
//   }) = _EventFormStateMain;
//
//   factory EventFormState.initial() => EventFormState(
//         event: Event.empty() as Event,
//         isEditing: false,
//         isSaving: false,
//         isLoading: false,
//         showErrorMessages: false,
//         eventFailure: none(),
//         saveFailureOrSuccessOption: none(),
//         friends: [],
//         invitedFriends: [],
//         isLoadingFriends: false,
//         isLoadingSeries: true,
//         series: []
//       );
//
//   factory EventFormState.loaded(Event event) => EventFormState(
//         event: event,
//         isEditing: true,
//         isSaving: false,
//         isLoading: false,
//         showErrorMessages: false,
//         eventFailure: none(),
//         saveFailureOrSuccessOption: none(),
//         friends: [],
//         invitedFriends: [],
//         isLoadingFriends: true,
//         isLoadingSeries: true,
//         series: []
//       );
//
//   factory EventFormState.error(NetWorkFailure failure) => EventFormState(
//         event: Event.empty() as Event,
//         isEditing: true,
//         isSaving: false,
//         isLoading: false,
//         showErrorMessages: false,
//         eventFailure: some(failure),
//         saveFailureOrSuccessOption: none(),
//         friends: [],
//         invitedFriends: [],
//         isLoadingFriends: false,
//         isLoadingSeries: true,
//         series: []
//       );
//
//   factory EventFormState.loading() => EventFormState(
//         event: Event.empty() as Event,
//         isEditing: true,
//         isSaving: false,
//         isLoading: true,
//         showErrorMessages: false,
//         eventFailure: none(),
//         saveFailureOrSuccessOption: none(),
//         friends: [],
//         invitedFriends: [],
//         isLoadingFriends: true,
//         isLoadingSeries: true,
//         series: []
//       );
//
//   factory EventFormState.readyLoadingMeta(
//           List<Profile> friends, List<Invitation> attendingFriends, Event event, List<EventSeries> series) =>
//       EventFormState(
//         event: event,
//         isEditing: event.longitude != Event.empty().longitude &&
//             event.latitude != Event.empty().latitude &&
//             event.id !=
//                 Event.empty()
//                     .id, // at the moment the best idea to check if its editing or not (without parameter)
//         isSaving: false,
//         isLoading: false,
//         showErrorMessages: false,
//         eventFailure: none(),
//         saveFailureOrSuccessOption: none(),
//         friends: friends,
//         invitedFriends: attendingFriends,
//         isLoadingFriends: false,
//         isLoadingSeries: false,
//         series: series
//       );
// }
//

enum MainStatus {loading, saving, ready, error, formHasErrors, saved}
enum FriendsStatus {loading, ready, error}
enum SeriesStatus {loading, ready, error}

@CopyWith()
class EventFormState{
  final bool isEditing;
  final Event event;
  final bool showErrorMessages;

  final MainStatus status;
  final FriendsStatus friendStatus;
  final SeriesStatus seriesStatus;

  final List<Profile> friends;
  final List<Invitation> invitedFriends;
  final List<EventSeries> series;

  final NetWorkFailure? eventFailure;
  final NetWorkFailure? friendsFailure;
  final NetWorkFailure? seriesFailure;

  XFile? picture;

  EventFormState(
      {required this.isEditing,
      required this.event,
      required this.status,
      required this.friendStatus,
      required this.seriesStatus,
      this.friends = const [],
      this.invitedFriends = const [] ,
      this.series =  const [],
      this.picture,
      this.showErrorMessages = false,
      this.eventFailure,
      this.friendsFailure,
      this.seriesFailure,
      });


  factory EventFormState.initial({bool isEdit = false}) => EventFormState(
      event: Event.empty(),
      isEditing: isEdit,
      status: isEdit ? MainStatus.loading : MainStatus.ready,
      friendStatus: FriendsStatus.loading, seriesStatus: SeriesStatus.loading);


}