import 'dart:convert';

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_dtos.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

class EventSeriesRemoteService extends RemoteService<EventSeriesDto>{


  static const String getSubscribedESRoute = "";
  static const String getSeriesByIdRoute = "/series/%seriesId%";
  static const String getOwnSeriesRoute = "/eventSeries/%amount%/%lastEventTime%/%descending%";
  static const String addSeriesRoute = "/eventSeries";
  static const String addSubscriptionRoute = "/eventSeries/subscription/%seriesId%";
  static const String revokeSubscriptionRoute = "/eventSeries/subscription/%seriesId%";

  final SymfonyCommunicator client;

  EventSeriesRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();

  Future<List<EventSeriesDto>> getSubscribedEventSeries(
      DateTime lastEventTime, int amount,
      [bool descending = false]) async{
        return convertList(await client.get(getSubscribedESRoute.interpolate({'amount': amount.toString(), 'lastEventTime': lastEventTime.toString(), 'descending': descending? '1' : '0'})));
  }

  Future<List<EventSeriesDto>> getOwnedEventSeries(
      DateTime lastEventTime, int amount,
      [bool descending = false]) async{
        return convertList(await client.get(getOwnSeriesRoute.interpolate({'amount': amount.toString(), 'lastEventTime': lastEventTime.toString(), 'descending': descending? '1' : '0'})));
  }

  Future<EventSeriesDto> addSeries(EventSeriesDto seriesDto) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.post(addSeriesRoute, jsonEncode(seriesDto.toJson()))).body) as Map<String, dynamic>);
  }

  Future<EventSeriesDto> getSeriesById(String id) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.get(getSeriesByIdRoute.interpolate({'seriesId': id}))).body) as Map<String, dynamic>);
  }


  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // -------------------------------------------------------------------------------- SUBSCRIPTION MANAGEMENT ------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<EventSeriesDto> addSubscription(String seriesId) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.post(addSubscriptionRoute.interpolate({'seriesId': seriesId}), {})).body) as Map<String, dynamic>);
  }


  Future<EventSeriesDto> revokeSubscription(String seriesId) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.delete(revokeSubscriptionRoute.interpolate({'seriesId': seriesId}))).body) as Map<String, dynamic>);
  }
}