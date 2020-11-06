import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';

class EventRemoteService{
  static const String _eventByIdPath = "/event/{{id}}";
  static const String _ownedEventsPath = "/user/events";
  static const String _profileEventPath = "/user/events";
  static const String _attendingEventsPath = "/user/eventStatus";
  static const String _unreactedEventsPath = "/event";
  
  // TODO combine it to event path?
  static const String _postPath = "/event";
  static const String _deletePath = "/event/";

  final SymfonyCommunicator client;

  EventRemoteService({SymfonyCommunicator communicator})
    : client = communicator ?? SymfonyCommunicator(jwt: null); // TODO this doesn't work on runtime -> will throw an error!

  Future<EventDto> getSingle(int id) async {
      final String uri = "$_eventByIdPath$id"; // TODO combine string this way it's a best practice
      final Response response = await client.get(uri);
      final EventDto eventDto =
        EventDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
      return eventDto;
  }

  Future<List<EventDto>> getOwnedEvents() async {
    return _getEventList(_ownedEventsPath);
  }

  Future<List<EventDto>> getAttendingEvents() async{
    return _getEventList(_attendingEventsPath);
  }

  Future<List<EventDto>> getUnreactedEvents() async{
    return _getEventList(_unreactedEventsPath);
  }

  Future<void> createEvent(EventDto event) async { // TODO always return Future<void> instead of only void when using async this way the function can be awaited in later usage same for the next 2 methods
    client.post(_postPath, event.toJson()); //
  }

  Future<void> deleteEvent(EventDto event) async {
    // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive
    client.delete("$_deletePath${event.id}"); // TODO this way the toString function will be called automatically
    //client.delete(_deletePath + event.id.toString()); // TODO combine string this way it's a best practice
  }

  Future<void> updateEvent(EventDto event) async {
    //    client.put(uri, body)
    throw UnimplementedError();
  }








  Future<List<EventDto>> _getEventList(String path) async{
    final Response response = await client.get(path);
    final List<EventDto> events = (jsonDecode(response.body) as List<Map<String, dynamic>>) // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
        .map((e) => EventDto.fromJson(e)).toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>

    final List<Map<String, dynamic>> eventsJsonList = jsonDecode(response.body) as List<Map<String, dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return eventsJsonList.map((eventJsonMap) => EventDto.fromJson(eventJsonMap)).toList();
  }


//  Future<List<EventDto>> getViewableEventsFromProfile(int ProfileId){
//
//  }



}