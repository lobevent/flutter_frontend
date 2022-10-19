import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../../../domain/event/event.dart';

part 'eop_single_tab_basic_state.dart';


// ********************************************************************************************************************
//********************************** HELPER CLASSES TO DISTINGUISH THE CORRECT CUBIT **********************************
// ********************************************************************************************************************

class InvitedEOPSingleTabCubit extends EopSingleTabBasicCubit{
  InvitedEOPSingleTabCubit() : super(eventOption: EventOptions.invitations);
}

class AttendingEOPSingleTabCubit extends EopSingleTabBasicCubit{
  AttendingEOPSingleTabCubit() : super(eventOption: EventOptions.attending);
}

//************************************* those are for the recent cubits, in this way the other cubits are preserved, and we have much less boilerplate **********************************
class Recent_InvitedEOPSingleTabCubit extends EopSingleTabBasicCubit{
  Recent_InvitedEOPSingleTabCubit() : super(eventOption: EventOptions.invitations, isRecent: true);
}

class Recent_AttendingEOPSingleTabCubit extends EopSingleTabBasicCubit{
  Recent_AttendingEOPSingleTabCubit() : super(eventOption: EventOptions.attending, isRecent: true);
}


/// EventOptions provide the correct repository and the for it
/// they determine which events are loaded
enum EventOptions{ invitations, attending }

class EopSingleTabBasicCubit extends Cubit<EopSingleTabBasicState> {

  EopSingleTabBasicCubit({required this.eventOption, this.isRecent = false}) : super(EopSingleTabBasicState(events: [], status: Status.loading)) {
    loadEvents();
  }


  bool isRecent;
  EventOptions eventOption;
  EventRepository repository = GetIt.I<EventRepository>();
  InvitationRepository invRepo = GetIt.I<InvitationRepository>();

  ///
  /// this function loads the initial events
  ///
  Future<void> loadEvents() async{
    emit(state.copyWith(status: Status.loading));
    (await _eventsLoadingFunction(DateTime.now(), 30, descending: isRecent))
        .fold(
            (l) => emit(state.copyWith(failure: l, status: Status.failure)),
            (r) => emit(state.copyWith(status: Status.success, events: r))
    );
  }






  ///
  /// provides the correct repository function depending on whether the events should be loaded from invitations or attending events
  ///
  Future<Either<NetWorkFailure, List<Event>>> _eventsLoadingFunction(DateTime dateTime, int amount, {bool descending = false}){
    switch (eventOption){
      case EventOptions.invitations:
        return invRepo.getInvitationsAsEvents(dateTime, amount, descending: descending);
        break;
      case EventOptions.attending:
        return repository.getAttendingEvents(dateTime, amount, descending: descending);
        break;
    }
  }

}


