import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:http/http.dart';


class SymfonyCommunicator{
  Client client;
  final url = "ourUrl.com";
  var header;


  SymfonyCommunicator([String jwt]){
    if(jwt != null){
      header =  {"Authentication": "Baerer $jwt"};
    }
  }
  ///get an resource with uri
  ///throws [NotAuthenticatedError], [NotAuthorizedError], [NotFoundError], [InternalServerError]
  ///the id (if needed) should be in the uri
  ///uri has to start with an backslash "/"
  Future<Response> get(String uri) async{
    return _handleErrors( () async {client.get(url+uri, headers:header); });
  }

  ///post to an resource with uri
  ///throws [NotAuthenticatedError], [NotAuthorizedError], [NotFoundError], [InternalServerError]
  ///the id (if needed) should be in the uri
  ///uri has to start with an backslash "/"
  Future<Response> post(String uri, dynamic body, [Encoding encoding]) async{
    encoding = encoding == null ? "text/plain" : encoding;
    return _handleErrors( () async {client.post(url+uri, headers:header, body: body, encoding: encoding); });
  }

  ///put an resource with uri
  ///throws [NotAuthenticatedError], [NotAuthorizedError], [NotFoundError], [InternalServerError]
  ///the id (if needed) should be in the uri
  ///uri has to start with an backslash "/"
  Future<Response> put(String uri, dynamic body, [Encoding encoding]) async{
    encoding = encoding == null ? "text/plain" : encoding;
    return _handleErrors( () async {client.put(url+uri, headers:header, body: body, encoding: encoding); }) ;
  }

  ///delete resource with uri
  ///throws [NotAuthenticatedError], [NotAuthorizedError], [NotFoundError], [InternalServerError]
  ///the id (if needed) should be in the uri
  ///uri has to start with an backslash "/"
  Future<Response> delete(String uri) async{
    return _handleErrors( () async { return client.delete(url+uri, headers:header); });
  }


  ///[requestFunction] is an lambda function, containing a request to execute
  Future<Response> _handleErrors(Function requestFunction) async{
    Response response;
    try{
      response  = await requestFunction();
      switch (response.statusCode) {
        case 401:
          throw NotAuthenticatedError(); break;
        case 403:
          throw NotAuthorizedError(); break;
        case 404:
          throw NotFoundError(); break;
        case 500:
          throw InternalServerError(); break;
        default:
          return response; break;
      }
    }on Exception catch(e){
        rethrow;
    }
  }
}