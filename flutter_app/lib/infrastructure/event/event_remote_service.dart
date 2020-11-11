import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';

class EventRemoteService{
  static const String eventByIdPath = "/event/";
  static const String ownedEventsPath = "/user/events";
  static const String profileEventPath = "/user/events";
  static const String attendingEventsPath = "/user/eventStatus";
  static const String unreactedEventsPath = "/event";
  
  // TODO combine it to event path?
  static const String postPath = "/event";
  static const String deletePath = "/event/";

  final SymfonyCommunicator client;

  EventRemoteService({SymfonyCommunicator communicator})
    : client = communicator ?? SymfonyCommunicator(jwt: null); // TODO this doesn't work on runtime -> will throw an error!

  Future<EventDto> getSingle(int id) async {
      final String uri = "$eventByIdPath$id"; // TODO combine string this way it's a best practice
      final Response response = await client.get(uri);
      final EventDto eventDto = await _decodeEvent(response); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
      Map<String, dynamic> test = jsonDecode(response.body)as Map<String, dynamic>;
      return eventDto;
  }

  Future<List<EventDto>> getOwnedEvents() async {
    return _getEventList(ownedEventsPath);
  }

  Future<List<EventDto>> getAttendingEvents() async{
    return _getEventList(attendingEventsPath);
  }

  Future<List<EventDto>> getUnreactedEvents() async{
    return _getEventList(unreactedEventsPath);
  }

  Future<EventDto> createEvent(EventDto event) async { // TODO always return Future<void> instead of only void when using async this way the function can be awaited in later usage same for the next 2 methods
    return _decodeEvent( await client.post(postPath, jsonEncode(event.toJson()))); //
  }

  Future<void> deleteEvent(EventDto event) async {
    // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive
    client.delete("$deletePath${event.id}"); // TODO this way the toString function will be called automatically
    //client.delete(deletePath + event.id.toString()); // TODO combine string this way it's a best practice
  }

  Future<void> updateEvent(EventDto event) async {
    //TODO
    //    client.put(uri, body)
    throw UnimplementedError();
  }






  Future<EventDto> _decodeEvent(Response json) async {
    return EventDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<EventDto>> _getEventList(String path) async{
    final Response response = await client.get(path);
    List<EventDto> events;
    try{
      events = ((jsonDecode(response.body) as List).map((e) => e as Map<String, dynamic>)).toList()// TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
          .map((e) => EventDto.fromJson(e)).toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    } on Exception {
      throw UnexpectedFormatException();
    }

    return events;
  }


//  Future<List<EventDto>> getViewableEventsFromProfile(int ProfileId){
//
//  }



}