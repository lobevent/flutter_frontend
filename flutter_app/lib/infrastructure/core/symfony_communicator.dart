import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart';

import 'exceptions.dart';

class SymfonyCommunicator{
  Client client;
  final String url = "ourUrl.com";
  final Map<String, String> headers;

  SymfonyCommunicator({@required String jwt, Client client})
    : assert(client != null, "client must be given"),
      assert(jwt != null, "jwt must be given"),
      headers = {"Authentication": "Baerer $jwt"},
      client = client ?? Client();


  /// Get an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> get(String uri) async{
    return _handleExceptions( await client.get("$url$uri", headers: headers));
  }

  /// Post to an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> post(String uri, dynamic body, [Encoding encoding]) async{
    encoding ??= Encoding.getByName("text/plain");
    return _handleExceptions( await client.post("$url$uri", headers: headers, body: body, encoding: encoding));
  }

  /// Put an resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> put(String uri, dynamic body, [Encoding encoding]) async{
    encoding ??= Encoding.getByName("text/plain");
    return _handleExceptions( await client.put("$url$uri", headers: headers, body: body, encoding: encoding)) ;
  }

  /// Delete resource with uri.
  /// Throws [NotAuthenticatedException], [NotAuthorizedException], [NotFoundException], [InternalServerException]
  /// The id (if needed) should be in the uri.
  /// Uri has to start with an backslash "/".
  Future<Response> delete(String uri) async {
    return _handleExceptions( await client.delete("$url$uri", headers: headers));
  }


  /// The [requestFunction] is an lambda function, containing a request to execute
  Future<Response> _handleExceptions(Response response) async {
      // TODO any reason to give a lambda into this? We could directly pass the response or
      // TODO subclassing the Response class (like the reddit link I did sent you)
      //tried the solution with passing -> now I get that i can call await when calling a function
      switch (response.statusCode) {
        case 401:
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
          return response; break;
      }
  }
}