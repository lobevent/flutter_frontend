import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';

class EventRemoteService{
  final String _EVENTBYIDPATH = "/event/{{id}}";
  final String _OWNEDEVENTSPATH = "/user/events";
  final String _PROFILEEVENTPATH = "/user/events";
  final String _ATTENDINGEVENTSPATH = "/user/eventStatus";
  final String _UNREACTEDEVENTSPATH = "/event";


  SymfonyCommunicator client;

  EventRemoteService(){
    client = SymfonyCommunicator(jwt: null);
  }

  Future<EventDto> getSingleEvent(int id) async{
      String uri = _EVENTBYIDPATH+id.toString();
      Response response = await client.get(uri);
      EventDto eventDto =
      EventDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      return eventDto;
  }

  Future<List<EventDto>> getOwnedEvents() async{
    return _getEventList(_OWNEDEVENTSPATH);
  }

  Future<List<EventDto>> getAttendingEvents() async{
    return _getEventList(_ATTENDINGEVENTSPATH);
  }

  Future<List<EventDto>> getUnreactedEvents() async{
    return _getEventList(_UNREACTEDEVENTSPATH);
  }

  Future<>









  Future<List<EventDto>> _getEventList(String path) async{
    Response response = await client.get(path);
    List<EventDto> events= (jsonDecode(response.body) as List<Map<String, dynamic>>)
        .map((e) => EventDto.fromJson(e)).toList();

    return events;
  }


//  Future<List<EventDto>> getViewableEventsFromProfile(int ProfileId){
//
//  }



}