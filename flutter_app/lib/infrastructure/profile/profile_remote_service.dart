import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:http/http.dart';

class ProfileRemoteService  extends RemoteService<ProfileDto>{
  static const String _profileIdPath = ""; //TODO dont know path

  //commented out unused Routes
  /*static const String _deleteProfilePicture = "/profile/{id}";
  static const String _changeProfilePicture = "/profile/{id}";
  static const String _changePassword = "/password";*/

  //List Routes
  static const String _searchProfilePath = "/profile/%profileId%/%amount%/";
  static const String _attendingUsersPath = "/profile/%profileId%/%amount%/";
  static const String _followerPath = "/profile/%profileId%/%amount%/";
  static const String _postProfilePath = "/profile/%postId%/%amount%/";

  static const String postPath = "/profile";
  static const String deletePath = "/profile";
  static const String updatePath = "/profile";

  SymfonyCommunicator client;

  ProfileRemoteService() {
    client = SymfonyCommunicator(jwt: null); // TODO check on this one
  }

  Future<ProfileDto> _decodeProfile(Response json) async {
    return ProfileDto.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  Future<ProfileDto> getSingleProfile(int id) async {
    final String uri = "$_profileIdPath$id";
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
        _searchProfilePath.interpolate(
            {"profileId" : profileId, "amount" : amount.toString()}));
    }

  Future<List<ProfileDto>> getAttendingUsersToEvent(int amount, String profileId) async {
    return _getProfileList(
        _attendingUsersPath.interpolate(
            {"profileId" : profileId, "amount" : amount.toString()}));
  }

  Future<List<ProfileDto>> getFollower(int amount, String profileId) async {
    return _getProfileList(
        _followerPath.interpolate(
        {"profileId" : profileId, "amount" : amount.toString()}));
  }

  Future<List<ProfileDto>> getProfilesToPost(int amount, String postId) async {
    return _getProfileList(
        _postProfilePath.interpolate(
        {"postId" : postId, "amount" : amount.toString()}));
  }

  Future<List<ProfileDto>> _getProfileList(String path) async {
    final Response response = await client.get(path);
    return convertList(response);
  }
}
