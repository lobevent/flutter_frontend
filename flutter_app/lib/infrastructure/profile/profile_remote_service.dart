import 'dart:convert';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/like/like_cubit.dart';
import 'package:http/http.dart';

class ProfileRemoteService extends RemoteService<ProfileDto> {
  static const String profileIdPath = "/profile/"; //TODO dont know path

  //commented out unused Routes
  /*static const String _deleteProfilePicture = "/profile/{id}";
  static const String _changeProfilePicture = "/profile/{id}";
  static const String _changePassword = "/password";*/

  //List Routes
  ///TODO: change the searchProfilepath page 0
  static const String searchProfilePath = "/profile/search/%needle%/%amount%/0";
  static const String attendingUsersPath = "/profile/%profileId%/%amount%/";
  static const String followerPath = "/profile/%profileId%/%amount%/";
  static const String postProfilePath = "/profile/%postId%/%amount%/";

  static const String postPath = "/profile";
  static const String deletePath = "/profile";
  static const String updatePath = "/profile";

  static const String getOpenFriendRequestsPath = "/friend/requests";
  static const String getAcceptedFriendshipsPath = "/friend/%profileId%";
  static const String sendFriendShipPath = "/friend/request/%profileId%";
  static const String acceptFriendShipPath = "/friend/accept/%profileId%";
  static const String deleteFriendShipPath = "/friend/delete/%profileId%";

  static const String getProfilesWhichLikedPath = "/likes/%objectId%";
  static const String ownLikeStatusPath = "/like/%objectId%";

  static const String eventLikePath = "/event/%objectId%/like";
  static const String postLikePath = "/post/%objectId%/like";
  static const String commentLikePath = "/comment/%objectId%/like";

  static const String eventUnLikePath = "/event/%objectId%/unlike";
  static const String postUnLikePath = "/post/%objectId%/unlike";
  static const String commentUnLikePath = "/comment/%objectId%/unlike";

  static const String addFriendsToEventPath = "/event/addFriends/";

  SymfonyCommunicator client;

  ProfileRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
            SymfonyCommunicator(); // TODO this doesn't work on runtime -> will throw an error!

  Future<ProfileDto> _decodeProfile(Response json) async {
    return ProfileDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<ProfileDto> getSingleProfile(String id) async {
    final String uri = "$profileIdPath$id";
    Response response = await client.get(uri);
    ProfileDto profileDto =
        ProfileDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return profileDto;
  }

  Future<ProfileDto> create(ProfileDto profileDto) async {
    return _decodeProfile(
        await client.post(postPath, jsonEncode(profileDto.toJson())));
  }

  Future<ProfileDto> delete(ProfileDto profileDto) async {
    return _decodeProfile(await client.delete("$deletePath${profileDto.id}"));
  }

  Future<ProfileDto> update(ProfileDto profileDto) async {
    return _decodeProfile(await client.put(
        "$updatePath${profileDto.id}", jsonEncode(profileDto.toJson())));
  }

  Future<ProfileDto> getOwnProfile() async {
    final String uri = "$profileIdPath";
    Response response = await client.get(uri);
    ProfileDto profileDto =
        ProfileDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return profileDto;
  }

  Future<List<ProfileDto>> getSearchedProfiles(
      int amount, String searchString) async {
    return _getProfileList(searchProfilePath
        .interpolate({"needle": searchString, "amount": amount.toString()}));
  }

  Future<List<ProfileDto>> getAttendingUsersToEvent(
      int amount, String profileId) async {
    return _getProfileList(attendingUsersPath
        .interpolate({"profileId": profileId, "amount": amount.toString()}));
  }

  Future<List<ProfileDto>> getFollower(int amount, String profileId) async {
    return _getProfileList(followerPath
        .interpolate({"profileId": profileId, "amount": amount.toString()}));
  }

  Future<List<ProfileDto>> getProfilesToPost(int amount, String postId) async {
    return _getProfileList(postProfilePath
        .interpolate({"postId": postId, "amount": amount.toString()}));
  }

  Future<List<ProfileDto>> _getProfileList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }

  ///Friendship functionalities (maybe put them in a seperate class)
  Future<String> sendFriendship(String profileId) async {
    final Response response = await client.post(
        sendFriendShipPath.interpolate({"profileId": profileId}), profileId);
    return response.body;
  }

  Future<bool> acceptFriendRequest(String profileId) async {
    final Response response = await client.post(
        acceptFriendShipPath.interpolate({"profileId": profileId}), profileId);
    return response.body.isNotEmpty;
  }

  Future<bool> deleteFriendRequest(String profileId) async {
    final Response response = await client
        .delete(deleteFriendShipPath.interpolate({"profileId": profileId}));
    return response.body.isNotEmpty;
  }

  Future<List<ProfileDto>> getOpenFriendRequests() async {
    final Response response = await client.get(getOpenFriendRequestsPath);
    return convertList(response);
  }

  ///TODO Paginate the query to make use of the parentfunction with amount
  Future<List<ProfileDto>> getAcceptedFriendships(String? profileId) async {
    final Response response;
    if (profileId == null) {
      response = await client
          .get(getAcceptedFriendshipsPath.interpolate({"profileId": ""}));
    } else {
      response = await client.get(
          getAcceptedFriendshipsPath.interpolate({"profileId": profileId}));
    }
    return convertList(response);
  }

  ///Like functionalities

  ///returns a list of profiles, which liked an entity (event,post,comment)
  Future<List<ProfileDto>> getProfilesWhichLiked(String objectId) async {
    final Response response;

    response = await client
        .get(getProfilesWhichLikedPath.interpolate({"objectId": objectId}));
    return convertList(response);
  }

  ///get own like status for showing indicator if already liked
  Future<bool> getOwnLikeStatus(String objectId) async {
    final Response response =
        await client.get(ownLikeStatusPath.interpolate({"objectId": objectId}));
    return response.body.length > 2;
  }

  Future<bool> like(String objectId, LikeTypeOption option) async {
    final Response response;
    //switch between the different routes for the different entity types
    switch (option) {
      case LikeTypeOption.Event:
        response = await client.post(
            eventLikePath.interpolate({"objectId": objectId}), objectId);
        break;
      case LikeTypeOption.Post:
        response = await client.post(
            postLikePath.interpolate({"objectId": objectId}), objectId);
        break;
      case LikeTypeOption.Comment:
        response = await client.post(
            commentLikePath.interpolate({"objectId": objectId}), objectId);
        break;
    }
    return response.body.isNotEmpty;
  }

  Future<bool> unlike(String objectId, LikeTypeOption option) async {
    final Response response;
    //switch between the different routes for the different entity types
    switch (option) {
      case LikeTypeOption.Event:
        response = await client.post(
            eventUnLikePath.interpolate({"objectId": objectId}), objectId);
        break;
      case LikeTypeOption.Post:
        response = await client.post(
            postUnLikePath.interpolate({"objectId": objectId}), objectId);
        break;
      case LikeTypeOption.Comment:
        response = await client.post(
            commentUnLikePath.interpolate({"objectId": objectId}), objectId);
        break;
    }
    return response.body.isNotEmpty;
  }

  Future<List<ProfileDto>> addFriendsToEvent(
      List<ProfileDto> friends, Event event) async {
    final Response response = await client.put(
        "$addFriendsToEventPath${event.id.value}",
        jsonEncode(friends.map((e) => e.toJson())));
    return convertList(response);
  }
}
