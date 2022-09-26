
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:http/http.dart';

import '../core/symfony_communicator.dart';
import 'event_profile_picture_dtos.dart';

class EventProfilePictureRemoteService extends RemoteService<EventProfilePictureDto>{
  static const getEPPFromEvent = "/epp/event/%id%";


  final SymfonyCommunicator client;

  EventProfilePictureRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();



  Future<List<EventProfilePictureDto>> getFromEvent(String eventId){
    return _getList(getEPPFromEvent.interpolate({"id": eventId}));
  }



  Future<List<EventProfilePictureDto>> _getList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }


}