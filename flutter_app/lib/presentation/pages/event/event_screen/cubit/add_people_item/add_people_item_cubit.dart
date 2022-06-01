import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../domain/core/failures.dart';
import '../../../../../../domain/event/event.dart';
import '../../../../../../domain/profile/profile.dart';

part 'add_people_item_cubit.freezed.dart';
part 'add_people_item_state.dart';

class AddPeopleItemCubit extends Cubit<AddPeopleItemState> {
  final Event event;
  AddPeopleItemCubit(this.event) : super(AddPeopleItemState.loadingPeople()) {
    getParticipants(event);
  }

  ProfileRepository profileRepository = GetIt.I<ProfileRepository>();

  Future<void> getParticipants(Event event) async {
    this.profileRepository.getAttendingProfiles(amount: 10, event: event).then(
        (particisOrFailure) =>
            // fold the response as it could be an failure
            particisOrFailure.fold(
                // on failure emit an errorstate
                (failure) => emit(AddPeopleItemState.error(failure: failure)),
                // if everything went right the user can precede with adding friends
                (particis) =>
                    emit(AddPeopleItemState.loadedPeople(people: particis))));
  }
}
