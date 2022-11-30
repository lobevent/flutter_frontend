import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:http/http.dart';

class InvitationRemoteService extends RemoteService<InvitationDto>{

  static const String getInvitationsRoute = "/user/invitations/%amount%/%lastEventTime%/%descending%";
  static const String sendInvitationRoute = "/invitation/%eventId%/%profileId%/%addHost%";
  static const String revokeInvitationRoute = "/invitation/%eventId%/%profileId%";
  static const String addHostRoute = "/addHost/%eventId%/%profileId%";

  final SymfonyCommunicator client;

  InvitationRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();

  Future<List<InvitationDto>> getInvitations(
      DateTime lastEventTime, int amount,
      [bool descending = false]) async{
        return convertList(await client.get(getInvitationsRoute.interpolate({'amount': amount.toString(), 'lastEventTime': lastEventTime.toString(), 'descending': descending? '1' : '0'})));
  }


  Future<InvitationDto> sendInvitation(String profileId, String eventId, String isHost) async{
    return InvitationDto.fromJson(
        jsonDecode((await this.client.post(
            sendInvitationRoute.interpolate({'eventId': eventId, 'profileId': profileId, 'addHost' : isHost}), {})).body) as Map<String, dynamic>);
  }

  Future<InvitationDto> revokeInvitation(String profileId, String eventId) async{
    return InvitationDto.fromJson(
        jsonDecode((await this.client.delete(
            revokeInvitationRoute.interpolate({'eventId': eventId, 'profileId': profileId}))).body) as Map<String, dynamic>);
  }

  Future<InvitationDto> addHost(String profileId, String eventId) async{
    return InvitationDto.fromJson(
        jsonDecode((await this.client.post(
            addHostRoute.interpolate({'eventId': eventId, 'profileId': profileId}), {})).body) as Map<String, dynamic>);
  }

  Future<InvitationDto> removeHost(String profileId, String eventId) async{
    return InvitationDto.fromJson(
        jsonDecode((await this.client.delete(
            addHostRoute.interpolate({'eventId': eventId, 'profileId': profileId}))).body) as Map<String, dynamic>);
  }
}