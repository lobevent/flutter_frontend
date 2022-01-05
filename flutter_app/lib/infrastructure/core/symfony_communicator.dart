import 'dart:convert';

import 'package:flutter_frontend/presentation/routes/router.gr.dart'
as _app_router;

//import 'dart:html';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/infrastructure/auth/current_login.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../../main.dart';
import 'exceptions.dart';

class SymfonyCommunicator {
  Client client;
  static final String url = dotenv.env['ipSim']!.toString();
  final Map<String, String> headers;

  SymfonyCommunicator({String jwt = CurrentLogin.jwt, Client? client})
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
        GetIt.I<_app_router.Router>().popUntilRoot();(_app_router.LoginRegisterRoute());
        GetIt.I<_app_router.Router>().replace(_app_router.LoginRegisterRoute());
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
