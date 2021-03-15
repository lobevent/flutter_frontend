import 'dart:convert';
import 'dart:core';

import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';


class EventRemoteService extends RemoteService<EventDto>{
  static const String eventByIdPath = "/event/";

  //Routes Lists
  static const String ownedEventsPath = "/event/%amount%/%lastEventTime%/";
  static const String profileEventPath = "/user/%profileId%/events/%amount%/%lastEventTime%/";
  static const String attendingEventsPath = "/user/eventStatus/events/%amount%/%lastEventTime%/";//TODO attending?
  static const String unreactedEventsPath = "/user/events/%amount%/%lastEventTime%/";//TODO reaction?

  // TODO combine it to event path?
  static const String postPath = "/event/";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/";

  final SymfonyCommunicator client;

  EventRemoteService({SymfonyCommunicator communicator})
      : client = communicator ??
            SymfonyCommunicator(
                jwt:
                    null); // TODO this doesn't work on runtime -> will throw an error!

  Future<EventDto> getSingle(String id) async {
    final String uri = "$eventByIdPath$id";
    final Response response = await client.get(uri);
    final EventDto eventDto = await _decodeEvent(
        response); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    return eventDto;
  }

  Future<List<EventDto>> getOwnedEvents(
      DateTime lastEventTime, int amount) async {
    return _getEventList(
        ownedEventsPath.interpolate(
            {"amount" : amount.toString(), "lastEventTime" : lastEventTime.toString()}));

  }

  Future<List<EventDto>> getEventsFromUser(
      DateTime lastEventTime, int amount, String profileId) async {
    return _getEventList(
        profileEventPath.interpolate(
          {"profileId": profileId, "amount" : amount.toString(), "lastEventTime" : lastEventTime.toString()}));
  }

  Future<List<EventDto>> getAttendingEvents(//TODO attending events?
      DateTime lastEventTime, int amount) async {
    return _getEventList(
        attendingEventsPath.interpolate(
        {"amount" : amount.toString(), "lastEventTime" : lastEventTime.toString()}));
  }

  Future<List<EventDto>> getUnreactedEvents( //TODO reaction?
      DateTime lastEventTime, int amount) async {
    return _getEventList(
        unreactedEventsPath.interpolate(
            {"amount" : amount.toString(), "lastEventTime" : lastEventTime.toString()}));
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

  /*static String generatePaginatedRoute(
      String route, int amount, DateTime lastEventTime) {
    return "$route/$amount/$lastEventTime";
  }*/

  Future<EventDto> _decodeEvent(Response json) async {
    return EventDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<List<EventDto>> _getEventList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }

//  Future<List<EventDto>> getViewableEventsFromProfile(int ProfileId){
//
//  }

}
