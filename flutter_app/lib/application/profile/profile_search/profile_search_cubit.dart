import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart' as ev;
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';

part 'profile_search_state.dart';
part 'profile_search_cubit.freezed.dart';

class ProfileSearchCubit extends Cubit<ProfileSearchState> {
  ProfileSearchCubit() : super(ProfileSearchState.initial());

  ProfileRepository repository = GetIt.I<ProfileRepository>();
  EventRepository eventRepository = GetIt.I<EventRepository>();

  //search profiles, by string profilename and emit new states
  Future<void> searchByProfileName(String profileName) async {
    try {
      emit(ProfileSearchState.loading());
      final Either<ProfileFailure, List<Profile>> profileList = await repository
          .getList(Operation.search, 10, searchString: profileName);
      emit(ProfileSearchState.loaded(
          profiles: profileList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(ProfileSearchState.error(error: e.toString()));
    }
  }

  Future<void> searchByEventName(String eventName) async {
    try {
      emit(ProfileSearchState.loading());
      final Either<EventFailure, List<Event>> eventList = await eventRepository
          .getList(ev.Operation.search, DateTime.now(), 10);
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
}
