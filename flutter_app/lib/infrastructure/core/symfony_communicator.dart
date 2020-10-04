
import 'package:flutter/material.dart';
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
      case 401: break;
      case 402: break;
      case 404: break;
      case 500: break;
    }
  }
}