part of 'feed_cubit.dart';

/// ATTTENTION THIS Class has to be updated entirely if something new comes in
class FeedState {
  FeedState({this.isLoading = false, Option<String>? error, List<Event>? events, bool? isLoadingNew, bool? endReached}){
    this.error = error?? this.error;
    this.events = events?? this.events;
    this.isLoadingNew = isLoadingNew?? this.isLoadingNew;
    this.isLoadingNew = isLoadingNew?? this.isLoadingNew;
    this.endReached = endReached?? this.endReached;
  } // you have to update the constructor

  bool endReached = false;
  bool isLoadingNew = false;
  bool isLoading = false;
  Option<String> error = none();
  List<Event> events = [];


  FeedState copywith({bool? isLoading, Option<String>? error, List<Event>? events, bool? isLoadingNew, bool? endReached}){ // and ofcourse the copywith method if you want to be happy
    return FeedState(isLoading: isLoading?? this.isLoading, error: error??this.error, events: events??this.events, isLoadingNew: isLoadingNew, endReached: endReached);
  }
}

