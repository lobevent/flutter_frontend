import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_remote_service.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_remote_service.dart';

import 'eventSeries_dtos.dart';

class EventSeriesRepository extends Repository{

  final EventSeriesRemoteService remoteService;
  EventSeriesRepository({required this.remoteService});

  Future<Either<NetWorkFailure, List<EventSeries>>> _getList(Future<List<EventSeriesDto>> Function() repocall) async {
    return localErrorHandler(() async{
      final eventSeriesDto = await repocall();
      //convert the dto objects to domain Objects
      final invitations = eventSeriesDto.map((idto) => idto.toDomain()).toList();
      return right(invitations);
    });
  }

  Future<Either<NetWorkFailure, List<EventSeries>>> getSubscribedSeries(DateTime lastEventTime, int amount, {bool descending = false}) async{
    return _getList(() => remoteService.getEventSeries(lastEventTime, amount));
  }


  Future<Either<NetWorkFailure, List<EventSeries>>> addSeries(EventSeries series) async{
    return localErrorHandler(() async {
      return right((await remoteService.addSubscription(Ev)).toDomain());
    });
  }



  // Future<Either<NetWorkFailure, List<Invitation>>> getInvitations(DateTime lastEventTime, int amount, {bool descending = false}){
  //   return _getList(() => remoteService.getInvitations(lastEventTime, amount, descending));
  // }

  Future<Either<NetWorkFailure, EventSeries>> addSubscription(EventSeries series){
    return localErrorHandler(() async {
      return right((await remoteService.addSubscription(series.id.value)).toDomain());
    });
  }
  // Future<Either<NetWorkFailure, Invitation>> revokeInvitation(Profile profile, Event event){
  //   return localErrorHandler(() async {
  //     return right(( await remoteService.revokeInvitation(profile.id.value, event.id.value)).toDomain());
  //   });
  // }
}