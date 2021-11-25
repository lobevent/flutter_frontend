import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'profile_search_cubit.freezed.dart';
part 'profile_search_state.dart';

class ProfileSearchCubit extends Cubit<ProfileSearchState> {
  ProfileSearchCubit() : super(ProfileSearchState.initial());

  ProfileRepository repository = GetIt.I<ProfileRepository>();
  EventRepository eventRepository = GetIt.I<EventRepository>();

  //search profiles, by string profilename and emit new states
  Future<void> searchByProfileName(String profileName) async {
    try {
      emit(ProfileSearchState.loading());
      final Either<NetWorkFailure, List<Profile>> profileList = await repository
          .getSearchProfiles(searchString: profileName, amount: 10);
      emit(ProfileSearchState.loadedProfiles(
          profiles: profileList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(ProfileSearchState.error(error: e.toString()));
    }
  }

  Future<void> searchByEventName(String eventName) async {
    try {
      emit(ProfileSearchState.loading());
      final Either<NetWorkFailure, List<Event>> eventList =
          await eventRepository.searchEvent(DateTime.now(), 10, eventName);
      emit(ProfileSearchState.loadedEvents(
          events: eventList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(ProfileSearchState.error(error: e.toString()));
    }
  }

  Future<void> searchByBothName(String queryName) async {
    try {
      emit(ProfileSearchState.loading());
      final Either<NetWorkFailure, List<Event>> eventList =
          await eventRepository.searchEvent(DateTime.now(), 10, queryName);
      final Either<NetWorkFailure, List<Profile>> profileList = await repository
          .getSearchProfiles(amount: 10, searchString: queryName);
      emit(ProfileSearchState.loadedBoth(
          profiles: profileList.fold((l) => throw Exception, (r) => r),
          events: eventList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(ProfileSearchState.error(error: e.toString()));
    }
  }

  Future<void> loadProfile(String id) async {
    repository.getSingleProfile(UniqueId.fromUniqueString(id)).then((value) =>
        value.fold(
            (failure) =>
                emit(ProfileSearchState.error(error: failure.toString())),
            (profile) => profile)); //todo emit to profilepage
  }

  Future<String> sendFriendship(UniqueId id) async {
    final String answer = await repository.sendFriendRequest(id);
    return answer;
  }

  Future<bool> isFriend(UniqueId id) async {
    return true;
  }
}
