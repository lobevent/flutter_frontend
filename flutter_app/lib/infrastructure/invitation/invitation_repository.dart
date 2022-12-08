import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_remote_service.dart';

import 'invitation_dtos.dart';

class InvitationRepository extends Repository{

  final InvitationRemoteService remoteService;
  InvitationRepository({required this.remoteService});

  Future<Either<NetWorkFailure, List<Invitation>>> _getList(Future<List<InvitationDto>> Function() repocall) async {
    return localErrorHandler(() async{
      final eventDtos = await repocall();
      //convert the dto objects to domain Objects
      final invitations = eventDtos.map((idto) => idto.toDomain()).toList();
      return right(invitations);
    });
  }

  Future<Either<NetWorkFailure, List<Invitation>>> getInvitations(DateTime lastEventTime, int amount, {bool descending = false}){
    return _getList(() => remoteService.getInvitations(lastEventTime, amount, descending));
  }

  Future<Either<NetWorkFailure, List<Event>>> getInvitationsAsEvents(DateTime lastEventTime, int amount, {bool descending = false})async{
    return _mapInvitesUESToEvents(await _getList(() => remoteService.getInvitations(lastEventTime, amount, descending)));
  }

  Future<Either<NetWorkFailure, Invitation>> sendInvitation(Profile profile, String eventId, bool isHost){
    return localErrorHandler(() async {
      return right((await remoteService.sendInvitation(profile.id.value, eventId, isHost ? '1' : '0')).toDomain());
    });
  }
  Future<Either<NetWorkFailure, Invitation>> revokeInvitation(Profile profile, String eventId){
    return localErrorHandler(() async {
      return right(( await remoteService.revokeInvitation(profile.id.value, eventId)).toDomain());
    });
  }


  Future<Either<NetWorkFailure, Invitation>> addHost(Profile profile, String eventId){
    return localErrorHandler(() async {
      return right(( await remoteService.addHost(profile.id.value, eventId)).toDomain());
    });
  }



  Future<Either<NetWorkFailure, Invitation>> removeHost(Profile profile, String eventId){
    return localErrorHandler(() async {
      return right(( await remoteService.removeHost(profile.id.value, eventId)).toDomain());
    });
  }



  //**************************************************************************************************************
  //****************************  Helper Methods and Transformers   **********************************************
  //**************************************************************************************************************

  ///
  /// maps the ues to the events in the list and returns the invitations as events
  ///
  Either<NetWorkFailure, List<Event>> _mapInvitesUESToEvents(Either<NetWorkFailure, List<Invitation>> invitationsOrFailure){
    return invitationsOrFailure.fold(
            (l) => left(l),
            (invitations) {
              List<Invitation> invitationsCleaned = _checkForEmptyInvitations(invitations);
              return right(invitationsCleaned.map((e) => e.event!.copyWith(status: e.userEventStatus)).toList());
            });
  }

  ///
  /// if in the list of invitations is one without an event, it removes it from the list
  /// 
  List<Invitation> _checkForEmptyInvitations(List<Invitation> invitations){
    List<Invitation> invitationsMutable = List.of(invitations);
    invitationsMutable.removeWhere((invite) => invite.event == null);
    return invitationsMutable;
  }

}