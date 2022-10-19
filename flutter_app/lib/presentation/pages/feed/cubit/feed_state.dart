part of 'feed_cubit.dart';

/// ATTTENTION THIS Class has to be updated entirely if something new comes in
class FeedState {
  FeedState(
      {this.isLoading = false,
      Option<String>? error,
      EventsAndPostsCarrier? eventAndPostCarrier,
      bool? isLoadingNew,
      bool? endReached}) {
    this.error = error ?? this.error;
    this.eventAndPostCarrier = eventAndPostCarrier ?? this.eventAndPostCarrier;
    this.isLoadingNew = isLoadingNew ?? this.isLoadingNew;
    this.endReached = endReached ?? this.endReached;
  } // you have to update the constructor

  bool endReached = false;
  bool isLoadingNew = false;
  bool isLoading = false;
  Option<String> error = none();
  EventsAndPostsCarrier eventAndPostCarrier = EventsAndPostsCarrier();

  FeedState copywith(
      {bool? isLoading,
      Option<String>? error,
      EventsAndPostsCarrier? eventAndPostCarrier,
      bool? isLoadingNew,
      bool? endReached}) {
    // and ofcourse the copywith method if you want to be happy
    return FeedState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        eventAndPostCarrier: eventAndPostCarrier ?? this.eventAndPostCarrier,
        isLoadingNew: isLoadingNew,
        endReached: endReached);
  }
}
