
import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:http/http.dart';

import '../core/symfony_communicator.dart';
import 'event_profile_picture_dtos.dart';

class EventProfilePictureRemoteService extends RemoteService<EventProfilePictureDto>{
  static const getEPPFromEvent = "/epp/event/%id%";
  static const deleteEpp = "/epp/%id%";


  final SymfonyCommunicator client;

  EventProfilePictureRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();


  Future<EventProfilePictureDto> delete(String EppId) async{
    Response response = await client.delete(deleteEpp.interpolate({"id": EppId}));
    return EventProfilePictureDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }


  Future<List<EventProfilePictureDto>> getFromEvent(String eventId) async{
    return _getList(getEPPFromEvent.interpolate({"id": eventId}));
  }



  Future<List<EventProfilePictureDto>> _getList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }


}