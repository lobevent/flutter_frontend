import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/helpers/event_series_own_subscribed.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event_series/helper_responses/event_series_helper_own_and_subscribed.dart';
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

  ///
  /// this function fetches all the event series that the user has subscribed to
  ///
  Future<Either<NetWorkFailure, List<EventSeries>>> getSubscribedSeries(DateTime lastEventTime, int amount, {bool descending = false}) async{
    return _getList(() => remoteService.getSubscribedEventSeries(lastEventTime, amount));
  }
  


  ///
  /// this function fetches all the event series that the user owns
  ///
  Future<Either<NetWorkFailure, List<EventSeries>>> getOwnedEventSeries( {bool descending = false, int amount = 100, DateTime? lastEventTime}) async{
    if(lastEventTime == null) lastEventTime = DateTime.now();
    return _getList(() => remoteService.getOwnedEventSeries(lastEventTime!, amount));
  }




  ///
  /// this function fetches all the event series that the user owns and all that they have subscribed
  /// the first is own, the second is subscribed
  ///
  Future<Either<NetWorkFailure, OwnAndSubscribedEventSeries>> getOwnAndSubscribedSeries() async{
    return localErrorHandler(() async{
      OwnAndSubscribedEventSeries oses = new OwnAndSubscribedEventSeries();
      final ownAndSubscribed = await remoteService.getOwnAndSubscribedSeries();
      //convert the dto objects to domain Objects
      oses.subscribed = ownAndSubscribed.subscribed.map((idto) => idto.toDomain()).toList();
      oses.own = ownAndSubscribed.own.map((idto) => idto.toDomain()).toList();
      return right(oses);
    });
  }






  // ----------------------------------------------------------------------------------------------
  // ---------------------------------------- Single Series ---------------------------------------
  // ----------------------------------------------------------------------------------------------


  Future<Either<NetWorkFailure, EventSeries>> getSeriesById(UniqueId id) async{
    return localErrorHandler(() async {
      return right((await remoteService.getSeriesById(id.value)).toDomain());
    });
  }

  ///
  /// saves an new series in the backend
  ///
  Future<Either<NetWorkFailure, EventSeries>> addSeries(EventSeries series) async{
    return localErrorHandler(() async {
      return right((await remoteService.addSeries(EventSeriesDto.fromDomain(series))).toDomain());
    });
  }

  ///
  /// saves an new series in the backend
  ///
  Future<Either<NetWorkFailure, EventSeries>> delete(EventSeries series) async{
    return localErrorHandler(() async {
      return right((await remoteService.delete(series.id.value)).toDomain());
    });
  }



  // ----------------------------------------------------------------------------------------------
  // ---------------------------------------- Subscription ----------------------------------------
  // ----------------------------------------------------------------------------------------------

  ///
  /// subscribes the current user to an eventseries
  ///
  Future<Either<NetWorkFailure, EventSeries>> addSubscription(EventSeries series){
    return localErrorHandler(() async {
      return right((await remoteService.addSubscription(series.id.value)).toDomain());
    });
  }


  ///
  /// revokes subscription of the current user to an eventseries
  ///
  Future<Either<NetWorkFailure, EventSeries>> revokeSubscribtion(EventSeries series){
    return localErrorHandler(() async {
      return right((await remoteService.revokeSubscription(series.id.value)).toDomain());
    });
  }


}