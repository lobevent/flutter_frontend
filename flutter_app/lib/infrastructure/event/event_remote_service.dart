import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';

class EventRemoteService {
  static const String eventByIdPath = "/event/";
  static const String ownedEventsPath = "/user/events";
  static const String profileEventPath = "/user/events";
  static const String attendingEventsPath = "/user/eventStatus";
  static const String unreactedEventsPath = "/event";

  // TODO combine it to event path?
  static const String postPath = "/event";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/";

  final SymfonyCommunicator client;

  EventRemoteService({SymfonyCommunicator communicator})
      : client = communicator ??
            SymfonyCommunicator(
                jwt:
                    null); // TODO this doesn't work on runtime -> will throw an error!

  Future<EventDto> getSingle(int id) async {
    final String uri = "$eventByIdPath$id";
    final Response response = await client.get(uri);
    final EventDto eventDto = await _decodeEvent(
        response); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    return eventDto;
  }

  Future<List<EventDto>> getOwnedEvents() async {
    return _getEventList(ownedEventsPath);
  }
  Future<List<EventDto>> getEventsFromUser() async {
    return _getEventList(profileEventPath);
  }
  Future<List<EventDto>> getAttendingEvents() async {
    return _getEventList(attendingEventsPath);
  }

  Future<List<EventDto>> getUnreactedEvents() async {
    return _getEventList(unreactedEventsPath);
  }

  Future<EventDto> createEvent(EventDto eventDto) async {
    return _decodeEvent(
        await client.post(postPath, jsonEncode(eventDto.toJson())));
  }

  Future<EventDto> deleteEvent(EventDto eventDto) async {
    // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive

    return _decodeEvent(await client.delete(
        "$deletePath${eventDto.maybeMap((value) => value.id, orElse: () => throw UnexpectedFormatException())}"));
  }

  Future<EventDto> updateEvent(EventDto eventDto) async {
    return _decodeEvent(await client.put(
        "$updatePath${eventDto.maybeMap((value) => value.id, orElse: () => throw UnexpectedFormatException())}",
        jsonEncode(eventDto.toJson())));
  }

  Future<EventDto> _decodeEvent(Response json) async {
    return EventDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<EventDto>> _getEventList(String path) async {
    final Response response = await client.get(path);
    List<EventDto> events;
    try {
      events = ((jsonDecode(response.body) as List)
              .map((e) => e as Map<String, dynamic>))
          .toList() // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
          .map((e) => EventDto.fromJson(e))
          .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    } on Exception {
      throw UnexpectedFormatException();
    }

    return events;
  }

//  Future<List<EventDto>> getViewableEventsFromProfile(int ProfileId){
//
//  }

}
