import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:http/http.dart';

class SymfonyLogin{

  Client client;
  String url = SymfonyCommunicator.url;
  SymfonyLogin({Client? client}): client = client ?? Client();


  Future<void> login(String username, String passwort) async{
    this.loginRequest(username, passwort).then((value) => jsonDecode(value.body).token);
  }

  Future<Response> loginRequest(String username, String passwort) async {
    var encoding = Encoding.getByName("text/plain");
    return SymfonyCommunicator.handleExceptions(await client.post(Uri.parse("$url/login_check"),
        body: jsonEncode({username: username, passwort: passwort}), encoding: encoding));
  }
}