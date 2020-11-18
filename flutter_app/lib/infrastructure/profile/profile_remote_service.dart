import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

import 'package:http/http.dart';

class ProfileRemoteService {
  static const String _profileIdPath = ""; //TODO dont know path
  static const String _searchProfilePath = "/profile/search/{name}";
  static const String _deleteProfilePicture = "/profile/{id}";
  static const String _changeProfilePicture = "/profile/{id}";
  static const String _changePassword = "/password";
  static const String _attendingUsersPath = ""; //TODO no existing path
  static const String _followerPath = ""; //TODO no existing path
  static const String _postProfilePath = ""; //TODO no existing path

  static const String postPath = "/profile";

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

  Future<ProfileDto> create(ProfileDto profile) async {
    return _decodeProfile( await client.post(postPath, jsonEncode(profile.toJson())));
  }

  Future<void> delete(ProfileDto profile) async {
    throw UnimplementedError();
  }

  Future<void> update(ProfileDto profileDto) {
    //TODO
    throw UnimplementedError();
  }

  Future<List<ProfileDto>> getSearchedProfile() async {
    return _getProfileList(_searchProfilePath);
  }

  Future<List<ProfileDto>> getAttendingUsersToEvent() async {
    return _getProfileList(_attendingUsersPath);
  }

  Future<List<ProfileDto>> getFollower() async {
    return _getProfileList(_followerPath);
  }

  Future<List<ProfileDto>> getProfilesToPost() async {
    return _getProfileList(_postProfilePath);
  }

  Future<List<ProfileDto>> _getProfileList(String path) async {
    final Response response = await client.get(path);
    final List<ProfileDto> profile = (jsonDecode(response.body) as List<
            Map<String,
                dynamic>>) // TODO one liners are nice for the flex xD but you already use a variable then I think it is easier to just put it into the next line
        .map((e) => ProfileDto.fromJson(e))
        .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>

    final List<Map<String, dynamic>> profilesJsonList = jsonDecode(
        response
            .body) as List<
        Map<String,
            dynamic>>; // TODO same stuff with one variable and bit cleaner still we will have to rewrite it because of the json transformation
    return profilesJsonList
        .map((profileJsonMap) => ProfileDto.fromJson(profileJsonMap))
        .toList();
  }
}
