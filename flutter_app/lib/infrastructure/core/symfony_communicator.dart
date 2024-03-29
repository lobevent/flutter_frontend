import 'dart:convert';
import 'dart:io';

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/core/Utils/LoginControllFunctions.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/auth/current_login.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../main.dart';
import 'exceptions.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class SymfonyCommunicator {
  Client client;
  static final String url = dotenv.env['ipSim']!.toString();
  Map<String, String> headers;
  String? jwt;

  SymfonyCommunicator({this.jwt, Client? client})
      : //assert(jwt != null, "jwt must be given"),
        headers = {"Authorization": "Bearer $jwt", HttpHeaders.contentTypeHeader : 'application/json; charset=utf-8'},
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

  Future<String> postFile(String uri, File file, [Encoding? encoding]) async {
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();

    var uploadUri = Uri.parse("$url$uri");

    var request = new http.MultipartRequest("POST", uploadUri);
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(file.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);

    return response.stream.bytesToString();
    return response.reasonPhrase!;

    // var request = await http.MultipartRequest('POST', Uri.parse("$url$uri"));
    // request.files.add(await http.MultipartFile.fromPath('image', filepath));
    // var res = await request.send();
    // return res.reasonPhrase!;
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
    //GetIt.I<StorageShared>().safeOwnProfile();
    CommonHive.safeOwnProfileIdAndPic();
  }

  /// The [requestFunction] is an lambda function, containing a request to execute
  static Future<Response> handleExceptions(Response response) async {
    // TODO subclassing the Response class (like the reddit link I did sent you)
    //tried the solution with passing -> now I get that i can call await when calling a function
    if (response.statusCode ~/ 100 == 2) {
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
