import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:http/http.dart';


class SymfonyCommunicator{
  Client client;
  final url = "ourUrl.com";
  var jwt = null;


  SymfonyCommunicator([String jwt]){
    if(jwt != null){
      this.jwt =jwt;
    }
  }

  Future<Response> get(String uri) async{
    Response response = await client.get(url+uri, headers:{"Authentication": "Baerer $jwt"});
    return handleErrors(response);
  }

  Future<Response> post(String uri, dynamic body) async{
    Response response = await client.post(url+uri, headers:{"Authentication": "Baerer $jwt"}, body: body);
    return handleErrors(response);
  }
  Future<Response> put(String uri, dynamic body) async{
    Response response = await client.put(url+uri, headers:{"Authentication": "Baerer $jwt"}, body: body);
    return handleErrors(response);
  }
  Future<Response> delete(String uri) async{
    Response response = await client.delete(url+uri, headers:{"Authentication": "Baerer $jwt"});
    return handleErrors(response);
  }

  Future<Response> handleErrors(Response response){
    switch (response.statusCode){
      case 401: throw NotAuthenticatedError();
      case 403: throw NotAuthorizedError();
      case 404: throw NotFoundError();
      case 500: throw InternalServerError();
    }
  }
}