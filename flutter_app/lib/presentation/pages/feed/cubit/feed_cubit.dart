import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/application/core/geo_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../application/core/geo_functions_cubit.dart';
import '../../../../domain/event/event.dart';
import '../../../../domain/feed/event_and_post_carrier.dart';
import '../../../../infrastructure/event/event_repository.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState()) {
    loadFeedReal();
    controller.addListener(_scrollListener);
  }
  EventRepository repository = GetIt.I<EventRepository>();
  ScrollController controller = ScrollController();
  DateTime lastLoadedDate = DateTime.now();

/*  Future<void> loadFeed() async {
    state.isLoading = true;
    emit(state);
    repository.getFeed(lastPostTime: DateTime.now(), amount: 20).then((value) => value.fold(
            // (failure) {
            //   state.isLoading = false;
            //   state.error = some(failure.toString());
            //   emit(state);
            // },
            // (posts) {
            //   state.isLoading = false;
            //   state.posts = posts;
            //   emit(state);
            // }));
        (failure) {
          emit(state.copywith(isLoading: false, error: some(failure.toString())));
        },
            (events) {
          emit(state.copywith(isLoading: false, events: events));
        }));
  }

 */

  Future<void> loadFeedReal() async {
    state.isLoading = true;
    emit(state);
    final Position? position =
        await GeoFunctions().checkIfNeedToFetchPosition(5);
    repository
        .getFeedPostsEvents(
            position!.latitude, position.longitude, 5, 30, DateTime.now())
        .then((value) => value.fold(
                // (failure) {
                //   state.isLoading = false;
                //   state.error = some(failure.toString());
                //   emit(state);
                // },
                // (posts) {
                //   state.isLoading = false;
                //   state.posts = posts;
                //   emit(state);
                // }));
                (failure) {
              emit(state.copywith(
                  isLoading: false, error: some(failure.toString())));
            }, (eventAndPostCarrier) {

              emit(state.copywith(
                  isLoading: false, eventAndPostCarrier: eventAndPostCarrier));
            }));
  }

  /*
  Future<void> loadMore() async{
    // if(lastLoadedDate.toIso8601String() == state.posts.last.creationDate.toIso8601String()){
    //   return;
    // }
    emit(state.copywith(isLoadingNew: true));
    repository.getFeed(lastPostTime: state.events.last.creationDate, amount: 2).then((value) => value.fold(
      (failure) {
          emit(state.copywith(isLoadingNew: false, error: some(failure.toString())));
        },
      (events) {
        if(events.length == 0){
          emit(state.copywith(endReached: true));
        }else {
            state.events.addAll(events);
            emit(state.copywith(isLoadingNew: false, events: state.events));
          }
        }));
    //this.lastLoadedDate = state.posts.last.creationDate;
  }

   */

  //TODO:add scrolllistener and pagination in backend
  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (!state.endReached) {
        //loadMore();
      }
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {}
  }
}
