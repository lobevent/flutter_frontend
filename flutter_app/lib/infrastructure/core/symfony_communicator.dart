import 'dart:convert';
import 'dart:io';

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/core/Utils/LoginControllFunctions.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/data/storage_shared.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/auth/current_login.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../main.dart';
import 'exceptions.dart';

class SymfonyCommunicator {
  Client client;
  static final String url = dotenv.env['ipSim']!.toString();
  Map<String, String> headers;
  String? jwt;

  SymfonyCommunicator({this.jwt, Client? client})
      : //assert(jwt != null, "jwt must be given"),
        headers = {"Authorization": "Bearer $jwt"},
        client = client ?? Client();

  /// Get an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> get(String uri) async {
    return handleExceptions(
        await client.get(Uri.parse("$url$uri"), headers: headers));
  }

  /// Post to an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> post(String uri, dynamic body, [Encoding? encoding]) async {
    encoding ??= Encoding.getByName("text/plain");
    return handleExceptions(await client.post(Uri.parse("$url$uri"),
        headers: headers, body: body, encoding: encoding));
  }

  /// Post to an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".

  Future<String> postFile(String uri, String filepath, [Encoding? encoding]) async {
    var request = await http.MultipartRequest('POST', Uri.parse("$url$uri"));
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase!;
  }

  /// Put an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> put(String uri, dynamic body, [Encoding? encoding]) async {
    encoding ??= Encoding.getByName("text/plain");
    return handleExceptions(await client.put(Uri.parse("$url$uri"),
        headers: headers, body: body, encoding: encoding));
  }

  /// Delete resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> delete(String uri) async {
    return handleExceptions(
        await client.delete(Uri.parse("$url$uri"), headers: headers));
  }

  // after loging in or out it has to be resettet
  setJwt(String token) {
    jwt = token;
    headers = {"Authorization": "Bearer $token"};

    //fetch and save profile in sharedstorage
    GetIt.I<StorageShared>().safeOwnProfile();
  }

  /// The [requestFunction] is an lambda function, containing a request to execute
  static Future<Response> handleExceptions(Response response) async {
    // TODO any reason to give a lambda into this? We could directly pass the response or
    // TODO subclassing the Response class (like the reddit link I did sent you)
    //tried the solution with passing -> now I get that i can call await when calling a function
    if (response.statusCode / 100 == 2) {
      // return response if the statuscode is something with 200, all these are ok
      return response;
    }
    switch (response.statusCode) {
      case 401:
        LoginControllFunctions.logout();
        throw NotAuthenticatedException();
        break;
      case 403:
        throw NotAuthorizedException();
        break;
      case 404:
        throw NotFoundException();
        break;
      case 500:
        throw InternalServerException();
        break;
      default:
        throw CommunicationException();
        break; //return the baseclass for all other codes
    }
  }
}
