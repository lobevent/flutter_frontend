import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_dtos.dart';

class InvitationRemoteService extends RemoteService<InvitationDto>{

  static const String getInvitationsRoute = "/user/invitations/%amount%/%lastEventTime%/%descending%";

  final SymfonyCommunicator client;

  InvitationRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();

  Future<List<InvitationDto>> getInvitations(
      DateTime lastEventTime, int amount,
      [bool descending = false]) async{
        return convertList(await client.get(getInvitationsRoute.interpolate({'amount': amount.toString(), 'lastEventTime': lastEventTime.toString(), 'descending': descending? '1' : '0'})));
  }
}