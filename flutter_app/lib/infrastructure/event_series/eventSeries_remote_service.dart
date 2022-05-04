import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_dtos.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

class EventSeriesRemoteService extends RemoteService<EventSeriesDto>{

  static const String getInvitationsRoute = "/user/invitations/%amount%/%lastEventTime%/%descending%";
  static const String sendInvitationRoute = "/invitation/%eventId%/%profileId%/%addHost%";
  static const String revokeInvitationRoute = "/invitation/%eventId%/%profileId%";

  final SymfonyCommunicator client;

  EventSeriesRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();

  Future<List<EventSeriesDto>> getEventSeries(
      DateTime lastEventTime, int amount,
      [bool descending = false]) async{
        return convertList(await client.get(getInvitationsRoute.interpolate({'amount': amount.toString(), 'lastEventTime': lastEventTime.toString(), 'descending': descending? '1' : '0'})));
  }

  Future<EventSeriesDto> addSeries(EventSeriesDto seriesDto) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.post(sendInvitationRoute, jsonEncode(seriesDto.toJson()))).body) as Map<String, dynamic>);
  }


  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // -------------------------------------------------------------------------------- SUBSCRIPTION MANAGEMENT ------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<EventSeriesDto> addSubscription(String seriesId) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.post(sendInvitationRoute.interpolate({'seriesId': seriesId}), {})).body) as Map<String, dynamic>);
  }


  Future<EventSeriesDto> revokeSubscription(String seriesId) async{
    return EventSeriesDto.fromJson(jsonDecode((await this.client.delete(revokeInvitationRoute.interpolate({'seriesId': seriesId}))).body) as Map<String, dynamic>);
  }
}