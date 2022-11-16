import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../domain/event/event_series_invitation.dart';
import '../../../../../domain/profile/profile.dart';
import '../../../../../infrastructure/profile/profile_repository.dart';

part 'event_series_screen_state.dart';

part 'event_series_screen_cubit.freezed.dart';

class EventSeriesScreenCubit extends Cubit<EventSeriesScreenState> {
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();
  UniqueId seriesId;

  EventSeriesScreenCubit({required this.seriesId})
      : super(EventSeriesScreenState.loading()) {
    loadEventSeries().then((value) {
      getFriends();
    });
  }

  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();

  Future<void> loadEventSeries() async {
    repository.getSeriesById(seriesId).then((series) {
      series.fold((failure) => emit(EventSeriesScreenState.failure(failure)),
          (series) => emit(EventSeriesScreenState.ready(series)));
    });
  }

  Future<void> subscribe() async {
    state.maybeMap(
        orElse: () {},
        ready: (readyState) {
          emit(EventSeriesScreenState.readyAndLoadingSubscription(
              readyState.series));
          this.repository.addSubscription(readyState.series).then((value) {
            value.fold(
                (failure) => emit(EventSeriesScreenState.failure(failure)),
                (_) {
              emit(readyState.copyWith(
                  series: readyState.series.copyWith(subscribed: true)));
            });
          });
        });
  }

  Future<void> unsubscribe() async {
    state.maybeMap(
        orElse: () {},
        ready: (readyState) {
          emit(EventSeriesScreenState.readyAndLoadingSubscription(
              readyState.series));
          this.repository.revokeSubscribtion(readyState.series).then((value) {
            value.fold(
                (failure) => emit(EventSeriesScreenState.failure(failure)),
                (_) {
              emit(readyState.copyWith(
                  series: readyState.series.copyWith(subscribed: false)));
            });
          });
        });
  }

  /// fetch friends
  Future<void> getFriends() async {
    //state.isLoadingFriends = true;
    (await this.profileRepository.getFriends(profile: null)).fold(
        (failure) => EventSeriesScreenState.failure(failure),
        // compare the complete friendlist with the invitations for this event
        // set isLoadingFriends false, as they are loaded now obviously
        (friends) {
      //state.friends = friends;
      emit(state);
    });
  }
}
