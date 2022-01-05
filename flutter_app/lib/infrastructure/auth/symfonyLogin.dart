import 'dart:convert';

import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class SymfonyLogin{

  Client client;
  String url = SymfonyCommunicator.url;
  SymfonyLogin({Client? client}): client = client ?? Client();


  // extern callable and saves token
  Future<void> login(String username, String passwort) async{
    this.loginRequest(username, passwort).then(
            (value) {
              var test = jsonDecode(value.body);
              GetIt.I<AuthTokenService>().safeToken(jsonDecode(value.body)["token"] as String);
            });
  }

  // sending the login request in backend
  Future<Response> loginRequest(String username, String passwort) async {
    return SymfonyCommunicator.handleExceptions(await client.post(Uri.parse("$url/login_check"),
        body: jsonEncode({"username": username, "password": passwort}), headers: {"Content-Type": "application/json"}));
  }
}