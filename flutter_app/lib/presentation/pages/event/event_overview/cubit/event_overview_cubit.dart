import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/application/core/geo_functions_cubit.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_overview_state.dart';
part 'event_overview_cubit.freezed.dart';

class EventOverviewCubit extends Cubit<EventOverviewState> {
  EventRepository repository = GetIt.I<EventRepository>();
  InvitationRepository invRepo = GetIt.I<InvitationRepository>();
  
  double searchDistanceKm = 5;

  EventOverviewCubit() : super(EventOverviewState.loading()){
    loadEvents();
  }

  
  ///
  /// loads all events (attending, local, invited)
  /// emits failure state if one of the requests fails
  /// 
  Future<void> loadEvents() async{
    List<Event>? eventsListAttending;
    List<Event>? eventsListLocal;
    List<Event>? eventsInvited;
    NetWorkFailure? failure = null;


    emit(EventOverviewState.loading());
    Position? position = await _getLocalPosition();

    //-------------------------------------------------------------------------
    // -------------------- get local events ----------------------------------
    //-------------------------------------------------------------------------
    (await repository.getNearEvents(position!.latitude, position.longitude, searchDistanceKm.ceil(), DateTime.now(), 30))
        .fold(
            (l) => failure = l,
            (r) => eventsListLocal = r
    );


    //-------------------------------------------------------------------------
    //-------------------------- Get attending Events -------------------------
    //-------------------------------------------------------------------------
    (await repository.getAttendingEvents(DateTime.now(), 30)).fold((l) => failure = l, (r) => eventsListAttending = r);


    //-------------------------------------------------------------------------
    //-------------------------- Get invitations ------------------------------
    //-------------------------------------------------------------------------
    (await invRepo.getInvitations(DateTime.now(), 30, descending: false)).fold((l) => failure = l, (r) => eventsInvited = _mapInvitesUESToEvents(r));

    if(failure != null){
      emit(EventOverviewState.failure(failure: failure!));
      return;
    }


    emit(EventOverviewState.loaded(invited_events: eventsInvited!, attending_events: eventsListAttending!, local: eventsListLocal!));

  }

  Future<void> reloadLocal() async{

    state.maybeMap(orElse: (){}, loaded: (loadedState)async{
      emit(EventOverviewState.loading());
      Position? position = await _getLocalPosition();

      // repository call and emit errorstate or loadedstate with the new local events
      (await repository.getNearEvents(position!.latitude, position.longitude, searchDistanceKm.ceil(), DateTime.now(), 30))
          .fold(
              (l) => emit(EventOverviewState.failure(failure: l)),
              (r) => emit(loadedState.copyWith(local: r)));
    });

  }


  // ------------------------------------------------------------------------------------------
  // ----------------------------- getters and setters ----------------------------------------
  // ------------------------------------------------------------------------------------------

  double getSearchDistatnce(){
    return searchDistanceKm;
  }

  void setSearchDistanceAndUpdate(double searchDistance){
    searchDistanceKm = searchDistance;
    reloadLocal();
  }

  void setSearchDistance(double searchDistance){
    searchDistanceKm = searchDistance;
  }


  // ------------------------------------------------------------------------------------------
  // ----------------------------- private methods --------------------------------------------
  // ------------------------------------------------------------------------------------------


  ///
  /// get device position
  ///
  Future<Position?> _getLocalPosition() async{
    final geof = GeoFunctionsCubit(event: null);
    Position? position;
    await geof.checkUserPosition();
    geof.state.maybeMap(
        loaded: (loadedState) {
          position = loadedState.position;
        },
        orElse: () {});
    return position;
  }

  List<Event> _mapInvitesUESToEvents(List<Invitation> invitations){
    List<Invitation> invitationsCleaned = _checkForEmptyInvitations(invitations);
    return invitationsCleaned.map((e) => e.event!.copyWith(status: e.userEventStatus)).toList();
  }

  List<Invitation> _checkForEmptyInvitations(List<Invitation> invitations){
    List<Invitation> invitationsMutable = List.of(invitations);
    invitationsMutable.removeWhere((invite) => invite.event == null);
    return invitationsMutable;
  }
  
  
  



}
