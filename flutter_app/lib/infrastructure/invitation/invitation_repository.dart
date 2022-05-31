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

  Future<Either<NetWorkFailure, Invitation>> sendInvitation(Profile profile, Event event, bool isHost){
    return localErrorHandler(() async {
      return right((await remoteService.sendInvitation(profile.id.value, event.id.value, isHost ? '1' : '0')).toDomain());
    });
  }
  Future<Either<NetWorkFailure, Invitation>> revokeInvitation(Profile profile, Event event){
    return localErrorHandler(() async {
      return right(( await remoteService.revokeInvitation(profile.id.value, event.id.value)).toDomain());
    });
  }


  Future<Either<NetWorkFailure, Invitation>> addHost(Profile profile, Event event){
    return localErrorHandler(() async {
      return right(( await remoteService.addHost(profile.id.value, event.id.value)).toDomain());
    });
  }
}