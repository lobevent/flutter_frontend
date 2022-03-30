import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';

class EventRemoteService extends RemoteService<EventDto> {
  static const String eventByIdPath = "/event/";

  //Routes Lists
  static const String ownedEventsPath =
      "/user/events/%amount%/%lastEventTime%/%descending%";
  static const String profileEventPath =
      "/profile/events/%profileId%/%amount%/%lastEventTime%/%descending%";
  static const String invitedEventsPath =
      "/user/events/invited/%amount%/%lastEventTime%/%descending%";
  static const String attendingEventsPath =
      "/user/eventStatus/events/%amount%/%lastEventTime%/"; //TODO attending?
  static const String unreactedEventsPath =
      "/user/events/%amount%/%lastEventTime%/"; //TODO reaction?
  static const String searchEventsPath =
      "/event/search/%needle%/%amount%/%last%/";
  //event search name maxresults last

  // TODO combine it to event path?
  static const String postPath = "/event";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/edit/";
  static const String changeStatusPath = "/user/eventStatus/%eventId%/%status%";

  static const String uploadImage = '/event/uploadImage/%eventId%';

  final SymfonyCommunicator client;

  EventRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
            SymfonyCommunicator(); // TODO this doesn't work on runtime -> will throw an error!

  Future<EventDto> getSingle(UniqueId id) async {
    final String uri = "$eventByIdPath${id.value}";
    final Response response = await client.get(uri);
    final EventDto eventDto = await _decodeEvent(
        response); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    return eventDto;
  }

  Future<List<EventDto>> getOwnedEvents(DateTime lastEventTime, int amount,
      [bool descending = false]) async {
    return _getEventList(ownedEventsPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending.toString()
    }));
  }

  Future<List<EventDto>> getSearchedEvents(
      String searchString, int amount, DateTime last) async {
    return _getEventList(searchEventsPath.interpolate({
      "needle": searchString,
      "amount": amount.toString(),
      "last": last.toString()
    }));
  }

  Future<List<EventDto>> getInvitedEvents(
      DateTime lastEventTime, int amount,
      [bool descending = false]) async {
    return _getEventList(invitedEventsPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending ? '1': '0',
    }));
  }




  Future<List<EventDto>> getEventsFromUser(
      DateTime lastEventTime, int amount, UniqueId profileId,
      [bool descending = false]) async {
    return _getEventList(profileEventPath.interpolate({
      "profileId": profileId.value,
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending.toString()
    }));
  }

  Future<List<EventDto>> getAttendingEvents(
      //TODO attending events?
      DateTime lastEventTime,
      int amount) async {
    return _getEventList(attendingEventsPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString()
    }));
  }

  Future<List<EventDto>> getUnreactedEvents(
      //TODO reaction?
      DateTime lastEventTime,
      int amount) async {
    return _getEventList(unreactedEventsPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString()
    }));
  }

  Future<EventDto> createEvent(EventDto eventDto) async {
    return _decodeEvent(
        await client.post(postPath, jsonEncode(eventDto.toJson())));
  }

  Future<EventDto> deleteEvent(EventDto eventDto) async {
    // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive

    return _decodeEvent(await client.delete("$deletePath${eventDto.id}"));
  }


  Future<EventDto> changeStatus(EventDto eventDto, EventStatus status) async {
    // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive

    return _decodeEvent(await client.put(changeStatusPath.interpolate({"eventId" : eventDto.id, "status": (EventDto.domainToDtoStatus[status] as int).toString()}), {}), 'event');
  }

  Future<EventDto> updateEvent(EventDto eventDto) async {
    return _decodeEvent(await client.put(
        "$updatePath${eventDto.id}", jsonEncode(eventDto.toJson())));
  }

  Future<void> uploadImageToEvent(String eventId, File image){
    return client.postFile(uploadImage.interpolate({"eventId": eventId}), image);
  }


  /*static String generatePaginatedRoute(
      String route, int amount, DateTime lastEventTime) {
    return "$route/$amount/$lastEventTime";
  }*/

  EventDto _decodeEvent(Response json, [String? arrayField]) {
    if(arrayField == null){
      return EventDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
    }
    else
    {
      return EventDto.fromJson(jsonDecode(json.body)[arrayField] as Map<String, dynamic>);
    }
  }

  Future<List<EventDto>> _getEventList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }

  //  Future<List<EventDto>> getViewableEventsFromProfile(int ProfileId){
  //
  //  }

}
