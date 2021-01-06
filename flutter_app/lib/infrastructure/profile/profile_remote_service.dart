import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:http/http.dart';

class ProfileRemoteService  extends RemoteService<ProfileDto>{
  static const String profileIdPath = "/profile"; //TODO dont know path

  //commented out unused Routes
  /*static const String _deleteProfilePicture = "/profile/{id}";
  static const String _changeProfilePicture = "/profile/{id}";
  static const String _changePassword = "/password";*/

  //List Routes
  static const String searchProfilePath = "/profile/%profileId%/%amount%/";
  static const String attendingUsersPath = "/profile/%profileId%/%amount%/";
  static const String followerPath = "/profile/%profileId%/%amount%/";
  static const String postProfilePath = "/profile/%postId%/%amount%/";

  static const String postPath = "/profile";
  static const String deletePath = "/profile";
  static const String updatePath = "/profile";

  SymfonyCommunicator client;

  ProfileRemoteService({SymfonyCommunicator communicator})
      : client = communicator ??
      SymfonyCommunicator(
          jwt:
          null); // TODO this doesn't work on runtime -> will throw an error!

  Future<ProfileDto> _decodeProfile(Response json) async {
    return ProfileDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<ProfileDto> getSingleProfile(int id) async {
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
    return _decodeProfile(
    await client.delete("$deletePath${profileDto.id}"));

  }

  Future<ProfileDto> update(ProfileDto profileDto) async {
    return _decodeProfile(
    await client.put(
        "$updatePath${profileDto.id}", jsonEncode(profileDto.toJson())));
  }

  Future<List<ProfileDto>> getSearchedProfiles(int amount, String profileId) async {
    return _getProfileList(
        searchProfilePath.interpolate(
            {"profileId" : profileId, "amount" : amount.toString()}));
    }

  Future<List<ProfileDto>> getAttendingUsersToEvent(int amount, String profileId) async {
    return _getProfileList(
        attendingUsersPath.interpolate(
            {"profileId" : profileId, "amount" : amount.toString()}));
  }

  Future<List<ProfileDto>> getFollower(int amount, String profileId) async {
    return _getProfileList(
        followerPath.interpolate(
        {"profileId" : profileId, "amount" : amount.toString()}));
  }

  Future<List<ProfileDto>> getProfilesToPost(int amount, String postId) async {
    return _getProfileList(
        postProfilePath.interpolate(
        {"postId" : postId, "amount" : amount.toString()}));
  }

  Future<List<ProfileDto>> _getProfileList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }
}
