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

enum EventOptions{ invitations, attending }
class EopSingleTabBasicCubit extends Cubit<EopSingleTabBasicState> {

  EopSingleTabBasicCubit({required this.eventOption}) : super(EopSingleTabBasicState(events: [], status: Status.loading)) {
    loadEvents();
  }


  EventOptions eventOption;
  EventRepository repository = GetIt.I<EventRepository>();
  InvitationRepository invRepo = GetIt.I<InvitationRepository>();

  Future<void> loadEvents() async{
    (await _eventsLoadingFunction(DateTime.now(), 30))
        .fold(
            (l) => emit(state.copyWith(failure: l, status: Status.failure)),
            (r) => emit(state.copyWith(status: Status.success, events: r))
    );
  }





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
