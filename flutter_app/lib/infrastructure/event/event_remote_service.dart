import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/feed/event_and_post_carrier.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:http/http.dart';

import '../feed/event_and_post_carrier_dtos.dart';
import '../post/post_dtos.dart';

class EventRemoteService extends RemoteService<EventDto> {
  static const String eventByIdPath = "/event/";

  //Routes Lists
  static const String ownedEventsPath =
      "/user/events/%amount%/%lastEventTime%/%descending%";
  static const String ownedEventsUpcomingPath =
      "/user/events/upcoming/%amount%/%lastEventTime%/%descending%";
  static const String profileEventPath =
      "/profile/events/%profileId%/%amount%/%lastEventTime%/%descending%";
  static const String profileEventUpcomingPath =
      "/profile/events/upcoming/%profileId%/%amount%/%lastEventTime%/%descending%";
  static const String profileEventRecentPath =
      "/profile/events/recent/%profileId%/%amount%/%lastEventTime%/%descending%";
  static const String recentEventPath =
      "/profile/recent/events/%amount%/%lastEventTime%/%descending%";
  static const String invitedEventsPath =
      "/user/events/invited/%amount%/%lastEventTime%/%descending%";
  static const String attendingEventsPath =
      "/event/reacted/%amount%/%lastEventTime%/%status%/%descending%"; //TODO attending?
  static const String nearestEventsPath =
      "/event/distance/%latitude%/%longitude%/%distance%/%amount%/%lastEventTime%/%descending%"; //TODO attending?
  static const String unreactedEventsPath =
      "/user/events/%amount%/%lastEventTime%/"; //TODO reaction?
  static const String searchEventsPath =
      "/event/search/%needle%/%amount%/%last%/";
  static const String eventsOfInterestPath =
      "/events/userInterest/%amount%/%lastEventTime%";
  static const String eventConfirmUser =
      "/user/eventStatus/%eventId%/%longitude%/%latitude%/confirm";

  //event search name maxresults last
  static const String feedPath =
      "/mainfeedreal/%latitude%/%longitude%/%distance%/%maxResults%/%last%";

  // TODO combine it to event path?
  static const String postPath = "/event";
  static const String deletePath = "/event/";
  static const String updatePath = "/event/edit/";
  static const String changeStatusPath = "/user/eventStatus/%eventId%/%status%";

  static const String uploadMainImage = '/event/uploadImage/%eventId%';
  static const String uploadImage = '/upload/profileEventImage/%eventId%';

  static const String nextAttendingEventPath = '/event/nextAttending';

  final SymfonyCommunicator client;

  EventRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ?? SymfonyCommunicator();

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

  Future<EventDto?> getNextAttendingEvent() async {
    final Response response = await client.get(nextAttendingEventPath);
    final List<EventDto?> eventDto = await convertList(response);
    if (eventDto.isNotEmpty) return eventDto.first;
  }

  Future<List<EventDto>> getSearchedEvents(
      String searchString, int amount, DateTime last) async {
    return _getEventList(searchEventsPath.interpolate({
      "needle": searchString,
      "amount": amount.toString(),
      "last": last.toString()
    }));
  }

  Future<List<EventDto>> getInvitedEvents(DateTime lastEventTime, int amount,
      [bool descending = false]) async {
    return _getEventList(invitedEventsPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending ? '1' : '0',
    }));
  }

  Future<List<EventDto>> getEventsOfInterest(
      DateTime lastEventTime, int amount) async {
    return _getEventList(eventsOfInterestPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
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

  Future<List<EventDto>> getEventsFromUserUpcoming(
      DateTime lastEventTime, int amount, UniqueId profileId,
      [bool descending = false]) async {
    return _getEventList(profileEventUpcomingPath.interpolate({
      "profileId": profileId.value,
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending.toString()
    }));
  }

  Future<List<EventDto>> getEventsFromUserRecent(
      DateTime lastEventTime, int amount, UniqueId profileId,
      [bool descending = false]) async {
    return _getEventList(profileEventRecentPath.interpolate({
      "profileId": profileId.value,
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending.toString()
    }));
  }

  Future<List<EventDto>> getAttendingEvents(
      //TODO attending events?
      DateTime lastEventTime,
      int amount,
      {bool descending = false,
      int status = 1}) async {
    return _getEventList(attendingEventsPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      //1 for attending 2 for interested
      "status": status.toString(),
      "descending": descending ? '1' : '0',
    }));
  }

  Future<List<EventDto>> searchNearEvents(double latitude, double longitude,
      int distance, DateTime lastEventTime, int amount,
      {bool descending = false}) async {
    return _getEventList(nearestEventsPath.interpolate({
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "distance": distance.toString(),
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending ? '1' : '0',
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

  Future<List<EventDto>> getRecentEvents(
      //TODO reaction?
      DateTime lastEventTime,
      int amount,
      [bool descending = true]) async {
    return _getEventList(recentEventPath.interpolate({
      "amount": amount.toString(),
      "lastEventTime": lastEventTime.toString(),
      "descending": descending ? '1' : '0'
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

    return _decodeEvent(
        await client.put(
            changeStatusPath.interpolate({
              "eventId": eventDto.id,
              "status": (EventDto.domainToDtoStatus[status] as int).toString()
            }),
            ""),
        'event');
  }

  Future<EventDto> updateEvent(EventDto eventDto) async {
    return _decodeEvent(await client.put(
        "$updatePath${eventDto.id}", jsonEncode(eventDto.toJson())));
  }

  Future<void> uploadMainImageToEvent(String eventId, File image) async {
    client.postFile(uploadMainImage.interpolate({"eventId": eventId}), image);
  }

  Future<String> uploadImageToEvent(String eventId, File image) async {
    return client.postFile(
        uploadImage.interpolate({"eventId": eventId}), image);
  }

  /*static String generatePaginatedRoute(
      String route, int amount, DateTime lastEventTime) {
    return "$route/$amount/$lastEventTime";
  }*/

  EventDto _decodeEvent(Response json, [String? arrayField]) {
    if (arrayField == null) {
      return EventDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
    } else {
      return EventDto.fromJson(
          jsonDecode(json.body)[arrayField] as Map<String, dynamic>);
    }
  }

  Future<List<EventDto>> _getEventList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }

  Future<EventAndPostCarrierDto> _getFeedList(String path) async {
    final Response response = await client.get(path);
    response.headers.addAll({HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    final data = jsonDecode(response.body);
    final eventsData = data["events"];
    final postsData = data["posts"];
    final eventsResp = Response(jsonEncode(eventsData), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    final postsResp = Response(jsonEncode(postsData), 200, headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'});
    final List<EventDto> eventsDto =
        await covertListForeign<EventDto>(eventsResp);
    final List<PostDto> postsDto = await covertListForeign<PostDto>(postsResp);
    return EventAndPostCarrierDto(eventsDto: eventsDto, postsDto: postsDto);
  }

  Future<bool> confirmUserAtEvent(
      String eventId, double longitude, double latitude) async {
    final Response response = await client.post(
        eventConfirmUser.interpolate({
          "eventId": eventId.toString(),
          "longitude": longitude.toString(),
          "latitude": latitude.toString()
        }),
        "$longitude+$latitude");
    return true;
  }

  Future<List<EventDto>> getFeed(double latitude, double longitude,
      int distance, int maxResults, DateTime lastEventTime) async {
    return _getEventList(feedPath.interpolate({
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "distance": distance.toString(),
      "maxResults": maxResults.toString(),
      "last": lastEventTime.toString(),
    }));
  }

  Future<EventAndPostCarrierDto> getFeedEventsPost(
      double latitude,
      double longitude,
      int distance,
      int maxResults,
      DateTime lastEventTime) async {
    return _getFeedList(feedPath.interpolate({
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "distance": distance.toString(),
      "maxResults": maxResults.toString(),
      "last": lastEventTime.toString(),
    }));
  }
}
